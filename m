Return-Path: <linux-kernel-owner+w=401wt.eu-S1758812AbYDBUGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758812AbYDBUGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 16:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755365AbYDBUFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 16:05:51 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:42179 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755344AbYDBUFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 16:05:50 -0400
Date: Wed, 2 Apr 2008 16:05:49 -0400
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Frans Pop <elendil@planet.nl>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: No IDE drivers loaded for Toshiba Satellite 320 CDS
Message-ID: <20080402200549.GC24239@csclub.uwaterloo.ca>
References: <200804021524.27222.elendil@planet.nl> <200804021833.49295.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804021833.49295.linux@rainbow-software.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 06:33:46PM +0200, Ondrej Zary wrote:
> On Wednesday 02 April 2008 15:24:26 Frans Pop wrote:
> > Output of lspci -nn:
> > 00:00.0 Host bridge [0600]: Toshiba America Info Systems CPU to PCI bridge
> > [1179:0601] (rev a0)
> > 00:04.0 VGA compatible controller [0300]: Chips and Technologies F65555
> > HiQVPro [102c:00e5] (rev c6)
> > 00:0b.0 USB Controller [0c03]: NEC Corporation USB [1033:0035] (rev 02)
> > 00:11.0 Communication controller [0780]: Toshiba America Info Systems FIR
> > Port [1179:0701] (rev 21)
> > 00:13.0 CardBus bridge [0607]: Toshiba America Info Systems ToPIC97
> > [1179:060f] (rev 20)
> > 00:13.1 CardBus bridge [0607]: Toshiba America Info Systems ToPIC97
> > [1179:060f] (rev 20)
> 
> Looks like the controller is not a separate PCI device. Toshiba provides Bus 
> Mastering driver for Windows 95:
> http://209.167.114.38/support/download/files_Archive/Index/windows_95_files.htm
> 
> So the controller probably can do DMA but it's not a standard IDE controller. 
> And looks like there's no driver in the kernel for it.

I don't think that bus master package is for that machine.  The
datasheet for it mentioned PIO4 max.  I think the BUSIDE.EXE is for
machines with the early PIIX controller (which that particular machine
clearly doesn't have since it has no PCI IDE controller).

-- 
Len Sorensen
