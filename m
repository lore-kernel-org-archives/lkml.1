Return-Path: <linux-kernel-owner+w=401wt.eu-S1752462AbYKRAwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbYKRAwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 19:52:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbYKRAwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 19:52:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36663 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbYKRAwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 19:52:42 -0500
Message-ID: <492211C5.7090302@zytor.com>
Date: Mon, 17 Nov 2008 16:52:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Support always running TSC on Intel CPUs
References: <20081118001137.GA12350@linux-os.sc.intel.com> <492208BE.2000001@zytor.com> <7E82351C108FA840AB1866AC776AEC464291B456@orsmsx505.amr.corp.intel.com> <492209C8.7040602@zytor.com> <20081118004918.GA19416@linux-os.sc.intel.com>
In-Reply-To: <20081118004918.GA19416@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Venki Pallipadi wrote:
> On Mon, Nov 17, 2008 at 04:18:16PM -0800, H. Peter Anvin wrote:
>> Pallipadi, Venkatesh wrote:
>>> All C-states higher than C1. 
>>>
>> Including C2?  If so, the TSC is unusable since C2 can be invoked 
>> asynchronously by the chipset.
>>
> 
> No. Not on Intel CPUs atleast. On Intel CPUs, we enter C-states only on
> hlt or mwait.  C1 is always C1 or C1E, where TSC always runs.
> C2, C3, ... implementation vary depending on processor and TSC may or may
> not run. This 0x80000007 feature bit basically says TSC is going to run
> during any C-state.
> 

I was under the impression that C2 was invoked by the chipset on a 
thermal condition, at least on older (P3-era) processors.  Is that no 
longer true?  If what you say is above (HLT and MWAIT only), then *was* 
it ever true?

	-hpa

