Return-Path: <linux-kernel-owner+w=401wt.eu-S935598AbYDQKAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935598AbYDQKAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 06:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934048AbYDQJdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:33:06 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:49462 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934308AbYDQJdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:33:04 -0400
Date: Thu, 17 Apr 2008 11:33:53 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Peter Teoh <htmldeveloper@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Self-snapshotting in Linux
Message-ID: <20080417093353.GC7314@elf.ucw.cz>
References: <804dabb00804160144j25584229t6673bc182fa13b3@mail.gmail.com> <20080416111412.GB32432@atrey.karlin.mff.cuni.cz> <804dabb00804160821n4872c65fh44f2c07ead67fc49@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <804dabb00804160821n4872c65fh44f2c07ead67fc49@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-04-16 23:21:05, Peter Teoh wrote:
> Thank you for your reply.
> 
> Just some questions...
> 
> On 4/16/08, Pavel Machek <pavel@ucw.cz> wrote:
> > > Sorry if this is a a crazy idea.....just be forewarned....
> >  >
> >  > First, I would like to make a reference to VMWare's snapshot (name not
> >  > important, emphasize the idea) feature - hopefully u are familiar with
> >  > it.   This is a feature whereby u can freeze the entire OS (kernel +
> >  > userspace application running) and then later reload itself next time,
> >  > continuing where it left off, without reboot from ground zero.
> >  >
> >  > Next, can I ask, is such a feature useful in Linux?   Ie, able to
> >  > restart the kernel + userspace application from where u left off, the
> >  > last time round.    Not JUST the normal suspend/resume feature, but
> >  > more important able to CHOOSE among the different available images
> >  > for
> >  > u to resume on.   Eg, u want to freeze the current 2.6.25-rc6
> >  > kernel,
> >
> >
> > Could we use english on this list?
> >
> >  Anyway, hibernate, cp /dev/root /somewhere/root.1; cp /dev/swap
> >  /somewhere/swap.1
> >
> 
> The current userspace suspend actually saved the entire state of the
> memory (which applications are oepne/closed) into the swap area,
> right?

> So the 2nd line above of backingup the swap should allow us to restore
>  back state of the userspace applications later - correct?

Yes, but you need to match memory state with filesystem state...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
