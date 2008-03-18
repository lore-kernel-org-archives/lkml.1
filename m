Return-Path: <linux-kernel-owner+w=401wt.eu-S1755721AbYCSTc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721AbYCSTc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756AbYCST01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:26:27 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2105 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752284AbYCSTZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:25:12 -0400
Date: Tue, 18 Mar 2008 15:24:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Tino Keitel <tino.keitel@gmx.de>
cc: Jiri Kosina <jkosina@suse.cz>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: broken access to a USB HID device after suspend
In-Reply-To: <20080318191213.GA2290@eazy.amigager.de>
Message-ID: <Pine.LNX.4.44L0.0803181522180.18346-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2008, Tino Keitel wrote:

> Hi again,
> 
> I now have CONFIG_USB_DEBUG enabled, and the bug occurred again. Here
> is the kernel log:
> 
> 2008-03-18_19:08:50.59598 kern.debug: usb usb3: usb auto-resume
> 2008-03-18_19:08:50.59606 kern.debug: usb usb3: wakeup_rh
> 2008-03-18_19:08:50.62971 kern.debug: hub 3-0:1.0: hub_resume
> 2008-03-18_19:08:50.62977 kern.debug: hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
> 2008-03-18_19:08:50.62994 kern.debug: usb usb4: usb auto-resume
> 2008-03-18_19:08:50.62998 kern.debug: usb usb4: wakeup_rh
> 2008-03-18_19:08:50.66637 kern.debug: hub 4-0:1.0: hub_resume
> 2008-03-18_19:08:50.66644 kern.debug: hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
> 2008-03-18_19:08:50.66662 kern.debug: usb usb2: usb auto-resume
> 2008-03-18_19:08:50.66666 kern.debug: usb usb2: wakeup_rh
> 2008-03-18_19:08:50.70342 kern.debug: hub 2-0:1.0: hub_resume
> 2008-03-18_19:08:50.70348 kern.debug: hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
> 2008-03-18_19:08:51.84851 kern.debug: usb usb3: suspend_rh (auto-stop)
> 2008-03-18_19:08:51.84858 kern.debug: usb usb4: suspend_rh (auto-stop)
> 2008-03-18_19:08:51.84862 kern.debug: usb usb2: suspend_rh (auto-stop)
> 2008-03-18_19:08:53.34640 kern.debug: hub 3-0:1.0: hub_suspend
> 2008-03-18_19:08:53.34646 kern.debug: usb usb3: bus auto-suspend
> 2008-03-18_19:08:53.34650 kern.debug: usb usb3: suspend_rh
> 2008-03-18_19:08:53.34654 kern.debug: hub 4-0:1.0: hub_suspend
> 2008-03-18_19:08:53.34658 kern.debug: usb usb4: bus auto-suspend
> 2008-03-18_19:08:53.34662 kern.debug: usb usb4: suspend_rh
> 2008-03-18_19:08:53.34666 kern.debug: hub 2-0:1.0: hub_suspend
> 2008-03-18_19:08:53.34670 kern.debug: usb usb2: bus auto-suspend
> 2008-03-18_19:08:53.34674 kern.debug: usb usb2: suspend_rh
> 2008-03-18_19:09:00.70316 kern.debug: usb 1-1.3: hidmon timed out on ep0in len=0/9
> 2008-03-18_19:09:00.70322 kern.debug: usb 1-1.3: usbfs: USBDEVFS_CONTROL failed cmd hidmon rqt 129 rq 6 len 9 ret -110
> 2008-03-18_19:09:00.70339 kern.debug: usb 1-1.3: manual set_interface for iface 0, alt 0

This isn't enough.  I need the log starting from before the suspend,
including _all_ the kernel messages, not just the debugging messages.  
I also need the usbmon trace.

Alan Stern

