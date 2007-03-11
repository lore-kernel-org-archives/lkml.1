Return-Path: <linux-kernel-owner+w=401wt.eu-S932835AbXCKDmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932835AbXCKDmN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 22:42:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932848AbXCKDmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 22:42:13 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:46966 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932835AbXCKDmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 22:42:12 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 10 Mar 2007 19:42:08 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 6/9] signalfd/timerfd v1 - timerfd core ...
In-Reply-To: <Pine.LNX.4.64.0703101421410.10330@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703101938150.3613@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703091535360.3761@alien.or.mcafeemobile.com> 
 <1173508384.3108.1.camel@entropy>  <Pine.LNX.4.64.0703092235430.28135@alien.or.mcafeemobile.com>
  <1173509019.3108.4.camel@entropy>  <Pine.LNX.4.64.0703092248420.28135@alien.or.mcafeemobile.com>
  <1173510568.3108.17.camel@entropy>  <Pine.LNX.4.64.0703092323370.28135@alien.or.mcafeemobile.com>
  <1173556374.2958.12.camel@entropy>  <Pine.LNX.4.64.0703101230010.29503@alien.or.mcafeemobile.com>
  <1173560473.2958.23.camel@entropy>  <Pine.LNX.4.64.0703101340550.10330@woody.linux-foundation.org>
 <1173563796.2958.28.camel@entropy> <Pine.LNX.4.64.0703101421410.10330@woody.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Mar 2007, Linus Torvalds wrote:

> (That said, using "struct itimerspec" might be a good idea. That would 
> also obviate the need for TFD_TIMER_SEQ, since an itimerspec automatically 
> has both "base" and "incremental" parts).

But TFD_TIMER_SEQ is a simple auto-rearm case of TFD_TIMER_REL. So the 
timespec is sufficent too (in all three cases we just need *one* time). 
Actually, the only place where I can find the itimerspec usefull, is 
indeed with TFD_TIMER_SEQ. In cases where you want you clock starting at a 
given time (it_value) *and* with the given frequency (it_interval).



- Davide


