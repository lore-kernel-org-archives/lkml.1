Return-Path: <linux-kernel-owner+w=401wt.eu-S1754914AbZBWLMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbZBWLMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 06:12:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754676AbZBWLMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 06:12:03 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60798 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753026AbZBWLMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 06:12:02 -0500
Message-ID: <49A283D2.8060300@cn.fujitsu.com>
Date: Mon, 23 Feb 2009 19:09:06 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] sched: fair group's bug
References: <4965573B.60801@cn.fujitsu.com> <1231424195.11687.449.camel@twins>
In-Reply-To: <1231424195.11687.449.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2009-1-8 22:16 Peter Zijlstra wrote:
> On Thu, 2009-01-08 at 09:30 +0800, Miao Xie wrote:
>> I tested fair group scheduler on my hyper-threading x86_64 box(2 CPU * 2 HT)
>> and found the deviation of the groups' CPU usage was larger than 2.6.26
>> when *offline* a CPU or do hotplug frequently. It is less than 1% On 2.6.26，but
>> On current kernel, it is often greater than 4%, even than 10% by accident.
> 
> Its not a bug -- a scheduler without smp awareness cannot be compared to
> one without -- .26 just wasn't a complete group scheduler.
> 
> At best its a regression for your particular workload.
> 

Hi, Peter
Do you wait to fix this regression?

Thanks!
Miao

