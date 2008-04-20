Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbYDTV5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbYDTV5d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 17:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750796AbYDTV5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 17:57:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750776AbYDTV5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 17:57:24 -0400
Date: Sun, 20 Apr 2008 14:57:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: tglx@linutronix.de, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT pull] (hr)timer updates feed from Andrew
Message-Id: <20080420145723.28838934.akpm@linux-foundation.org>
In-Reply-To: <200804201922.46749.zippel@linux-m68k.org>
References: <alpine.LFD.1.10.0804192247580.3261@apollo.tec.linutronix.de>
	<200804201922.46749.zippel@linux-m68k.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 20 Apr 2008 19:22:43 +0200 Roman Zippel <zippel@linux-m68k.org> wrote:
> Hi,
> 
> On Saturday 19. April 2008, Thomas Gleixner wrote:
> 
> > John Stultz (1):
> >       time: close small window for vsyscall time inconsistencies
> 
> Out of curiosity: why did you merge this patch despite my objections?
> Why couldn't you wait a little while longer? You knew I was waiting for more 
> information to analyze this properly...
> (Especially as it turns out that this patch doesn't really close the window, 
> it only makes it smaller.)
> 

I have a note here that it's on hold, but I think I added that note after
sending the patch to Thomas on the 18th.  If there was earlier controversy
about it then I guess I forgot to make the note at the time.

It happens sometimes.  But I must say that it happens most frequently with
time-management things when you are the reviewer, because the review
discussion seems to happen a loooong time after I merge the patch and
proceeds at only a few emails per week.

Not that I'm saying "Roman, please review stuff faster".  You review well,
and in detail and it's welcome.  But that is the cause and effect.


There are two contentious time patches:

provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc.patch
time-close-small-window-for-vsyscall-time-inconsistencies.patch

Possily I got the discussions confused and assumed they all
concerned provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc.patch
