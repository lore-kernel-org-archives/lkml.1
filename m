Return-Path: <linux-kernel-owner+w=401wt.eu-S933525AbXCJHhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933525AbXCJHhB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 02:37:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933526AbXCJHhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 02:37:00 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:45255 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933525AbXCJHhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 02:37:00 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 9 Mar 2007 23:36:57 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Nicholas Miell <nmiell@comcast.net>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 6/9] signalfd/timerfd v1 - timerfd core ...
In-Reply-To: <1173510568.3108.17.camel@entropy>
Message-ID: <Pine.LNX.4.64.0703092323370.28135@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703091535360.3761@alien.or.mcafeemobile.com> 
 <1173508384.3108.1.camel@entropy>  <Pine.LNX.4.64.0703092235430.28135@alien.or.mcafeemobile.com>
  <1173509019.3108.4.camel@entropy>  <Pine.LNX.4.64.0703092248420.28135@alien.or.mcafeemobile.com>
 <1173510568.3108.17.camel@entropy>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2007, Nicholas Miell wrote:

> On Fri, 2007-03-09 at 22:53 -0800, Davide Libenzi wrote:
> > On Fri, 9 Mar 2007, Nicholas Miell wrote:
> > > 
> > > So extend the existing POSIX timer API to deliver expiry events via a
> > > fd.
> > 
> > It'll be out of standard as timerfd is, w/out code savings. Look at the 
> > code and tell me what could be saved. Prolly the ten lines of the timer 
> > callback. Lines that you'll have to drop inside the current posix timer 
> > layer. Better leave standards alone, especially like in this case, when 
> > the savings are not there.
> > 
> 
> OK, here's a more formal listing of my objections to the introduction of
> timerfd in this form:
> 
> A) It is a new general-purpose ABI intended for wide-scale usage, and
> thus must be maintained forever.

Yup


> B) It is less functional than the existing ABIs -- modulo their
> "delivery via signals only" limitation, which can be corrected (and has
> been already in other operating systems).

Less functional? Please, do tell me ...



> C) Being an entirely new creation that completely ignores past work in
> this area, it has no hope of ever getting into POSIX.
> 
> which means
> 
> D) At some point in time, Linux is going to get the POSIX version (in
> whatever form it takes), making this new ABI useless dead weight (see
> point A).

Adding parameters/fields to a standard is going to create even more 
confusion than a new *single* function. And the code to cross-link the 
timerfd and the current posix timers is going to end up in being more 
complex than the current one.



- Davide


