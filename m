Return-Path: <linux-kernel-owner+w=401wt.eu-S932535AbYD3Thy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535AbYD3Thy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 15:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932315AbYD3Thl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 15:37:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46000 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932312AbYD3Thk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 15:37:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Miller <davem@davemloft.net>
Subject: Re: Slow DOWN, please!!!
Date: Wed, 30 Apr 2008 21:36:57 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
References: <20080429.190352.137408408.davem@davemloft.net>
In-Reply-To: <20080429.190352.137408408.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804302136.58005.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 30 of April 2008, David Miller wrote:
> 
> This is starting to get beyond frustrating for me.
> 
> Yesterday, I spent the whole day bisecting boot failures
> on my system due to the totally untested linux/bitops.h
> optimization, which I fully analyzed and debugged.
> 
> Today, I had hoped that I could get some work done of my
> own, but that's not the case.
> 
> Yet another bootup regression got added within the last 24
> hours.
> 
> I don't mind fixing the regression or two during the merge
> window but THIS IS ABSOLUTELY, FUCKING, REDICULIOUS!
> 
> The tree breaks every day, and it's becomming an extremely
> non-fun environment to work in.
> 
> We need to slow down the merging, we need to review things
> more, we need people to test their fucking changes!

Well, I must say I second that.

I'm not seeing regressions myself this time (well, except for the one that
Jiri fixed), but I did find a few of them during the post-2.6.24 merge window
and I wouldn't like to repeat that experience, so to speak.

IMO, the merge window is way too short for actually testing anything.  I rebuild
the kernel once or even twice a day and there's no way I can really test it.
I can only check if it breaks right away.  And if it does, there's no time to
find out what broke it before the next few hundreds of commits land on top of
that.

Thanks,
Rafael
