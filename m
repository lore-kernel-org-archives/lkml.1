Return-Path: <linux-kernel-owner+w=401wt.eu-S933106AbXBVPz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106AbXBVPz7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 10:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933108AbXBVPz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 10:55:59 -0500
Received: from nz-out-0506.google.com ([64.233.162.235]:6262 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933106AbXBVPz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 10:55:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=H8DYabeoWOnK6Rw3gs3C++/SlV1C+qfPcVwTzu+AMk0NfjHWGyxHGgeZGExf1vJbU5FVJ1dizSqKTZV40JKzyAlLxaVobvIX5o4gipEX4RDlTx1SF7h8dBPMw7XQNcXn970bHtGwvGtrG5xLfszgirr1F68Y4+oOmbrvF0q9jak=
Message-ID: <cb7bb73a0702220755y3eb2e5b1r8e7908ae0c1720c9@mail.gmail.com>
Date: Thu, 22 Feb 2007 16:55:56 +0100
From: "Giuseppe Bilotta" <giuseppe.bilotta@gmail.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: [Linux-fbdev-devel] [PATCH] nvidiafb: allow ignoring EDID info
Cc: "James Simmons" <jsimmons@infradead.org>,
       "Luca Tettamanti" <kronos@people.it>,
       linux-fbdev-devel@lists.sourceforge.net,
       "Andrew Morton" <akpm@osdl.org>, "Dave Airlie" <airlied@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1172153358.4306.17.camel@daplas>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ephv35$4i3$1@sea.gmane.org>
	 <20070130203301.GA15067@dreamland.darkstar.lan>
	 <20070204201713.GA12867@dreamland.darkstar.lan>
	 <Pine.LNX.4.64.0702062034380.9224@pentafluge.infradead.org>
	 <cb7bb73a0702061508x767882dcia1b13f85d898b6e7@mail.gmail.com>
	 <1172101406.4217.16.camel@daplas>
	 <cb7bb73a0702220001u6acbdd95ncdc9fad10d06b421@mail.gmail.com>
	 <1172133646.4086.5.camel@daplas>
	 <cb7bb73a0702220548s55380f7fk995726ffd349823b@mail.gmail.com>
	 <1172153358.4306.17.camel@daplas>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/22/07, Antonino A. Daplas <adaplas@gmail.com> wrote:
>
> Ah, my fault.  Apply this patch on top.

We're getting closer! The patch now works, and the dmesg has the following info:


ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNKA] -> GSI 11 (level,
low) -> IRQ 11
nvidiafb: Device ID: 10de0112
fbmon: The EDID Block of Manufacturer: SHP Model: 0x138e is known to be broken,
fbmon: trying to fix monitor timings
nvidiafb: EDID found from BUS2
========================================
Display Information (EDID)
========================================
   EDID Version 1.3
   Manufacturer: SHP
   Model: 138e
   Serial#: 0
   Year: 1990 Week 0
   Display Characteristics:
      Monitor Operating Limits: From EDID
           H: 30-75KHz V: 60-60Hz DCLK: 170MHz
      Digital Display Input
      Sync:
      Max H-size in cm: 30
      Max V-size in cm: 23
      Gamma: 2.20
      DPMS: Active no, Suspend yes, Standby yes
      RGB Color Display
      Chroma
         RedX:     0.599 RedY:     0.335
         GreenX:   0.313 GreenY:   0.552
         BlueX:    0.150 BlueY:    0.145
         WhiteX:   0.313 WhiteY:   0.328
      First DETAILED Timing is preferred
   Detailed Timings
      160 MHz 1600 1664 1856 2112 1200 1201 1204 1250 -HSync -VSync

   Supported VESA Modes
      Manufacturer's mask: 0
   Standard Timings
      1600x1200@60Hz
========================================
nvidiafb: CRTC 1 is currently programmed for DFP
nvidiafb: Using DFP on CRTC 1
nvidiafb: Panel size is 1600 x 1200
nvidiafb: Panel is TMDS
nvidiafb: MTRR set to ON
nvidiafb: Flat panel dithering disabled
Console: switching to colour frame buffer device 200x75
nvidiafb: PCI nVidia NV11 framebuffer (32MB @ 0xE0000000)




However, I'm still getting the same snowy effects, which doesn't come
as a surprise since the actual mode timings used are just the same ...


-- 
Giuseppe "Oblomov" Bilotta
