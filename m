Return-Path: <linux-kernel-owner+w=401wt.eu-S933167AbXCKFoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167AbXCKFoZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 00:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933180AbXCKFoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 00:44:25 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:47018 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933167AbXCKFoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 00:44:25 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 10 Mar 2007 21:44:22 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 6/9] signalfd/timerfd v1 - timerfd core ...
In-Reply-To: <Pine.LNX.4.64.0703102132240.10330@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703102143510.3613@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703091535360.3761@alien.or.mcafeemobile.com> 
 <1173508384.3108.1.camel@entropy>  <Pine.LNX.4.64.0703092235430.28135@alien.or.mcafeemobile.com>
  <1173509019.3108.4.camel@entropy>  <Pine.LNX.4.64.0703092248420.28135@alien.or.mcafeemobile.com>
  <1173510568.3108.17.camel@entropy>  <Pine.LNX.4.64.0703092323370.28135@alien.or.mcafeemobile.com>
  <1173556374.2958.12.camel@entropy>  <Pine.LNX.4.64.0703101230010.29503@alien.or.mcafeemobile.com>
  <1173560473.2958.23.camel@entropy>  <Pine.LNX.4.64.0703101340550.10330@woody.linux-foundation.org>
 <1173563796.2958.28.camel@entropy> <Pine.LNX.4.64.0703101421410.10330@woody.linux-foundation.org>
 <Pine.LNX.4.64.0703101938150.3613@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0703102132240.10330@woody.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Mar 2007, Linus Torvalds wrote:

> > Actually, the only place where I can find the itimerspec usefull, is 
> > indeed with TFD_TIMER_SEQ. In cases where you want you clock starting at a 
> > given time (it_value) *and* with the given frequency (it_interval).
> 
> .. and this is where itimerspec is even better: once you have absolute 
> time, *and* a process that might miss ticks (because it does something 
> else), the "absolute time start + interval" thing can avoid drifting 
> (which a "relative interval" has a really hard time doing).
> 
> So if you want a "timer tick every second, *on* the second" kind of 
> interface, you really do want a absolute time starting point, and then a 
> fixed interval. Two different times.

Alrighty, I'll use a itimerspec ...



- Davide


