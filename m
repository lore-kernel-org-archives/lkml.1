Return-Path: <linux-kernel-owner+w=401wt.eu-S932131AbXB1KQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131AbXB1KQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 05:16:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932134AbXB1KQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 05:16:08 -0500
Received: from relay00.pair.com ([209.68.5.9]:3356 "HELO relay00.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932133AbXB1KQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 05:16:07 -0500
X-pair-Authenticated: 24.241.238.207
Message-ID: <45E55664.90407@cybsft.com>
Date: Wed, 28 Feb 2007 04:16:04 -0600
From: "K.R. Foley" <kr@cybsft.com>
Organization: Cybersoft Solutions, Inc.
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: v2.6.20-rt1, yum/rpm
References: <20070205065636.GA1652@elte.hu> <45E46CB4.1080009@cybsft.com> <20070228081132.GA32405@elte.hu>
In-Reply-To: <20070228081132.GA32405@elte.hu>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * K.R. Foley <kr@cybsft.com> wrote:
> 
>> Ingo Molnar wrote:
>>> i have released the v2.6.20-rt1 kernel, which can be downloaded from the 
>>> usual place:
>>>
>> I have a couple of questions regarding priorities of the softirqs, IRQ 
>> handlers, etc.
>>
>> With some exceptions, back in 2.6.18 and prior patches the IRQ threads 
>> were prioritized between 50 and 25 and the most of the softirqs were 
>> prioritized at 1? In newer patches it looks like they are all 
>> prioritized at 50?
>>
>> I was just curious what went into making these choices? I am just 
>> trying to better understand these decisions.
> 
> The basically random order-of-request_irq() prioritization was causing 
> problems (it worked for some but didnt work for others), so i got rid of 
> trying to auto-guess some priority order. Also, now that we've got 
> tools/scripts like set_kthread_prio and rtprio it seemed more consistent 
> to just not attempt to prioritize interrupts and softirqs at all, but to 
> keep them all 'in the middle' of the RT priority range.
> 
> 	Ingo
> 

Thanks.

-- 
	kr
