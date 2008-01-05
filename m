Return-Path: <linux-kernel-owner+w=401wt.eu-S1758526AbYAEVwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526AbYAEVwQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 16:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757568AbYAEVwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 16:52:01 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37668 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757566AbYAEVwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 16:52:00 -0500
Date: Sat, 5 Jan 2008 22:52:09 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>, Raymano Garibaldi <raymano@faunos.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] [FEATURE REQUEST] Transparent hot plugging
	of root file system on portable storage devices.
Message-ID: <20080105215209.GB21565@elf.ucw.cz>
References: <200801021119.22104.oliver@neukum.org> <Pine.LNX.4.44L0.0801021521291.2990-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0801021521291.2990-100000@iolanthe.rowland.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-01-02 15:23:30, Alan Stern wrote:
> On Wed, 2 Jan 2008, Oliver Neukum wrote:
> 
> > Am Dienstag 01 Januar 2008 schrieb Pavel Machek:
> > > Hi1
> > > 
> > > > I would like to request a feature in the Linux kernel that would allow
> > > > a user to unplug a live read-only root file system which exists on a
> > > > detachable storage device such as a USB key drive. The desired
> > > > behavior is that once the same device is reattached to the computer
> > > > the user can continue work transparently without having to reboot.
> > > > 
> > > > Having such a feature is becoming more important with advances in
> > > > detachable solid state drive technology.
> > > 
> > > Yep, that would be nice.... In fact, patch would be very welcome :-).
> > 
> > Use the USB persist feature and hibernate. It should work. If you modify
> > the fs in any way, you'll crash and burn. Unmounting / is harder which you
> > need if you want to do this safely.
> 
> What about people who prefer (for reasons of restart latency or
> non-availability of swap space) to suspend rather than hibernate?

For suspend to RAM, we can keep the power session, and be _sure_ noone
unplugged our USB disks, right? So that one should work nicely.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
