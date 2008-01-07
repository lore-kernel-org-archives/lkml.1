Return-Path: <linux-kernel-owner+w=401wt.eu-S1756419AbYAGPjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419AbYAGPjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 10:39:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754041AbYAGPjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 10:39:14 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:36539 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753120AbYAGPjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 10:39:14 -0500
Date: Mon, 7 Jan 2008 10:39:13 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pavel Machek <pavel@ucw.cz>
cc: Oliver Neukum <oliver@neukum.org>, Raymano Garibaldi <raymano@faunos.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] [FEATURE REQUEST] Transparent hot plugging of
 root file system on portable storage devices.
In-Reply-To: <20080106224429.GA1664@elf.ucw.cz>
Message-ID: <Pine.LNX.4.44L0.0801071017430.4491-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jan 2008, Pavel Machek wrote:

> On Sun 2008-01-06 17:26:17, Alan Stern wrote:
> > On Sun, 6 Jan 2008, Oliver Neukum wrote:
> > 
> > > Am Sonntag 06 Januar 2008 schrieb Alan Stern:
> > > > What about people who want to suspend to RAM instead of hibernating and
> > > > _do_ want to unplug the USB device containing their root filesystem
> > > > while the machine is asleep? 
> 
> Ok, I guess I'm lost here. That sounds like a nice way to do
> self-leg-shooting. Are there such people?

Yes.  People with small systems having extremely limited rw storage (no
swap space), using removable read-only media as their root fs.

You can find the thread leading up to this request here:

	http://marc.info/?t=119544588400002&r=1&w=2

> > > Would it be hard to force the persist feature on for a replugged device?
> > 
> > Right now the persist feature is enabled by a per-device boolean flag.  
> > In theory the flag could accept 3 values: off, on if power was lost,
> > or on for any resume transition.  This would not be a hard change.
> 
> But do we need it?

That depends on whom you ask!  :-)

> Did you progress on "usb-storage-autosuspend"?

Yes; the first round of patches will be posted later today.

> Here are my hacks to try to get SATA to survive autosuspend;
> unfortunately they do not work :-(.

You should start off with minimal support for manual runtime suspend
(through a sysfs attribute).  When that's working, autosuspend will be
easier to add in.

Alan Stern

