Return-Path: <linux-kernel-owner+w=401wt.eu-S1758759AbYBYSfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759AbYBYSfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 13:35:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756071AbYBYSfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 13:35:00 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51953 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686AbYBYSe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 13:34:59 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5237"; a="894929"
Message-ID: <47C30A50.5010709@qualcomm.com>
Date: Mon, 25 Feb 2008 10:34:56 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] Genirq and CPU isolation
References: <47BFBAE6.3040606@qualcomm.com> <20080224174727.1a3f4dd7.randy.dunlap@oracle.com>
In-Reply-To: <20080224174727.1a3f4dd7.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Fri, 22 Feb 2008 22:19:18 -0800 Max Krasnyansky wrote:
> 
> Hi Max,
> 
>> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
>> index 438a014..e74db94 100644
>> --- a/kernel/irq/manage.c
>> +++ b/kernel/irq/manage.c
>> @@ -488,6 +491,26 @@ void free_irq(unsigned int irq, void *dev_id)
>>  }
>>  EXPORT_SYMBOL(free_irq);
>>  
>> +#ifndef CONFIG_AUTO_IRQ_AFFINITY
>> +/**
>> + * Generic version of the affinity autoselector.
>> + * Called under desc->lock from setup_irq().
>> + * btw Should we rename this to select_irq_affinity() ?
>> + */
> 
> Please don't begin comment blocks with "/**" unless they are in
> kernel-doc format.  (See Documentation/kernel-doc-nano-HOWTO.txt
> for details of it.)
My bad. Cut & pasted another function and forgot to nuke one asterisk.

Thanx for the review Randy.
Max
