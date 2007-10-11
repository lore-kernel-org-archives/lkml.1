Return-Path: <linux-kernel-owner+w=401wt.eu-S1757562AbXJKWYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562AbXJKWYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 18:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759008AbXJKWX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 18:23:59 -0400
Received: from omta03ps.mx.bigpond.com ([144.140.82.155]:53094 "EHLO
	omta03ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758917AbXJKWX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 18:23:58 -0400
Message-ID: <470EA277.7090107@bigpond.net.au>
Date: Fri, 12 Oct 2007 08:23:51 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: Rationalize sys_sched_rr_get_interval()
References: <470D7055.4090000@bigpond.net.au> <20071011065946.GB32125@elte.hu> <b647ffbd0710110044r5424d7ffi58fc64221a440c7d@mail.gmail.com>
In-Reply-To: <b647ffbd0710110044r5424d7ffi58fc64221a440c7d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta04ps.mx.bigpond.com from [121.222.199.46] using ID pwil3058@bigpond.net.au at Thu, 11 Oct 2007 22:23:51 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Adamushko wrote:
> On 11/10/2007, Ingo Molnar <mingo@elte.hu> wrote:
>> * Peter Williams <pwil3058@bigpond.net.au> wrote:
>>
>>> -#define MIN_TIMESLICE                max(5 * HZ / 1000, 1)
>>> -#define DEF_TIMESLICE                (100 * HZ / 1000)
>> hm, this got removed by Dmitry quite some time ago. Could you please do
>> this patch against the sched-devel git tree:
> 
> here is the commit:
> http://git.kernel.org/?p=linux/kernel/git/mingo/linux-2.6-sched-devel.git;a=commit;h=dd3fec36addd1bf76b05225b7e483378b80c3f9e
> 
> I had also considered introducing smth like
> sched_class::task_timeslice() but decided it was not worth it.

The reason I was going that route was for modularity (which helps when 
adding plugsched patches).  I'll submit a revised patch for consideration.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
