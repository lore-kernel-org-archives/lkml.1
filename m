Return-Path: <linux-kernel-owner+w=401wt.eu-S1761425AbYBMUns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761425AbYBMUns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 15:43:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbYBMUn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 15:43:29 -0500
Received: from onyx.ip.pt ([195.23.92.252]:57100 "EHLO mail.isp.novis.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbYBMUn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 15:43:28 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2008 15:43:27 EST
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB fixes
From: Ricardo Cerqueira <v4l@cerqueira.org>
To: linux-dvb-maintainer@linuxtv.org
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.58.0802131025440.6264@shell2.speakeasy.net>
References: <20080212190235.4e86baf8@gaivota>
	 <Pine.LNX.4.58.0802122120530.7642@shell2.speakeasy.net>
	 <20080213155352.06d966cd@gaivota>
	 <Pine.LNX.4.58.0802131025440.6264@shell2.speakeasy.net>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 20:36:44 +0000
Message-Id: <1202935004.17260.54.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-02-13 at 10:45 -0800, Trent Piepho wrote:
> On Wed, 13 Feb 2008, Mauro Carvalho Chehab wrote:
> > On Tue, 12 Feb 2008 21:21:43 -0800 (PST)
> > Trent Piepho <xyzzy@speakeasy.org> wrote:
> >
> > The version with problems is the one dated by Jan, 16:
> > http://linuxtv.org/pipermail/v4l-dvb-maintainer/2008-January/006119.html
> >
> > As Ricardo stated on Feb, 5, he fixed the lock issues, that were present on
> > your first revision:
> >
> > http://linuxtv.org/pipermail/v4l-dvb-maintainer/2008-February/006292.html
> 
> I don't see what you are saying in that message.  Ricardo agreed it had a
> race condition and said he would, at some future point, redo it, but I
> never saw a new patch.

You missed it, then:

http://linuxtv.org/pipermail/v4l-dvb-maintainer/2008-February/006293.html

was sent in 25 minutes after the message Mauro mentioned.


> Nobody points to any issues, ever, when this happens.  Look at how broken
> the v4l2 only bttv driver was.  You still can't unload and load cx88-dvb
> since Markus's patch for hotplug, no one's fixed that regression.  Now
> there's yet another race in the cx88 subdriver code.  Maybe the original
> author who added that code should feel some motiviation to fix the
> regressions it caused....

Read the code that was actually committed: here's a helpful link:

http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=41a93616082af630e7242cba766a161d7847560b


> 
> I don't have the time or the desire to be the janitor who cleans up after
> sloppy coders' bugs.

You properly raised a red flag, and got a fix in return.
Don't expect fixes to be accompanied by a "are you happy now?"
follow-up; if you took the time to check the first commit, take the time
to read the rest.

Now... it looks as if you simply missed the second patch; it happens.
But next time you feel like sending this kind of message(s) to 3
separate lists, at least check your mail history (or read the code
you're commenting).

--
RC

