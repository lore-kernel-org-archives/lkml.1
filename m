Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbYF3Eks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbYF3Eks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 00:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbYF3Eki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 00:40:38 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:46886 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751344AbYF3Ekh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 00:40:37 -0400
Message-ID: <486863C6.6090304@linux.vnet.ibm.com>
Date: Mon, 30 Jun 2008 10:10:38 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [RFC 0/5] Memory controller soft limit introduction (v3)
References: <20080627151808.31664.36047.sendpatchset@balbir-laptop> <20080628133615.a5fa16cf.kamezawa.hiroyu@jp.fujitsu.com> <4867174B.3090005@linux.vnet.ibm.com> <20080630102054.ee214765.kamezawa.hiroyu@jp.fujitsu.com> <486855DF.2070100@linux.vnet.ibm.com> <20080630125737.4b14785f.kamezawa.hiroyu@jp.fujitsu.com> <48685A72.3090102@linux.vnet.ibm.com> <20080630131920.68d2cc23.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080630131920.68d2cc23.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Mon, 30 Jun 2008 09:30:50 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> KAMEZAWA Hiroyuki wrote:
>>> Hmm, that is the case where "share" works well. Why soft-limit ?
>>> i/o conroller doesn't support share ? (I don' know sorry.)
>>>
>> Share is a proportional allocation of a resource. Typically that resource is
>> soft-limits, but not necessarily. If we re-use resource counters, my expectation
>> is that
>>
>> A share implementation would under-neath use soft-limits.
>>
> Hmm...I don't convice at this point. (because it's future problem)
> At least, please find lock-less approach to check soft-limit.

I've been looking at improving res_counter scalability. One simple approach is
to convert the spin lock to rw spinlock so that reading data can happen in
parallel. The next step would be to explore RCU for resource counters.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
