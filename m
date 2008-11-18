Return-Path: <linux-kernel-owner+w=401wt.eu-S1752503AbYKRDbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbYKRDbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 22:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbYKRDbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 22:31:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48091 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbYKRDbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 22:31:08 -0500
Message-ID: <4922361F.3000608@zytor.com>
Date: Mon, 17 Nov 2008 19:27:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Support always running TSC on Intel CPUs
References: <20081118001137.GA12350@linux-os.sc.intel.com>	<492208BE.2000001@zytor.com>	<7E82351C108FA840AB1866AC776AEC464291B456@orsmsx505.amr.corp.intel.com>	<492209C8.7040602@zytor.com>	<20081118004918.GA19416@linux-os.sc.intel.com>	<492211C5.7090302@zytor.com>	<20081118010528.GA22044@linux-os.sc.intel.com>	<4922154E.4050108@zytor.com> <20081117192629.664fc364@infradead.org>
In-Reply-To: <20081117192629.664fc364@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
>>>
>> I believe there are CPUs -- again, in the P3-era range at least --
>> which invoke C2 from the chipset on thermal conditions (and basically
>> PWM the CPU.)  I'd like to get that clarified so we don't trip up on
>> that.
> 
> p3-era cpus didn't stop tsc in c2 afaik.
> 

OK, that's an important distinction too, then.

	-hpa
