Return-Path: <linux-kernel-owner+w=401wt.eu-S1751078AbXCJVo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751078AbXCJVo2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 16:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbXCJVo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 16:44:28 -0500
Received: from smtp.osdl.org ([65.172.181.24]:56566 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819AbXCJVo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 16:44:27 -0500
Date: Sat, 10 Mar 2007 13:44:24 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nicholas Miell <nmiell@comcast.net>
cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 6/9] signalfd/timerfd v1 - timerfd core ...
In-Reply-To: <1173560473.2958.23.camel@entropy>
Message-ID: <Pine.LNX.4.64.0703101340550.10330@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703091535360.3761@alien.or.mcafeemobile.com> 
 <1173508384.3108.1.camel@entropy>  <Pine.LNX.4.64.0703092235430.28135@alien.or.mcafeemobile.com>
  <1173509019.3108.4.camel@entropy>  <Pine.LNX.4.64.0703092248420.28135@alien.or.mcafeemobile.com>
  <1173510568.3108.17.camel@entropy>  <Pine.LNX.4.64.0703092323370.28135@alien.or.mcafeemobile.com>
  <1173556374.2958.12.camel@entropy>  <Pine.LNX.4.64.0703101230010.29503@alien.or.mcafeemobile.com>
 <1173560473.2958.23.camel@entropy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 10 Mar 2007, Nicholas Miell wrote:
> 
> That's what the sigevent structure is for -- to describe how events
> should be signaled to userspace, whether by signal delivery, thread
> creation, or queuing to event completion ports. If if you think
> extending it would be bad, I can show you the line in POSIX where it
> encourages the contrary.

I'm sorry, but by pointing to the POSIX timer stuff, you're just making 
your argument weaker.

POSIX timers are a horrible crock and over-designed to be a union of 
everything that has ever been done. Nasty. We had tons of bugs in the 
original setup because they were so damn nasty.

I'd rather look at just about *anything* else for good design than from 
some of the abortions that are posix-timers.

		Linus
