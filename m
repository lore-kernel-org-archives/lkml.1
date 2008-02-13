Return-Path: <linux-kernel-owner+w=401wt.eu-S1759306AbYBMSpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306AbYBMSpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 13:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbYBMSpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 13:45:11 -0500
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:50590 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbYBMSpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 13:45:09 -0500
Date: Wed, 13 Feb 2008 10:45:06 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: linux-dvb-maintainer@linuxtv.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       Ricardo Cerqueira <ricardo@cerqueira.org>
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB fixes
In-Reply-To: <20080213155352.06d966cd@gaivota>
Message-ID: <Pine.LNX.4.58.0802131025440.6264@shell2.speakeasy.net>
References: <20080212190235.4e86baf8@gaivota> <Pine.LNX.4.58.0802122120530.7642@shell2.speakeasy.net>
 <20080213155352.06d966cd@gaivota>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008, Mauro Carvalho Chehab wrote:
> On Tue, 12 Feb 2008 21:21:43 -0800 (PST)
> Trent Piepho <xyzzy@speakeasy.org> wrote:
>
> > On Tue, 12 Feb 2008, Mauro Carvalho Chehab wrote:
> > >    - cx88-mpeg: Allow concurrent access to cx88-mpeg devices;
> >
> > So you decided to just commit this one with the race condition anyway?
>
> The version with problems is the one dated by Jan, 16:
> http://linuxtv.org/pipermail/v4l-dvb-maintainer/2008-January/006119.html
>
> As Ricardo stated on Feb, 5, he fixed the lock issues, that were present on
> your first revision:
>
> http://linuxtv.org/pipermail/v4l-dvb-maintainer/2008-February/006292.html

I don't see what you are saying in that message.  Ricardo agreed it had a
race condition and said he would, at some future point, redo it, but I
never saw a new patch.

> I've pushed the reviewed version at the same day, for testing, at the

review-by == I saw your patch in my inbox and read the title

> development environment:
>
> http://linuxtv.org/pipermail/v4l-dvb-maintainer/2008-February/006326.html
>
> Nobody pointed any newer issues on the reviewed version, since then.

Nobody points to any issues, ever, when this happens.  Look at how broken
the v4l2 only bttv driver was.  You still can't unload and load cx88-dvb
since Markus's patch for hotplug, no one's fixed that regression.  Now
there's yet another race in the cx88 subdriver code.  Maybe the original
author who added that code should feel some motiviation to fix the
regressions it caused....

The only complaints that are ever generated on commits to the development
enviroment are political, "so-and-so shouldn't be able to patch my
fiefdom."

> If you still see any issues, please send us a patch fixing it.

I don't have the time or the desire to be the janitor who cleans up after
sloppy coders' bugs.
