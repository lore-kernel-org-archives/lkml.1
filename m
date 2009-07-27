Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382AbZG0Rnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbZG0Rnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 13:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbZG0Rnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 13:43:40 -0400
Received: from outbound-mail-131.bluehost.com ([67.222.39.21]:42109 "HELO
	outbound-mail-131.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750966AbZG0Rnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 13:43:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=uHu9nYDPV8VildI0URAqrEx6/FuukEfeUwUZIAb7lknTsn3VGlO0iZYvEQ//pw165L7lgIX5POn2xQiHlz8W/fITBTp+gVz8hLctrCXCNy1zYT9CmNs39A3XynJLh94G;
Date: Mon, 27 Jul 2009 10:43:35 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [drm:i915_driver_irq_handler] *ERROR* EIR stuck: 0x00000010,
 masking
Message-ID: <20090727104335.0a9a1556@jbarnes-g45>
In-Reply-To: <4A6DE5C0.4000607@gmail.com>
References: <dd18b0c30907261812p673a3ab3p8dd7ca41465c7f05@mail.gmail.com>
	<20090727101524.778c83ab@jbarnes-g45>
	<4A6DE5C0.4000607@gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jul 2009 10:37:04 -0700
"Justin P. Mattock" <justinmattock@gmail.com> wrote:

> Jesse Barnes wrote:
> > On Sun, 26 Jul 2009 21:12:49 -0400
> > Justin Mattock<justinmattock@gmail.com>  wrote:
> >
> >    
> >> to my surprise this machine still works...
> >> (dell inspiron 1200)
> >> Anyways in dmesg I see:
> >>
> >> [   10.188083] b43-pci-bridge 0000:03:00.0: setting latency timer
> >> to 64 [   10.191947] ssb: Sonics Silicon Backplane found on PCI
> >> device 0000:03:00.0 [   10.220248] fb: conflicting fb hw usage
> >> inteldrmfb vs VESA VGA - removing generic driver
> >> [   10.222343] Console: switching to colour dummy device 80x25
> >> [   10.225625] Console: switching to colour frame buffer device
> >> 128x48 [   10.278714] render error detected, EIR: 0x00000010
> >> [   10.278717] page table error
> >> [   10.278720]   PGTBL_ER: 0x00000100
> >> [   10.278725] [drm:i915_driver_irq_handler] *ERROR* EIR stuck:
> >> 0x00000010, masking
> >> [   10.278742] render error detected, EIR: 0x00000010
> >> [   10.278745] page table error
> >> [   10.278747]   PGTBL_ER: 0x00000100
> >> [   10.290087] [drm] LVDS-8: set mode 1024x768 c
> >> [   10.640403] [drm] fb0: inteldrmfb frame buffer device
> >> [   10.640597] [drm] Initialized i915 1.6.0 20080730 for
> >> 0000:00:02.0 on minor 0 [   10.679818] b43-phy0: Broadcom 4306
> >> WLAN found (core revision 5)
> >>
> >> direct rendering still seems to be intact,
> >> suspend not sure(test in a moment).
> >>      
> >
> > Sounds like a dupe of the issue Frans reported.  We report errors
> > like this now rather than silently ignoring them.  This one must be
> > harmless or your machine wouldn't ever have worked. :)
> >
> >    
> Seems harmless to me, one thing I see is
> during the boot process Ill see the boot messages, then once
> init/udev starts up, and loads i915 the screen will go black
> for a tenth or so of a second, then goes back to normal. Now keep in
> mind this might be something suse does during the boot process.
> (I can try loading ubuntu/debian to see if the affects are the same
> once I get a chance).

Yeah that's probably just the i915 driver probing the outputs.  It
shuts everything off to avoid showing any ugly load detect patterns or
flicker.

-- 
Jesse Barnes, Intel Open Source Technology Center
