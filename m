Return-Path: <linux-kernel-owner+w=401wt.eu-S1759198AbYBZHm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759198AbYBZHm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 02:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbYBZHmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 02:42:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32835 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbYBZHmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 02:42:18 -0500
Message-ID: <47C3C0D1.1020304@zytor.com>
Date: Mon, 25 Feb 2008 23:33:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86_64: remove wrong setting about CONSTANT_TSC for intel
 cpu
References: <200802252320.01534.yinghai.lu@sun.com>	 <20080226072035.GB24820@elte.hu> <86802c440802252324u769f087fw83caa26c1960354e@mail.gmail.com>
In-Reply-To: <86802c440802252324u769f087fw83caa26c1960354e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
>>  which is the same. set_cpu_cap() is indeed the cleaner form to do this
>>  so your patch is correct as a cleanup.
> set_cpu_cap is right
> ==
> set_bit(X86_FEATURE_CONSTANT_TSC, &c->x86_capability); ===> is wrong
> should be
> set_bit(X86_FEATURE_CONSTANT_TSC, c->x86_capability);
> 
> x86_capability is a array ...
> 

For an array, the & is optional and has no effect.

So they mean the same thing.

	-hpa
