Return-Path: <linux-kernel-owner+w=401wt.eu-S1752612AbYKRBHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbYKRBHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 20:07:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbYKRBHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 20:07:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60184 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbYKRBHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 20:07:36 -0500
Message-ID: <4922154E.4050108@zytor.com>
Date: Mon, 17 Nov 2008 17:07:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Support always running TSC on Intel CPUs
References: <20081118001137.GA12350@linux-os.sc.intel.com> <492208BE.2000001@zytor.com> <7E82351C108FA840AB1866AC776AEC464291B456@orsmsx505.amr.corp.intel.com> <492209C8.7040602@zytor.com> <20081118004918.GA19416@linux-os.sc.intel.com> <492211C5.7090302@zytor.com> <20081118010528.GA22044@linux-os.sc.intel.com>
In-Reply-To: <20081118010528.GA22044@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Venki Pallipadi wrote:
>>>
>> I was under the impression that C2 was invoked by the chipset on a
>> thermal condition, at least on older (P3-era) processors.  Is that no
>> longer true?  If what you say is above (HLT and MWAIT only), then *was*
>> it ever true?
> 
> I should also add io port based C-state to HLT and MWAIT. But, that again is
> OS initiated.
> 
> I don't know of C2 invocation in thermal condition. Thermal condition, all
> CPUs that I know of (P3 and beyond), use either clock modulation or frequency
> changes. And on some such CPUs, where TSC runs at constant freq during such
> modulation/freq change, we set CONSTANT_TSC bit based on model number check.
> So, on CPUs earlier than those, we cannot use TSC or we have to scale TSC
> based on freq. This patch shouldn't have any impact for those CPUs.
> 

I believe there are CPUs -- again, in the P3-era range at least -- which 
invoke C2 from the chipset on thermal conditions (and basically PWM the 
CPU.)  I'd like to get that clarified so we don't trip up on that.

	-hpa

