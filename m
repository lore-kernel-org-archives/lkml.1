Return-Path: <linux-kernel-owner+w=401wt.eu-S1755325AbYGTWnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbYGTWnq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 18:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbYGTWnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 18:43:39 -0400
Received: from gir.skynet.ie ([193.1.99.77]:57628 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197AbYGTWni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 18:43:38 -0400
Date: Sun, 20 Jul 2008 23:43:36 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Tino Keitel <tino.keitel@gmx.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: no direct rendering with 2.6.26 due to AGP after DRM
In-Reply-To: <20080720224204.GA16111@dose.home.local>
Message-ID: <alpine.DEB.0.82.0807202343030.22311@skynet.skynet.ie>
References: <20080720220140.GA14818@dose.home.local>
 <alpine.DEB.0.82.0807202337270.22311@skynet.skynet.ie>
 <20080720224204.GA16111@dose.home.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > 
> > > [drm] Initialized drm 1.1.0 20060810
> > > ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
> > > PCI: Setting latency timer of device 0000:00:02.0 to 64
> > > [drm:drm_fill_in_dev] *ERROR* Cannot initialize the agpgart module.
> > > DRM: Fill_in_dev failed.
> > > ...
> > > agpgart: Detected an Intel 965GM Chipset.
> > > agpgart: Detected 7676K stolen memory.
> > > agpgart: AGP aperture is 256M @ 0xe0000000
> > > 
> > 
> > For now don't built it all into the kernel :)
> > 
> > I'll see what I can dig up on init ordering.
> 
> My bad. I didn't use 2.6.26, but some git version after 2.6.26. Another
> computer with a real 2.6.26 was fine, so scratch all of the above.
> 

Yes its not in real 2.6.26 but I have a patch now, to move gpu after char 
in the Makefile..

Dave.
