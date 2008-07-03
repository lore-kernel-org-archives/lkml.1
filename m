Return-Path: <linux-kernel-owner+w=401wt.eu-S1758955AbYGCMlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955AbYGCMlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754963AbYGCMk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:40:59 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:28738 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbYGCMk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:40:58 -0400
Message-ID: <19f34abd0807030155x22b0033dj780830bad840216f@mail.gmail.com>
Date: Thu, 3 Jul 2008 10:55:34 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 1/1] x86: Add check for node passed to node_to_cpumask V3
Cc: "Mike Travis" <travis@sgi.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       mm-commits@vger.kernel.org, "Yinghai Lu" <yhlu.kernel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080703084401.GB7873@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806090918.m599Ib0G012837@imap1.linux-foundation.org>
	 <19f34abd0806090420r4100241cgb4b828441de3b102@mail.gmail.com>
	 <20080609113547.GA1534@elte.hu> <484D54F2.4070603@sgi.com>
	 <20080626113229.GB29619@elte.hu> <4863C334.2090007@sgi.com>
	 <486452CC.8050502@sgi.com> <48651EF5.5090808@sgi.com>
	 <20080703084401.GB7873@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 3, 2008 at 10:44 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Mike Travis <travis@sgi.com> wrote:
>
>> Subject: [PATCH 1/1] x86: Add check for node passed to node_to_cpumask V3
>>
>>   * When CONFIG_DEBUG_PER_CPU_MAPS is set, the node passed to
>>     node_to_cpumask and node_to_cpumask_ptr should be validated.
>>     If invalid, then a dump_stack is performed and a zero cpumask
>>     is returned.
>>
>> Based on "Fri Jun 27 10:06:06 PDT 2008" tip/master...  ;-)
>>
>> Signed-off-by: Mike Travis <travis@sgi.com>
>> ---
>> V2: Slightly different version to remove a compiler warning.
>> V3: Redone to reflect moving setup.c -> setup_percpu.c
>
> applied to tip/x86/unify-setup - thanks Mike.
>
> Vegard, can i add your Acked-by too?

To be honest, I'd prefer that the function returns a const pointer.
Mike and I have both reviewed all callers independently and concluded
that there is no problem in doing this, and that, in fact, this is the
correct way to deal with it.

So if Mike submits a V4 with this const return type, or another patch
on top of this one, I'll ack it :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
