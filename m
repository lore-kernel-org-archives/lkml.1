Return-Path: <linux-kernel-owner+w=401wt.eu-S1761422AbYG3M6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761422AbYG3M6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 08:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754808AbYG3M6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 08:58:23 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57520 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751777AbYG3M6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 08:58:23 -0400
Message-ID: <4890656D.4080906@sgi.com>
Date: Wed, 30 Jul 2008 05:58:21 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: RFC [PATCH] x86: introduce nr_irqs for 64bit
References: <200807291414.55479.yhlu.kernel@gmail.com> <200807292138.41720.yhlu.kernel@gmail.com> <20080730100926.GA10431@elte.hu>
In-Reply-To: <20080730100926.GA10431@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> 
>> add DEFINE_DYN_ARRAY for dynamical array support
>>
>> todo:
>> 1. convert x86 32bit and other arch
>> 2. nr_irqs auto probe via acpi_oem_check?
>>
>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> wonderful!
> 
> I have one main structural suggestion: could we please keep the NR_IRQS 
> name, and just change it to dynamic on x86? NR_IRQS is used in 540 
> places in the kernel, there's no point in touching all that code.

Good thought.
> 
> Also add an CONFIG_ARCH_HAS_DYNAMIC_NR_IRQS switch, define it in 
> arch/x86/Kconfig and use it in include/linux/irq.h.

It could also revert DEFINE_DYN_ARRAY to a fixed array for more
compact code in small machines.

Thanks,
Mike
> 
> This will create far less migration pain than the widespread rename. 
> That will also solve the "what about the other architectures" question.
> 
> 	Ingo

