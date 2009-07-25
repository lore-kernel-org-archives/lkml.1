Return-Path: <linux-kernel-owner+w=401wt.eu-S1752689AbZGYW2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbZGYW2V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 18:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbZGYW2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 18:28:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33816 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222AbZGYW2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 18:28:20 -0400
Subject: Re: inotify regression, missing events
From: Eric Paris <eparis@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Scott James Remnant <scott@ubuntu.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200907260023.36398.rjw@sisk.pl>
References: <1247328127.4003.6.camel@wing-commander>
	 <1247487669.14981.18.camel@quest> <1247492599.3068.19.camel@localhost>
	 <200907260023.36398.rjw@sisk.pl>
Content-Type: text/plain
Date: Sat, 25 Jul 2009 18:27:40 -0400
Message-Id: <1248560860.3567.135.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-07-26 at 00:23 +0200, Rafael J. Wysocki wrote:
> On Monday 13 July 2009, Eric Paris wrote:
> > On Mon, 2009-07-13 at 13:21 +0100, Scott James Remnant wrote:
> > > On Sat, 2009-07-11 at 07:50 -0400, Eric Paris wrote:
> > > 
> > > > On Sat, 2009-07-11 at 17:02 +0100, Scott James Remnant wrote:
> > > > > Looks like there's a regression with inotify since the rewrite to use
> > > > > fanotify.  Events are simply missing and not being delivered to
> > > > > userspace.
> > > > > 
> > > > > Here's a simple test case, just compile and run it:
> > > > 
> > > > I bet I know exactly what it is (notification.c tail merge code isn't
> > > > comparing filename only inode+mask) but I'm walking out of the house.
> > > > I'll try my theory later tonight and post a patch.
> > > > 
> > > > Stupid Eric, Stupid.
> > > > 
> > > In other words, when the second deleted-file-in-a-directory event comes
> > > through, it gets ignored because there's already a
> > > "deleted-file-in-a-directory" event for that directory?
> > 
> > Yes, and I sent a patch but apparent screwed up the --smtp-server option
> > so it never got out.  Resending.  Sorry.....
> 
> Did the patch reach Linus eventually?

No, I sent a git-pull but Linus did not pull from my tree before -rc4.
If he doesn't do it in his openning -rc5 salvo I'll send the request
again.

-Eric

