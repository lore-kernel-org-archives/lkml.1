Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbZFFWIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbZFFWIX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 18:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbZFFWIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 18:08:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:59040 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbZFFWIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 18:08:15 -0400
Message-ID: <4A2AE8A8.5050800@kernel.org>
Date: Sat, 06 Jun 2009 15:07:36 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Avi Kivity <avi@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] cpumask: introduce zalloc_cpumask_var
References: <4A2835D8.6040903@kernel.org>	<200906051428.08299.rusty@rustcorp.com.au>	<4A28B3A9.3010505@kernel.org>	<200906052311.57762.rusty@rustcorp.com.au>	<4A2A356B.6090102@redhat.com>	<4A2A38B9.7030809@kernel.org>	<4A2A3969.5030101@redhat.com>	<4A2A4B80.1010605@kernel.org>	<4A2AE4AC.60805@kernel.org> <20090606145618.e6ce8563.akpm@linux-foundation.org>
In-Reply-To: <20090606145618.e6ce8563.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 06 Jun 2009 14:50:36 -0700 Yinghai Lu <yinghai@kernel.org> wrote:
> 
>>  bool alloc_cpumask_var_node(cpumask_var_t *mask, gfp_t flags, int node);
>>  bool alloc_cpumask_var(cpumask_var_t *mask, gfp_t flags);
>> +bool zalloc_cpumask_var_node(cpumask_var_t *mask, gfp_t flags, int node);
>> +bool zalloc_cpumask_var(cpumask_var_t *mask, gfp_t flags);
>>  void alloc_bootmem_cpumask_var(cpumask_var_t *mask);
> 
> ick.  cpumask_var_node_zalloc() would be better.
> 
> Yes, the other functions were incorrectly named, but that's no reason
> to incorrectly name these also.

problem is that we would using alloc_cpumask_var and zalloc_cpumask in different case.

so we may need to change these name at the same time. otherwise will cause confusing. No?

YH
