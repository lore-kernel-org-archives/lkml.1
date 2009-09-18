Return-Path: <linux-kernel-owner+w=401wt.eu-S1753291AbZIROq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbZIROq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 10:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbZIROq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 10:46:29 -0400
Received: from nbd.name ([88.198.39.176]:43106 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbZIROq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 10:46:28 -0400
Message-ID: <4AB39D3A.3000204@openwrt.org>
Date: Fri, 18 Sep 2009 16:46:18 +0200
From: Felix Fietkau <nbd@openwrt.org>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Michael Buesch <mb@bu3sch.de>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
References: <20090906205952.GA6516@elte.hu> <20090907182629.GA3484@elte.hu> <20090908074825.GA11413@elte.hu> <200909081645.18505.mb@bu3sch.de> <20090918112454.GE9930@elte.hu>
In-Reply-To: <20090918112454.GE9930@elte.hu>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Michael Buesch <mb@bu3sch.de> wrote:
> 
>> On Tuesday 08 September 2009 09:48:25 Ingo Molnar wrote:
>> > Mind poking on this one to figure out whether it's all repeatable 
>> > and why that slowdown happens?
>> 
>> I repeated the test several times, because I couldn't really believe 
>> that there's such a big difference for me, but the results were the 
>> same. I don't really know what's going on nor how to find out what's 
>> going on.
> 
> Well that's a really memory constrained MIPS device with like 16 MB of 
> RAM or so? So having effects from small things like changing details in 
> a kernel image is entirely plausible.
Normally changing small details doesn't have much of an effect. While 16
MB is indeed not that much, we do usually have around 8 MB free with a
full user space running. Changes to other subsystems normally produce
consistent and repeatable differences that seem entirely unrelated to
memory use, so any measurable difference related to scheduler changes is
unlikely to be related to the low amount of RAM.
By the way, we do frequently also test the same software with devices
that have more RAM, e.g. 32 or 64 MB and it usually behaves in a very
similar way.

- Felix
