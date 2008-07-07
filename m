Return-Path: <linux-kernel-owner+w=401wt.eu-S1753790AbYGGRXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbYGGRXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 13:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbYGGRXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 13:23:15 -0400
Received: from relay1.sgi.com ([192.48.171.29]:60953 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753871AbYGGRXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 13:23:14 -0400
Message-ID: <48725101.40800@sgi.com>
Date: Mon, 07 Jul 2008 10:23:13 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       mm-commits@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] x86: Add check for node passed to node_to_cpumask
 V3
References: <200806090918.m599Ib0G012837@imap1.linux-foundation.org>	 <19f34abd0806090420r4100241cgb4b828441de3b102@mail.gmail.com>	 <20080609113547.GA1534@elte.hu> <484D54F2.4070603@sgi.com>	 <20080626113229.GB29619@elte.hu> <4863C334.2090007@sgi.com>	 <486452CC.8050502@sgi.com> <48651EF5.5090808@sgi.com>	 <20080703084401.GB7873@elte.hu> <19f34abd0807030155x22b0033dj780830bad840216f@mail.gmail.com>
In-Reply-To: <19f34abd0807030155x22b0033dj780830bad840216f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> On Thu, Jul 3, 2008 at 10:44 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> * Mike Travis <travis@sgi.com> wrote:
>>
>>> Subject: [PATCH 1/1] x86: Add check for node passed to node_to_cpumask V3
>>>
>>>   * When CONFIG_DEBUG_PER_CPU_MAPS is set, the node passed to
>>>     node_to_cpumask and node_to_cpumask_ptr should be validated.
>>>     If invalid, then a dump_stack is performed and a zero cpumask
>>>     is returned.
>>>
>>> Based on "Fri Jun 27 10:06:06 PDT 2008" tip/master...  ;-)
>>>
>>> Signed-off-by: Mike Travis <travis@sgi.com>
>>> ---
>>> V2: Slightly different version to remove a compiler warning.
>>> V3: Redone to reflect moving setup.c -> setup_percpu.c
>> applied to tip/x86/unify-setup - thanks Mike.
>>
>> Vegard, can i add your Acked-by too?
> 
> To be honest, I'd prefer that the function returns a const pointer.
> Mike and I have both reviewed all callers independently and concluded
> that there is no problem in doing this, and that, in fact, this is the
> correct way to deal with it.
> 
> So if Mike submits a V4 with this const return type, or another patch
> on top of this one, I'll ack it :-)
> 
> 
> Vegard
> 

Sure, I can do this...

Thanks,
Mike
