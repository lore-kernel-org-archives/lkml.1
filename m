Return-Path: <linux-kernel-owner+w=401wt.eu-S1754921AbXJYR6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbXJYR6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 13:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755573AbXJYR6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 13:58:10 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:55456 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362AbXJYR6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 13:58:09 -0400
Message-ID: <4720D933.3080703@ct.jp.nec.com>
Date: Thu, 25 Oct 2007 10:58:11 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: vgoyal@in.ibm.com
Cc: hbabu@us.ibm.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       kexec@lists.infradead.org
Subject: Re: [PATCH 0/3] x86: unify crash_32/64.c
References: <47195763.1090803@ct.jp.nec.com> <20071024063434.GC4622@in.ibm.com> <471F72AD.8030902@ct.jp.nec.com>
In-Reply-To: <471F72AD.8030902@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hiroshi Shimamoto wrote:
> Vivek Goyal wrote:
>> On Fri, Oct 19, 2007 at 06:18:27PM -0700, Hiroshi Shimamoto wrote:
>>> Hi,
>>>
>>> I made patches to unify crash_32/64.c.
>>> There are three patches;
>>> 1. add lapic_shutdown for x86_64
>>> 2. add safe_smp_processor_id for x86_64
>>> 3. unify crash_32/64.c
>>>
>>> I'm not sure that it's good to split to these patches.
>>>
>>> I've compiled on both of 32bit and 64bit, and tested
>>> kdump on 64bit.
>>>
>> Hi Hiroshi,
>>
>> Thanks for the patches. Can you please also test it on 32bit to make
>> sure nothing is broken.
> 
> Okay, I'll test it on 32bit.
> A build problem already has been found on 32bit.
> 
I'm now testing crash on 32bit, but there is an issue before
applying the patches. My machine stopped at checking 'hlt'
after kexec, showing below message.

CPU: Intel(R) Xeon(TM) CPU 3.80GHz stepping 0a
Checking 'hlt' instruction...

v2.6.23.1 works fine for 1st kernel.
I'm investigating it..

Thanks
Hiroshi Shimamoto
