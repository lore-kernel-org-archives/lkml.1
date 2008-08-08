Return-Path: <linux-kernel-owner+w=401wt.eu-S1764120AbYHHWfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764120AbYHHWfy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755787AbYHHWfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 18:35:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41670 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755704AbYHHWfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 18:35:45 -0400
Message-ID: <489CC9C6.10100@zytor.com>
Date: Fri, 08 Aug 2008 15:33:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/42] dyn_array/nr_irqs/sparse_irq support v5
References: <1218232368-31228-1-git-send-email-yhlu.kernel@gmail.com>	 <489CC246.5000202@zytor.com>	 <86802c440808081514w3a7ea1d6hda2442e7bf6729a4@mail.gmail.com>	 <489CC7E2.7040209@zytor.com> <86802c440808081530o6c07c3bbl1a52f7a267dc2936@mail.gmail.com>
In-Reply-To: <86802c440808081530o6c07c3bbl1a52f7a267dc2936@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
>> Other architectures may speak for themselves, but why not just support
>> sparse IRQs on x86-32 *and* -64 and skip the dyn_array variant?
> 
> after we merged io_apic_32.c into io_apic_64.c.
> also I want to kill irq balance in io_apic_32.c, but no one say
> anything about it.
> 
> also dyn_array could have other user in addition to nr_irqs.
> i will dig it out like NR_CPUS/nr_cpu_ids related array. and Mike
> tried to put every thing to PER_CPU instead of array, maybe some case
> array would be effient than that. that make dyn_array some usage.

Let the potental other users worry about it at that time.  I understand 
it's a neat feature, but that doesn't justify adding it at this time if 
it's not the right thing forthe job.

I really don't want to see x86-32 and x86-64 diverge more, and I really 
don't want to throw in additional complexity if we don't really need it.

	-hpa

