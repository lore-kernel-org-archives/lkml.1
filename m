Return-Path: <linux-kernel-owner+w=401wt.eu-S1750953AbXCJGnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750953AbXCJGnq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 01:43:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750865AbXCJGnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 01:43:46 -0500
Received: from sccrmhc14.comcast.net ([63.240.77.84]:63785 "EHLO
	sccrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbXCJGnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 01:43:45 -0500
Subject: Re: [patch 6/9] signalfd/timerfd v1 - timerfd core ...
From: Nicholas Miell <nmiell@comcast.net>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703092235430.28135@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703091535360.3761@alien.or.mcafeemobile.com>
	 <1173508384.3108.1.camel@entropy>
	 <Pine.LNX.4.64.0703092235430.28135@alien.or.mcafeemobile.com>
Content-Type: text/plain
Date: Fri, 09 Mar 2007 22:43:39 -0800
Message-Id: <1173509019.3108.4.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-09 at 22:38 -0800, Davide Libenzi wrote:
> On Fri, 9 Mar 2007, Nicholas Miell wrote:
> 
> > Why did you ignore the existing POSIX timer API?
> 
> The existing POSIX API is a standard and a very good one. Too bad it does 
> not deliver to files. The timerfd code is, as you can probably read from 
> the code, a really thin wrapper around the existing hrtimer.c Linux code.

So extend the existing POSIX timer API to deliver expiry events via a
fd.

-- 
Nicholas Miell <nmiell@comcast.net>

