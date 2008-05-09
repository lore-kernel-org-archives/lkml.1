Return-Path: <linux-kernel-owner+w=401wt.eu-S1758926AbYEIPBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926AbYEIPBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 11:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbYEIPAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 11:00:53 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:38206 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753991AbYEIPAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 11:00:50 -0400
Message-ID: <4824673B.1030503@suse.de>
Date: Fri, 09 May 2008 19:01:15 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       WANG Cong <xiyou.wangcong@gmail.com>, toralf.foerster@gmx.de,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Travis <travis@sgi.com>
Subject: Re: build issue #380 for v2.6.26-rc1-279-g28a4acb : mach-voyager:
 multiple definition of `phys_cpu_present_map'
References: <200805091114.00244.toralf.foerster@gmx.de> <20080509095244.GJ2543@hacking> <20080509095837.GB19617@elte.hu> <1210342946.3069.4.camel@localhost.localdomain> <20080509144722.GA20566@elte.hu>
In-Reply-To: <20080509144722.GA20566@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
>>>>  /* Bitmask of CPUs present in the system - exported by i386_syms.c, used
>>>>   * by scheduler but indexed physically */
>>>> -cpumask_t phys_cpu_present_map = CPU_MASK_NONE;
>>>> +static cpumask_t phys_cpu_present_map = CPU_MASK_NONE;
>>> i've got the one below queued up but it's stalled as it could easily be 
>>> wrong and there's no ack from James yet and there's been discussion back 
>>> and forth. James, what do you suggest?
> 
>> I already told you that this was incorrect.  This is what I sent as 
>> the replacement on 28 April and I didn't hear back from you.
>>
>> http://marc.info/?l=linux-kernel&m=120941111400620
> 
> ok - picked it up for testing - could you please send a signoff line as 
> well?
> 
> Alexey, you moved those SMP variables, do you agree with the patch from 
> James? (it looks good to me)
Yes, they look good to me as well.
Alex.
