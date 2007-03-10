Return-Path: <linux-kernel-owner+w=401wt.eu-S1752803AbXCJGiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbXCJGiM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 01:38:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbXCJGiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 01:38:12 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:44667 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbXCJGiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 01:38:10 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 9 Mar 2007 22:38:09 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Nicholas Miell <nmiell@comcast.net>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 6/9] signalfd/timerfd v1 - timerfd core ...
In-Reply-To: <1173508384.3108.1.camel@entropy>
Message-ID: <Pine.LNX.4.64.0703092235430.28135@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703091535360.3761@alien.or.mcafeemobile.com>
 <1173508384.3108.1.camel@entropy>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2007, Nicholas Miell wrote:

> Why did you ignore the existing POSIX timer API?

The existing POSIX API is a standard and a very good one. Too bad it does 
not deliver to files. The timerfd code is, as you can probably read from 
the code, a really thin wrapper around the existing hrtimer.c Linux code.


- Davide


