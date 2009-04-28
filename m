Return-Path: <linux-kernel-owner+w=401wt.eu-S1753306AbZD1TIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbZD1TIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 15:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbZD1TIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 15:08:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:60036 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbZD1TIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 15:08:42 -0400
Message-ID: <49F753DF.6040104@kernel.org>
Date: Tue, 28 Apr 2009 12:07:11 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/9] x86/irq: make MSI irq_desc numa aware -v3
References: <49E68C41.4020801@kernel.org> <20090416090315.GF9813@elte.hu> <49E802CE.5030406@kernel.org> <49E804AD.9020702@kernel.org> <49F6559F.7070005@kernel.org> <20090428101448.GA28495@elte.hu> <49F70FED.3040903@kernel.org> <20090428143254.GA24351@elte.hu>
In-Reply-To: <20090428143254.GA24351@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> Ingo Molnar wrote:
>>> * Yinghai Lu <yinghai@kernel.org> wrote:
>>>
>>>> +#ifdef CONFIG_NUMA_IRQ_DESC
>>>> +		/* different node ?*/
>>>> +		if (desc_new->node != node)
>>>> +			desc = move_irq_desc(desc, node);
>>>> +#endif
>>> this should have been CONFIG_NUMA_MIGRATE_IRQ_DESC. But even with 
>>> that fixed, CONFIG_NUMA_MIGRATE_IRQ_DESC is _removed_ in the #2 
>>> patch in your series and never reintroduced!
>> should change that to CONFIG_SPARSE_IRQ
> 
> That's sensible too.
> 

do you mean add back CONFIG_NUMA_IRQ_DESC?

YH
