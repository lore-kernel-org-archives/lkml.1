Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab0CDTWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 14:22:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:46809 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755235Ab0CDTWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 14:22:22 -0500
Message-ID: <4B900809.7050406@kernel.org>
Date: Thu, 04 Mar 2010 11:20:41 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Eric Biederman <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>, Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 06/12] genericirq: make irq_chip related function to take
 desc
References: <1267697339-5491-1-git-send-email-yinghai@kernel.org> <1267697339-5491-7-git-send-email-yinghai@kernel.org> <alpine.LFD.2.00.1003041142460.2014@localhost.localdomain> <4B900250.8020100@kernel.org> <alpine.LFD.2.00.1003042005000.2014@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1003042005000.2014@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2010 11:08 AM, Thomas Gleixner wrote:
> On Thu, 4 Mar 2010, Yinghai Lu wrote:
>> On 03/04/2010 06:31 AM, Thomas Gleixner wrote:
>>> The code which uses the chip functions needs to be changed:
>>>
>>> -	desc->chip->fun(irq);
>>> +	desc->chip->fun(desc);
>>>
>>> That's mostly in kernel/irq/* but there are some users in arch/*
>>> lowlevel irq handling code as well.
>>
>> that is our -v2 version.
> 
> I know, but the difference is that it is done by a machine.
> 
> I have been involved in more than one large scale overhaul projects in
> the kernel and most of the time I spent on those was to figure out the
> right way to do it to limit the risks.

sure.

> 
> Automated conversion is the best thing you can do and if Julia can
> whip up that rules, I'm less worried about the wholesale switchover on
> a per function basis, than I'm scared about the fully manual approach
> you took.

ok, let wait for Julia to check it...

Thanks

Yinghai
