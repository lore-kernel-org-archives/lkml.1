Return-Path: <linux-kernel-owner+w=401wt.eu-S1752624AbZISUPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbZISUPO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 16:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbZISUPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 16:15:13 -0400
Received: from nbd.name ([88.198.39.176]:51210 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520AbZISUPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 16:15:13 -0400
Message-ID: <4AB53BCC.503@openwrt.org>
Date: Sat, 19 Sep 2009 22:15:08 +0200
From: Felix Fietkau <nbd@openwrt.org>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Michael Buesch <mb@bu3sch.de>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
References: <20090906205952.GA6516@elte.hu> <20090907182629.GA3484@elte.hu> <20090908074825.GA11413@elte.hu> <200909081645.18505.mb@bu3sch.de> <20090918112454.GE9930@elte.hu> <4AB39D3A.3000204@openwrt.org> <20090919180124.GK5366@elte.hu> <4AB52667.6020608@openwrt.org> <20090919193956.GA21719@elte.hu>
In-Reply-To: <20090919193956.GA21719@elte.hu>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Felix Fietkau <nbd@openwrt.org> wrote:
>> I did some tests with BFS v230 vs CFS on Linux 2.6.30 on a different
>> MIPS device (Atheros AR2317) with 180 MHz and 16 MB RAM. When running
>> iperf tests, I consistently get the following results when running the
>> transfer from the device to my laptop:
>> 
>> CFS: [  5]  0.0-60.0 sec    107 MBytes  15.0 Mbits/sec
>> BFS: [  5]  0.0-60.0 sec    119 MBytes  16.6 Mbits/sec
>> 
>> The transfer speed from my laptop to the device are the same with BFS
>> and CFS. I repeated the tests a few times just to be sure, and I will
>> check vmstat later.
> 
> Which exact mainline kernel have you tried? For anything performance 
> related running latest upstream -git (currently at 202c467) would be 
> recommended.
I used the OpenWrt-patched 2.6.30. Support for the hardware that I
tested with hasn't been merged upstream yet. Do you think that the
scheduler related changes after 2.6.30 are relevant for non-SMP
performance as well? If so, I'll work on a test with latest upstream
-git with the necessary patches when I have time for it.

- Felix
