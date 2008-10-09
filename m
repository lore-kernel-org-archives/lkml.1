Return-Path: <linux-kernel-owner+w=401wt.eu-S1756895AbYJIHIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbYJIHIN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 03:08:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755009AbYJIHH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 03:07:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62072 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbYJIHH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 03:07:57 -0400
Message-ID: <48EDAD55.2000502@cn.fujitsu.com>
Date: Thu, 09 Oct 2008 15:05:57 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       rjw@sisk.pl, dipankar@in.ibm.com, tglx@linuxtronix.de
Subject: Re: [PATCH] rudimentary tracing for Classic RCU
References: <20081006232837.GA1157@basil.nowhere.org> <20081007030822.GC6820@linux.vnet.ibm.com> <20081007071544.GC20740@one.firstfloor.org> <20081007152629.GH6384@linux.vnet.ibm.com> <20081007154939.GN20740@one.firstfloor.org> <20081007163401.GJ6384@linux.vnet.ibm.com> <20081007210947.GP20740@one.firstfloor.org> <20081007212215.GN6384@linux.vnet.ibm.com> <20081009010846.GA10188@linux.vnet.ibm.com> <48EDA2A6.9070707@cn.fujitsu.com> <20081009065529.GC24560@one.firstfloor.org>
In-Reply-To: <20081009065529.GC24560@one.firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> In this case, why not define it as:
>> static char buf[20*NR_CPUS + 100];
> 
> Actually you should near never use NR_CPUS now but always num_possible_cpus()
> (or even num_online_cpus()) Using NR_CPUS can lead to extreme waste
> of memory on kernels which are compiled for 4096 CPUs for example.
> 
> And with num_possible_cpus() kmalloc is needed.
> 
> -Andi
> 
> 
> 

I thought the default value of NR_CPUS is 32.

if NR_CPUS is too large, I think using seq_file is good idea,
and rcuclassic_trace_mutex is not need too.

Lai

