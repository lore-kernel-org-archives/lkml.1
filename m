Return-Path: <linux-kernel-owner+w=401wt.eu-S1763294AbYAHRRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763294AbYAHRRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 12:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbYAHRRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 12:17:06 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:65433 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbYAHRRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 12:17:05 -0500
Message-ID: <4783AFE5.6040102@ct.jp.nec.com>
Date: Tue, 08 Jan 2008 09:16:21 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: enable irq in default_idle
References: <4782984F.3050601@ct.jp.nec.com> <20080108080419.GD31838@elte.hu>
In-Reply-To: <20080108080419.GD31838@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:
> 
>> Hi Ingo,
>>
>> I think local_irq_enable() is missing in default_idle() on x86_64. 
>> It's for recent x86 tree.
>>
>> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>> Subject: [PATCH] x86_64: enable irq in default_idle
>>
>> local_irq_enable() is missing after sched_clock_idle_wakeup_event().
> 
> thanks Hiroshi, applied.
> 
> The effects of this bug should be increased latencies on 64-bit. Did you 
> notice these latencies, or did you find the bug in some other way (code 
> review)?

I found this when I was comparing 32-bit and 64-bit source code
for x86 unification.

Thanks,
Hiroshi Shimamoto

