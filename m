Return-Path: <linux-kernel-owner+w=401wt.eu-S1751147AbXCJV6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751147AbXCJV6c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 16:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbXCJV6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 16:58:32 -0500
Received: from rwcrmhc14.comcast.net ([216.148.227.154]:63122 "EHLO
	rwcrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbXCJV6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 16:58:31 -0500
Subject: Re: [patch 6/9] signalfd/timerfd v1 - timerfd core ...
From: Nicholas Miell <nmiell@comcast.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703101340550.10330@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703091535360.3761@alien.or.mcafeemobile.com>
	 <1173508384.3108.1.camel@entropy>
	 <Pine.LNX.4.64.0703092235430.28135@alien.or.mcafeemobile.com>
	 <1173509019.3108.4.camel@entropy>
	 <Pine.LNX.4.64.0703092248420.28135@alien.or.mcafeemobile.com>
	 <1173510568.3108.17.camel@entropy>
	 <Pine.LNX.4.64.0703092323370.28135@alien.or.mcafeemobile.com>
	 <1173556374.2958.12.camel@entropy>
	 <Pine.LNX.4.64.0703101230010.29503@alien.or.mcafeemobile.com>
	 <1173560473.2958.23.camel@entropy>
	 <Pine.LNX.4.64.0703101340550.10330@woody.linux-foundation.org>
Content-Type: text/plain
Date: Sat, 10 Mar 2007 13:56:36 -0800
Message-Id: <1173563796.2958.28.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-10 at 13:44 -0800, Linus Torvalds wrote:
> 
> On Sat, 10 Mar 2007, Nicholas Miell wrote:
> > 
> > That's what the sigevent structure is for -- to describe how events
> > should be signaled to userspace, whether by signal delivery, thread
> > creation, or queuing to event completion ports. If if you think
> > extending it would be bad, I can show you the line in POSIX where it
> > encourages the contrary.
> 
> I'm sorry, but by pointing to the POSIX timer stuff, you're just making 
> your argument weaker.
> 
> POSIX timers are a horrible crock and over-designed to be a union of 
> everything that has ever been done. Nasty. We had tons of bugs in the 
> original setup because they were so damn nasty.
> 

Care to elaborate on why they're a horrible crock?

And are the bugs fixed? If so, why replace them? They work now.

> I'd rather look at just about *anything* else for good design than from 
> some of the abortions that are posix-timers.
> 
> 		Linus

-- 
Nicholas Miell <nmiell@comcast.net>

