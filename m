Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab0CHUdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 15:33:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41412 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755377Ab0CHUdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 15:33:09 -0500
Date: Mon, 8 Mar 2010 12:33:05 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.34-rc1
Message-ID: <alpine.LFD.2.00.1003081204510.3669@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's out there now. I still have a few trees I already got pull requests 
for, and that I want to look over a bit more (ceph, gdb tree etc), and 
it's possible that I've just overlooked some other pull request.

So if you feel like you sent me a pull request bit might have been 
over-looked, please point that out to me, but in general the merge window 
is over. And as promised, if you left your pull request to the last day of 
a two-week window, you're now going to have to wait for the 2.6.35 window.

As usual, there's tons of changes, with about 50% of the changes being 
under drivers/. With an additional 5% in sound/, which has its own 
subdirectory, and 10% being firmware/, we're looking at about two thirds 
being driver-related.

Of the remaining, about half is arch updqates (mainly arm, mips, ppc, sh 
and x86), and half is "rest". Which includes things like a new filesystem 
(logfs - as mentioned, there's another one pending too, so we might have 
two new ones in 2.6.34).

All in all, about 850 developers involved so far (there migth be a few 
dups there, I didn't check too closely), 6500+ files changed, 400,000+ 
lines added, ~175,000 lines deleted. Too much to really summarize, in 
other words.

The thing that bit me, and might bite a few others, is that if you're 
using Nouveau, you'll have to install new libdrm/nouveau_drv versions. 
Other than that, if something doesn't work, please holler!

			Linus
