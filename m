Return-Path: <linux-kernel-owner+w=401wt.eu-S933523AbZINW0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933523AbZINW0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 18:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932310AbZINW0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 18:26:14 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36311 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933479AbZINW0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 18:26:09 -0400
Date: Tue, 15 Sep 2009 00:26:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Greg KH <greg@kroah.com>, arve@android.com, swetland@google.com,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [patch 3/6] add pmem driver
Message-ID: <20090914222605.GK10398@elf.ucw.cz>
References: <20090914215855.GC11667@elf.ucw.cz> <1252965980.11643.261.camel@desktop> <20090914220829.GH10398@elf.ucw.cz> <1252966985.11643.273.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252966985.11643.273.camel@desktop>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-09-14 15:23:05, Daniel Walker wrote:
> On Tue, 2009-09-15 at 00:08 +0200, Pavel Machek wrote:
> > On Mon 2009-09-14 15:06:20, Daniel Walker wrote:
> > > On Mon, 2009-09-14 at 23:58 +0200, Pavel Machek wrote:
> > > > 
> > > > This adds android pmem driver, one of dependencies of camera driver.
> > > 
> > > I wouldn't even both with this one .. There's no way it could ever go
> > > into mainline .. According to the android developers the camera , and
> > > the frame buffer driver should work without it anyway..
> > 
> > Well, without it, it does not link. If you can provide better patch,
> > please go ahead. (But please let me fix the compilation in the meantime).
> 
> Now that I think about it, maybe just the frame buffer driver can work
> without it.. If it's really needed for the camera then the agenda should
> be removing pmem from the camera ..
> 
> > Plus... why do you think this is completely unacceptable? We may need
> > to strip the userland interface, but the rest..
> 
> The userland interface is the core of the driver tho .. According to the
> android developers (my understanding anyway), this driver just allows
> large blocks of memory to be allocated then shared between userspace and
> kernel space .. Brian can explain it better, but from the sound of it
> they are likely replicating interfaces that we already have ..

AFAICT, pmem exports functionality that is required by the other
part. I agree that new userland interface is probably no-go, but I
also believe that it should be easy enough to remove (or maybe change)
in followup patch.

It will be worked on, eventually. For now, we'd like dream support to
compile and link, and then maybe to boot.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
