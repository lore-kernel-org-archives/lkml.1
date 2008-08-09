Return-Path: <linux-kernel-owner+w=401wt.eu-S1762715AbYHIHal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762715AbYHIHal (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 03:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753647AbYHIHaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 03:30:10 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:63914 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbYHIHaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 03:30:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=i35YD1EiSqUuotf/+GBn0hPe2jgo9XEph3Em52fIsl/M0DBfXG4U4W+orOeUSX3Khz
         vC9cHjIh9k7o85d5f0G31fzNI23zL+q7IyePnRr8/T+VASjHIILNA/rkhk8upONbwbE9
         KU/TvBKQJMFiJssQcyenb1VFINGOWScTVz+ow=
Message-ID: <86802c440808090030k7269590ftf233a13a21a2e37e@mail.gmail.com>
Date: Sat, 9 Aug 2008 00:30:06 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 08/42] introduce nr_irqs
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <489CFA0A.5030609@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218232368-31228-1-git-send-email-yhlu.kernel@gmail.com>
	 <1218232368-31228-4-git-send-email-yhlu.kernel@gmail.com>
	 <1218232368-31228-5-git-send-email-yhlu.kernel@gmail.com>
	 <1218232368-31228-6-git-send-email-yhlu.kernel@gmail.com>
	 <1218232368-31228-7-git-send-email-yhlu.kernel@gmail.com>
	 <1218232368-31228-8-git-send-email-yhlu.kernel@gmail.com>
	 <1218232368-31228-9-git-send-email-yhlu.kernel@gmail.com>
	 <m1ej4zvw6s.fsf@frodo.ebiederm.org>
	 <86802c440808081838r66cc8162t5c2e157908457048@mail.gmail.com>
	 <489CFA0A.5030609@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 8, 2008 at 6:59 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>>
>> On Fri, Aug 8, 2008 at 6:00 PM, Eric W. Biederman <ebiederm@xmission.com>
>> wrote:
>>>
>>> Yinghai Lu <yhlu.kernel@gmail.com> writes:
>>>
>>>> and at this point it is equal NR_IRQS
>>>
>>> This patch is ok, but this approach is fundamentally broken.
>>> Only 19 architectures use GENERIC_HARDIRQS
>>>
>>> The only required interface is interrupt.h not irq.h
>>>
>>> So you may not replace NR_IRQS with nr_irqs in anything other
>>> then genirq code and some architecture code.
>>>
>>> Doing so will break the build on several architectures.
>>
>> some platforms will not use include/linux/irq.h and kernel/irq/handle.c ?
>>
>
> Also, what's the point, if it's just a renaming?

that is the start point.
nr_irqs is variable, and will be probed later. and use that number to
init dyn_alloc.

YH
