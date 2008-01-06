Return-Path: <linux-kernel-owner+w=401wt.eu-S1759337AbYAFRSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337AbYAFRSr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 12:18:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754922AbYAFRSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 12:18:38 -0500
Received: from netrider.rowland.org ([192.131.102.5]:1260 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754209AbYAFRSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 12:18:37 -0500
Date: Sun, 6 Jan 2008 12:18:35 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Pavel Machek <pavel@ucw.cz>
cc: Oliver Neukum <oliver@neukum.org>, Raymano Garibaldi <raymano@faunos.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] [FEATURE REQUEST] Transparent hot plugging of
 root file system on portable storage devices.
In-Reply-To: <20080105215209.GB21565@elf.ucw.cz>
Message-ID: <Pine.LNX.4.44L0.0801061213460.8070-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jan 2008, Pavel Machek wrote:

> On Wed 2008-01-02 15:23:30, Alan Stern wrote:
> > On Wed, 2 Jan 2008, Oliver Neukum wrote:
> > 
> > > Am Dienstag 01 Januar 2008 schrieb Pavel Machek:
> > > > Hi1
> > > > 
> > > > > I would like to request a feature in the Linux kernel that would allow
> > > > > a user to unplug a live read-only root file system which exists on a
> > > > > detachable storage device such as a USB key drive. The desired
> > > > > behavior is that once the same device is reattached to the computer
> > > > > the user can continue work transparently without having to reboot.
> > > > > 
> > > > > Having such a feature is becoming more important with advances in
> > > > > detachable solid state drive technology.
> > > > 
> > > > Yep, that would be nice.... In fact, patch would be very welcome :-).
> > > 
> > > Use the USB persist feature and hibernate. It should work. If you modify
> > > the fs in any way, you'll crash and burn. Unmounting / is harder which you
> > > need if you want to do this safely.
> > 
> > What about people who prefer (for reasons of restart latency or
> > non-availability of swap space) to suspend rather than hibernate?
> 
> For suspend to RAM, we can keep the power session, and be _sure_ noone
> unplugged our USB disks, right? So that one should work nicely.

No, no.  You didn't understand the question.

What about people who want to suspend to RAM instead of hibernating and
_do_ want to unplug the USB device containing their root filesystem
while the machine is asleep?  In this case we will _know_ that the
power session has been interrupted, but USB Persist won't activate
because the host controller never lost power.

Alan Stern

