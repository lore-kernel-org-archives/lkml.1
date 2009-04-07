Return-Path: <linux-kernel-owner+w=401wt.eu-S1757064AbZDGEba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064AbZDGEba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 00:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbZDGEbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 00:31:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50324 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751045AbZDGEbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 00:31:21 -0400
Date: Mon, 6 Apr 2009 21:27:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Trenton D. Adams" <trenton.d.adams@gmail.com>
cc: Chris Mason <chris.mason@oracle.com>, Theodore Tso <tytso@mit.edu>,
       Hua Zhong <hzhong@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8][RFC] IO latency/throughput fixes
In-Reply-To: <9b1675090904062113r2bd2b209hea1061cc54a0b9c0@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0904062120560.4010@localhost.localdomain>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>  <alpine.LFD.2.00.0904060803141.4023@localhost.localdomain>  <20090406151054.GD5178@kernel.dk>  <alpine.LFD.2.00.0904060840080.3863@localhost.localdomain>  <20090406183157.GD7376@mit.edu>
  <alpine.LFD.2.00.0904061255160.4134@localhost.localdomain>  <002501c9b6f3$f85b4910$e911db30$@com> <20090406211931.GB8586@mit.edu>  <1239076379.17426.23.camel@think.oraclecorp.com> <9b1675090904062113r2bd2b209hea1061cc54a0b9c0@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 6 Apr 2009, Trenton D. Adams wrote:
>
> Okay, so a config option is a benefit in what way, for these
> particular circumstances?  If someone wants to change the behaviour of
> the kernel, for this particular case, they can just use tune2fs, no?

Basically, I have a very simple policy in my kernel life:

 - I don't touch distribution settings. I update the kernel, and NOTHING 
   else.

(Ok, I lie. I do my own git version too, but I'm really unhappy when I 
feel like I need to maintain anything else)

And I have that policy because quite frankly, if I start tuning distro 
settings, I'll

 (a) forget about them and not do it on my next machine and 
 (b) do some magic that _I_ may know how to do but nobody else does, so 
     now what I'm doing is no longer relevant for anybody else
 (c) I'm no longer helping anybody else.

So I have a few bits and pieces that I develop (mainly the kernel but also 
git etc), and I don't make site-specific changes to them even if I could. 

In other words: if I make a change that helps me, I want to make sure
that I make that option available to everybody else, because quite
frankly that's a big portion of the whole point of open source.

The whole "scratch your itch" isn't just about scratching _your_ itch, 
it's about getting it (almost by mistake) fixed for a lot of other people 
too.

			Linus
