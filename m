Return-Path: <linux-kernel-owner+w=401wt.eu-S1754854AbZFYAS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbZFYAS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 20:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbZFYASu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 20:18:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752138AbZFYASt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 20:18:49 -0400
Date: Wed, 24 Jun 2009 17:18:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.31-rc1
Message-ID: <alpine.LFD.2.01.0906241656030.3605@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We've had the regular two-week (and one day) merge window, and -rc1 is 
out, and the merge window is closed.

[ I suspect I'll still merge the SCore architecture, I wanted to give it a 
  quick peek, but I've been busy with all the other patches so I'm closing 
  the merge window now, but leaving myself the option of merging Score 
  later - last I looked, the only non-SCore file it touched was the 
  MAINTAINERS file, so it's not like it should break anything else ]

There's a lot in there, but let me say that as far as the whole merge 
window has gone, I've seldom felt happier merging stuff from people. I'm 
really hoping it isn't just a fluke, but people kept their git trees 
clean, and while there were a couple of times that I said "no, I'm not 
going to merge that", on the whole this was a really painless merge window 
for me. 

I'm not saying that it was necessarily less bug-free than usual, I'm just 
saying that on the whole people sent me merge requests that made sense, 
explained what they did, and when I pulled I saw clear development lines. 
That just makes it much easier for me.

So thanks to everybody involved.

I hope that doesn't mean that it was really painful for others, or that 
we'll be chasing down more bugs than usual. And I _really_ hope we can 
keep things going this way, and it wasn't a one-off "things just happened 
to work this time".

As to the actual changes - too many to list. As usual, the bulk of the 
changes are to drivers (70% of the diffs), with drivers/staging being the 
bulk of that (about 60% of all driver changes - 40% of the total). But 
wonder of wonder, I think drivers/staging actually _shrank_ this time 
around, alledgely due to cleanups. Believe that who will.

On the filesystem front, we had btrfs, ext3 and xfs getting active 
development (Why xfs? Beats me, but that's what the stats say), and a fair 
chunk of work on the whole fsnotify unification work. And the VFS layer 
got some TLC wrt ACL and private namespace handling.

On architectures: ARM, powerpc, mips, sh, x86 are the bulk of it. On ARM, 
the bulk is new platforms (u300, freescale stmp, whatever), there seems to 
be no end to crazy new arm platforms. On x86 (and at least some degree on 
powerpc), a noticeable part is the whole new perf-counter subsystem. Along 
with lots and lots of other stuff.

On the whole? Tons of stuff. Let's start testign and stabilizing.

			Linus
