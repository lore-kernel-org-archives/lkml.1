Return-Path: <linux-kernel-owner+w=401wt.eu-S1764740AbXGLUkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764740AbXGLUkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 16:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932644AbXGLUjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 16:39:17 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36654 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760200AbXGLUjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 16:39:16 -0400
Date: Thu, 12 Jul 2007 11:17:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: sysrq-t dumps of s2ram/fuse deadlock (was Re: [PATCH] Remove process freezer from suspend to RAM pathway)
Message-ID: <20070712091714.GD1866@elf.ucw.cz>
References: <20070703042916.GA17240@srcf.ucam.org> <200707031456.36027.rjw@sisk.pl> <20070709132905.GA5212@ucw.cz> <20070711132819.GA5753@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070711132819.GA5753@srcf.ucam.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2007-07-11 14:28:20, Matthew Garrett wrote:
> On Mon, Jul 09, 2007 at 01:29:05PM +0000, Pavel Machek wrote:
> > Hi!
> > 
> > Can we get them? They are neccessary for debugging 'what in suspend
> > calls fuse' problem. And yes, that problem is there even when you
> > remove freezer.
> 
> I can produce them, but haven't managed to do that in any way that lets 
> me get them off the system yet.
> 
> > Matthew, you seem to be the only one able to produce them...
> 
> sys_sync may not do anything on a fuse filesystem, but if you've 
> loopback-mounted an ext3 filesystem from that fuse filesystem then it's 
> going to result in writes to it and deadlock.

Aha, yes, that explains the problem. Thanks!
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
