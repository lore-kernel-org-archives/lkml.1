Return-Path: <linux-kernel-owner+w=401wt.eu-S1760629AbYDCIXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760629AbYDCIXz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 04:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751176AbYDCIXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 04:23:39 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:32903 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbYDCIXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 04:23:38 -0400
Date: Thu, 3 Apr 2008 11:23:36 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Denys Fedoryshchenko <denys@visp.net.lb>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net
Subject: Re: atyfb rmmod & vram crash, 2.6.24, 2.6.25-rc8
Message-ID: <20080403082336.GD16619@sci.fi>
Mail-Followup-To: Denys Fedoryshchenko <denys@visp.net.lb>,
	linux-kernel@vger.kernel.org,
	linux-fbdev-devel@lists.sourceforge.net
References: <20080402124854.M56647@visp.net.lb>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080402124854.M56647@visp.net.lb>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 03:54:12PM +0300, Denys Fedoryshchenko wrote:
> VGA card i dont know how much RAM there actually, but lspci here shows looks
> like 16MB:
> 
> 03:09.0 VGA compatible controller: ATI Technologies Inc 3D Rage Pro 215GP (rev
> 5c) (prog-if 00 [VGA controller])
>         Subsystem: ATI Technologies Inc Rage Pro Turbo
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping+ SERR- FastB2B- DisINTx-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 66 (2000ns min), Cache Line Size: 32 bytes
>         Interrupt: pin A routed to IRQ 21
>         Region 0: Memory at f0000000 (32-bit, prefetchable) [size=16M]

This region is always 16MB regardless of how much actual RAM is on the
card.

> Loading without parameters
> 
> atyfb: using auxiliary register aperture
> atyfb: 3D RAGE PRO (Mach64 GP, PQFP, PCI) [0x4750 rev 0x7c]
> atyfb: Mach64 BIOS is located at c0000, mapped at c00c0000.
> atyfb: BIOS frequency table:
> atyfb: PCLK_min_freq 984, PCLK_max_freq 23600, ref_freq 2950, ref_divider 64
> atyfb: MCLK_pwd 4200, MCLK_max_freq 7500, XCLK_max_freq 10000, SCLK_freq 5000
> atyfb: 8M SGRAM (1:1), 29.498928 MHz XTAL, 236 MHz PLL, 75 Mhz MCLK, 100 MHz XCLK
> atyfb: fb0: ATY Mach64 frame buffer device on PCI
> 
> It detects 8M.
> If i put parameter vram=8

The vram paramter takes KB not MB.

Why do you want to override it anyway? It seems to detect the amount of
RAM just fine.

> And most interesting when i do rmmod
> tv1 ~ # rmmod atyfb
> Segmentation fault

Does this only happen after the failure caused by the bad vram parameter?

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
