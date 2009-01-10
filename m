Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425AbZAJXKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbZAJXKc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 18:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbZAJXKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 18:10:23 -0500
Received: from relay2.sgi.com ([192.48.179.30]:40446 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752031AbZAJXKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 18:10:23 -0500
Message-ID: <49692AD3.9020401@sgi.com>
Date: Sat, 10 Jan 2009 15:10:11 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Yinghai Lu <yinghai@kernel.org>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] irq: change references from NR_IRQS to nr_irqs
References: <20090110223818.459493000@polaris-admin.engr.sgi.com> <20090110223818.636427000@polaris-admin.engr.sgi.com> <20090110224523.GB17917@elte.hu>
In-Reply-To: <20090110224523.GB17917@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> Impact: preparation, cleanup
> 
> s/Impact: preparation, cleanup/Impact: preparation, cleanup, add printk

Hmm, should I attempt the 'git rebase -i' to change this or just fix up
the patch, and repush (getting new commit ids)?

> 
>> @@ -160,9 +162,9 @@ struct irq_desc *irq_to_desc_alloc_cpu(u
>>  	unsigned long flags;
>>  	int node;
>>  
>> -	if (irq >= NR_IRQS) {
>> -		printk(KERN_WARNING "irq >= NR_IRQS in irq_to_desc_alloc: %d %d\n",
>> -				irq, NR_IRQS);
>> +	if (irq >= nr_irqs) {
>> +		printk(KERN_WARNING "irq >= nr_irqs in irq_to_desc_alloc: %d %d\n",
>> +				irq, nr_irqs);
>>  		WARN_ON(1);
>>  		return NULL;
> 
> While at it, could you please also convert this to a WARN() construct 
> instead? (in a separate commit)
> 
> 	Ingo

Yes, I will.

Thanks,
Mike
