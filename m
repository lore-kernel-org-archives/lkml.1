Return-Path: <linux-kernel-owner+w=401wt.eu-S1757948AbZLRCF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948AbZLRCF7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 21:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756295AbZLRCF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 21:05:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57986 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755641AbZLRCFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 21:05:55 -0500
Date: Thu, 17 Dec 2009 18:05:53 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.33-rc1
Message-ID: <alpine.LFD.2.00.0912171745160.15740@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So the merge window is closed, and -rc1 is out there now.

Talking about the merge window: there were a _lot_ of trees that left 
their pull requests pretty dang late. Not everything I merged yesterday 
and today were late pull requests, but a lot of it was. I'm used to have a 
fairly busy last day of the merge window, but it was a busy last two days 
this time - definitely worse than usual.

The two-week merge window is _not_ supposed to be "one day merge window 
after thirteen days of silence". In fact, I think that next time around 
I'll make the merge window be 11-12 days instead, and people who try to 
game the system and do a last-minute pull request will get a surprise, and 
get unceremoniously bumped to 2.6.35 instead.

Anyway, apart from that grumbling, it's been a fairly normal merge window, 
I think. According to git dirstat (which got fixed to give more accurate 
numbers), the distribution of changes is pretty much

 - 1/3rd staging
 - 1/3rd "rest of drivers"
 - 1/3rd "everything else"

with about half of that final "everything else" third being arch stuff, 
and half being random other things (firmware, fs, net).

Notable additions? There's a number of drivers, and depending on which 
ones you use, you'll find them more or less notable. I personally like how 
I finally got to merge the Nouveau code, for example. Others will care 
about other things.

Please give it a good testing, so that we can start figuring out the 
inevitably regressions,

		Linus
