Return-Path: <linux-kernel-owner+w=401wt.eu-S932189AbYBMWFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbYBMWFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935181AbYBMVx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:53:58 -0500
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:36569 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933694AbYBMVx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:53:56 -0500
Date: Wed, 13 Feb 2008 13:53:55 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Ricardo Cerqueira <v4l@cerqueira.org>
cc: linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB fixes
In-Reply-To: <1202935004.17260.54.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.58.0802131349400.6264@shell2.speakeasy.net>
References: <20080212190235.4e86baf8@gaivota> <Pine.LNX.4.58.0802122120530.7642@shell2.speakeasy.net>
 <20080213155352.06d966cd@gaivota> <Pine.LNX.4.58.0802131025440.6264@shell2.speakeasy.net>
 <1202935004.17260.54.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008, Ricardo Cerqueira wrote:
> On Wed, 2008-02-13 at 10:45 -0800, Trent Piepho wrote:
> > On Wed, 13 Feb 2008, Mauro Carvalho Chehab wrote:
> > > On Tue, 12 Feb 2008 21:21:43 -0800 (PST)
> > > Trent Piepho <xyzzy@speakeasy.org> wrote:
> > >
> > Nobody points to any issues, ever, when this happens.  Look at how broken
> > the v4l2 only bttv driver was.  You still can't unload and load cx88-dvb
> > since Markus's patch for hotplug, no one's fixed that regression.  Now
> > there's yet another race in the cx88 subdriver code.  Maybe the original
> > author who added that code should feel some motiviation to fix the
> > regressions it caused....
>
> Read the code that was actually committed: here's a helpful link:
>
> http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=41a93616082af630e7242cba766a161d7847560b

I did.  Looks like there is a race on access to core->active_ref.

> > I don't have the time or the desire to be the janitor who cleans up after
> > sloppy coders' bugs.
>
> You properly raised a red flag, and got a fix in return.
> Don't expect fixes to be accompanied by a "are you happy now?"
> follow-up; if you took the time to check the first commit, take the time
> to read the rest.

You could also CC the relevant parties.  Unless you're hoping they won't
notice something.
