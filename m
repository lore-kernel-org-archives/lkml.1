Return-Path: <linux-kernel-owner+w=401wt.eu-S1761249AbYHICLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761249AbYHICLk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 22:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbYHICL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 22:11:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47887 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbYHICL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 22:11:28 -0400
Message-ID: <489CFA0A.5030609@zytor.com>
Date: Fri, 08 Aug 2008 18:59:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/42] introduce nr_irqs
References: <1218232368-31228-1-git-send-email-yhlu.kernel@gmail.com>	 <1218232368-31228-2-git-send-email-yhlu.kernel@gmail.com>	 <1218232368-31228-3-git-send-email-yhlu.kernel@gmail.com>	 <1218232368-31228-4-git-send-email-yhlu.kernel@gmail.com>	 <1218232368-31228-5-git-send-email-yhlu.kernel@gmail.com>	 <1218232368-31228-6-git-send-email-yhlu.kernel@gmail.com>	 <1218232368-31228-7-git-send-email-yhlu.kernel@gmail.com>	 <1218232368-31228-8-git-send-email-yhlu.kernel@gmail.com>	 <1218232368-31228-9-git-send-email-yhlu.kernel@gmail.com>	 <m1ej4zvw6s.fsf@frodo.ebiederm.org> <86802c440808081838r66cc8162t5c2e157908457048@mail.gmail.com>
In-Reply-To: <86802c440808081838r66cc8162t5c2e157908457048@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Fri, Aug 8, 2008 at 6:00 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> Yinghai Lu <yhlu.kernel@gmail.com> writes:
>>
>>> and at this point it is equal NR_IRQS
>> This patch is ok, but this approach is fundamentally broken.
>> Only 19 architectures use GENERIC_HARDIRQS
>>
>> The only required interface is interrupt.h not irq.h
>>
>> So you may not replace NR_IRQS with nr_irqs in anything other
>> then genirq code and some architecture code.
>>
>> Doing so will break the build on several architectures.
> 
> some platforms will not use include/linux/irq.h and kernel/irq/handle.c ?
> 

Also, what's the point, if it's just a renaming?

	-hpa
