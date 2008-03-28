Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbYC1AcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbYC1AcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 20:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbYC1AcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 20:32:04 -0400
Received: from styx.suse.cz ([82.119.242.94]:37753 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752394AbYC1AcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 20:32:02 -0400
Date: Fri, 28 Mar 2008 01:32:00 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Greg KH <gregkh@suse.de>, Mark Lord <lkml@rtr.ca>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
       Pavel Machek <pavel@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.25-rc7:  Ugh.
In-Reply-To: <20080327160700.GB828@suse.de>
Message-ID: <Pine.LNX.4.64.0803280126550.5541@jikos.suse.cz>
References: <47EBBD57.30902@rtr.ca> <20080327160700.GB828@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Mar 2008, Greg KH wrote:

> > It boots, but just a simple suspend/resume (RAM) was enough to kill 
> > it. It comes back on resume, with an X desktop again, but with no USB 
> > functionality -- no mouse.
> > The keyboard still works, so I dropped to a console and tried:
> >   rmmod usbhid
> >   insmod usbhid
> > And the console hung at 100% CPU on the insmod.
> Haven't heard of this one before sorry.  Jiri, have you?

No, haven't heard anything similar either. Mark, are you able to collect 
the stacktraces via alt-sysrq-t at the time the system goes crazy?

Also, as you seem to be able to easily reproduce the bug, git-bisect might 
reveal the culprit easily. For start, you can try to bisect only let's say 
usb, hid and acpi code probably ... ?

> > kernel: [  111.361099] pciehp_resume ENTRY
> > kernel: [  112.362047] pciehp: Device 0000:0c:00.0 already exists at c:0, 
> > cannot hot-add
> > kernel: [  112.362052] pciehp: Cannot add device 0xc:0

Hmm, what device is this?

-- 
Jiri Kosina
SUSE Labs
