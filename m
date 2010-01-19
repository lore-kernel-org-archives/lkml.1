Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518Ab0ASQcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab0ASQcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 11:32:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940Ab0ASQcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 11:32:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:36092 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab0ASQcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 11:32:52 -0500
Date: Tue, 19 Jan 2010 16:32:40 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
cc: dri-devel@lists.sourceforge.net,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Font selection with i915
In-Reply-To: <Pine.LNX.4.44L0.1001171154220.21718-100000@netrider.rowland.org>
Message-ID: <alpine.LFD.2.00.1001191625420.29861@casper.infradead.org>
References: <Pine.LNX.4.44L0.1001171154220.21718-100000@netrider.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> When Fedora 12 loads i915 during initramfs probing on my system, the
> driver automatically installs a tiny 160x64 font.  How can I prevent it
> from doing this, or tell it to use a larger 80x25 font instead?
> 
> Is this documented anywhere?

Not really. Here is how you enable larger fonts. Configure your kernel. Go
into the Graphics support menu. This the the menu that has the 
DRI/Framebuffer and backlight options. You will see a "Console display 
driver support" option. Select it and you will have a new menu. You will 
see the option "Select compiled-in fonts". Enable that and select the font 
you want. Most likely it will be the Sun 12x22 font. Build your kernel.

Their might be one more setup to do. Some distros like to load a console 
font at boot up. Depending on the distro if that is the case you will have 
to disable it.

> In addition, are the error messages in the following dmesg log anything 
> to be concerned about?  They appear during every boot:
> 
> 
> [drm] Initialized drm 1.1.0 20060810
> i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> i915 0000:00:02.0: setting latency timer to 64
> fbcon: inteldrmfb (fb0) is primary device
> render error detected, EIR: 0x00000010
> [drm:i915_handle_error] *ERROR* EIR stuck: 0x00000010, masking
> render error detected, EIR: 0x00000010
> [drm] DAC-5: set mode 1280x1024 16
> Console: switching to colour frame buffer device 160x64
> fb0: inteldrmfb frame buffer device
> registered panic notifier
> [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0

No idea here.
