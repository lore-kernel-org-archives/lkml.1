Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbXKFHQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbXKFHQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 02:16:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754678AbXKFHQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 02:16:01 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:40082 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655AbXKFHQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 02:16:00 -0500
Message-ID: <47301491.3020502@sw.ru>
Date: Tue, 06 Nov 2007 10:15:29 +0300
From: Vasily Averin <vvs@sw.ru>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, devel@openvz.org
Subject: Re: irq0 stops working
References: <470B1119.8040207@sw.ru> <alpine.LFD.0.9999.0710090752540.25146@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.9999.0710090752540.25146@localhost.localdomain>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Tue, 9 Oct 2007, Vasily Averin wrote:
>> On one of our servers timer interrupts (i.e irq0) are stops working. As result
>> any kernel timers do not triggers and tasks waiting some signals from timers
>> hangs forever.
>>
>> Also I've found that disable of irqbalance service on the node helps to
>> workaround this issue, however of course it fixes nothing.
> 
> Well, it's at least a hint. Can you try the patch below please ?

Patch helps, after 1-month-long testing I could not reproduce this issue again,
what are we going to do now?

Unfortunately my test node is still unstable, now it reproduces sata timeout
issue, details are here:
http://bugzilla.kernel.org/show_bug.cgi?id=8650

Thank you,
	Vasily Averin
