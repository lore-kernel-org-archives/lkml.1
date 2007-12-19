Return-Path: <linux-kernel-owner+w=401wt.eu-S1756843AbXLSTg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbXLSTg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 14:36:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbXLSTgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 14:36:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39401 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340AbXLSTgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 14:36:49 -0500
Message-ID: <476972A0.3050105@zytor.com>
Date: Wed, 19 Dec 2007 11:36:00 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Voluntary leave_mm before entering ACPI C3
References: <20071219183443.GA547@linux-os.sc.intel.com> <20071219193255.GA2158@elte.hu>
In-Reply-To: <20071219193255.GA2158@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:
> 
>> Aviod TLB flush IPIs during C3 states by voluntary leave_mm() before 
>> entering C3.
>>
>> The performance impact of TLB flush on C3 should not be significant 
>> with respect to C3 wakeup latency. Also, CPUs tend to flush TLB in 
>> hardware while in C3 anyways.
>>

Are there any CPUs around which *don't* flush the TLB across C3?  (I 
guess it's not guaranteed by the spec, though, and as TLBs grow larger 
there might be incentive to keep them online.)

	-hpa
