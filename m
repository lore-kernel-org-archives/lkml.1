Return-Path: <linux-kernel-owner+w=401wt.eu-S1754297AbYHKQWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbYHKQWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 12:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbYHKQWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 12:22:04 -0400
Received: from web82105.mail.mud.yahoo.com ([209.191.84.218]:44069 "HELO
	web82105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751181AbYHKQWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 12:22:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=KYWz1naOFK1yA84MZx49OYCZca/VAy409ohfOAMWHfq5xXbmNCrLGtFdzRjRdz628JaK3+TkCjG4Egu412bHE+MaGB3uvv68HElOtTC+kD+/IKRLKTW4RFWZ0Ey/EtbnJ9I8iD+eoheBKbPWo1DwvooIyph6Liote8149UjiskE=;
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218
Date: Mon, 11 Aug 2008 09:22:01 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: [PATCH diagnostic] Re: HPET regression in 2.6.26 versus 2.6.25 -- RCU problem
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       netdev <netdev@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <777191.9258.qm@web82105.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




> And attached is the kernel module I used to test the patch, for whatever
> that might be worth.

Thank you for that, too.  I have some questions and a comment:

1.  This module can only be loaded from a working system, right?  You
mean that _you_ tested the kernel code on _your_ system to see if it
was working correctly, and did not mean that I should use this with
the problematic kernels on my system?  I could easily run this with
something like 'modprobe stall' on my working machine, or on the
problem machine if I boot with the "hpet=disabled" parameter, but
doing so would not help us find the problem, right?

2.  Coincidentally, I had started reading Understanding the Linux Kernel
(first edition, 2000) about a week before I got socked with the kernel
freeze issue.  I was reading it at work -- I work as a tutor, and there
are sometimes slow times without students to help -- but haven't had a
chance to do so in the best 10 days while I've been struggling with my
own kernel problem.  It is also quite out-of-date -- published in 2000,
and discussing the 2.2 kernel line.  I know that there have been a
couple of new editions since then, but I just happened to have this first
edition on my shelf... so I took it into work for a little light reading.

Anyway, I have a lot on my personal TODO list for the fall, but maybe
early next year I will have a chance to play with the kernel for fun.
When I do so, I will have your new, experimental module to look at...
among tons of other things.


Thanks,
Dave W.
