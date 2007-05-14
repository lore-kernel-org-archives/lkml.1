Return-Path: <linux-kernel-owner+w=401wt.eu-S1757979AbXENTxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979AbXENTxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 15:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbXENTx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 15:53:29 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40588 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278AbXENTx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 15:53:29 -0400
Message-ID: <4648BE31.3020800@garzik.org>
Date: Mon, 14 May 2007 15:53:21 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Antonino Ingargiola <tritemio@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc1
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>	<5486cca80705131010h2011487dnc948a3c57ce6decc@mail.gmail.com>	<alpine.LFD.0.98.0705131046400.6739@woody.linux-foundation.org>	<5486cca80705131150u313eeb43i30bf040e160ac419@mail.gmail.com>	<20070514081022.7fcee97f@hyperion.delvare>	<5486cca80705140134r318296b8k37ad6f4562b4b535@mail.gmail.com>	<20070514141437.631fcfd1@hyperion.delvare>	<5486cca80705140628w5ff43ebdqf6a5413203226d5@mail.gmail.com>	<20070514172138.1c870793@hyperion.delvare>	<alpine.LFD.0.98.0705140914410.6739@woody.linux-foundation.org>	<20070514202419.33a90f57@hyperion.delvare>	<alpine.LFD.0.98.0705141139560.6739@woody.linux-foundation.org> <20070514212807.246c0281@hyperion.delvare>
In-Reply-To: <20070514212807.246c0281@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> On Mon, 14 May 2007 11:43:45 -0700 (PDT), Linus Torvalds wrote:
>> On Mon, 14 May 2007, Jean Delvare wrote:
>>> Sure, we don't allow that. Except for xfsprogs in 2.6.1, procps in
>>> 2.6.4, oprofile in 2.6.13 and udev in 2.6.19, of course.
>> And we really complained about it! The oprofile thing should be fixed, 
>> btw, and yeah,if udev breaks any more, I'll have to stop taking patches 
>> from Greg. That thing has been a disaster, and everybody involved should 
>> be ashamed and now hopefully *very* aware of the fact that we don't break 
>> user-level interfaces.
>>
>> (Right now, I suspect we may have a loop setup regression. Not sure)
> 
> While I'm all for keeping things relatively stable and not asking the
> user to constantly upgrade user-space, I believe that we just can't
> promise to never break user-level interfaces while keeping the
> development pace we have right now. We can promise to grant people
> significant delay before we drop compatibility options, but "forever"
> doesn't scale.
> 
> If you really want to enforce the "never" rule, be prepared to either
> see development slow down and finally come to a stop, or see the code
> become unmaintainable and insecure and nobody is longer willing to work
> on it.

Why do you think we -stopped- enforcing such a rule?   :)

It's been the rule throughout Linux's history.  syscalls from early 
Linux binaries should still work, for example.

	Jeff



