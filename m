Return-Path: <linux-kernel-owner+w=401wt.eu-S1763302AbXJXQvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763302AbXJXQvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760767AbXJXQ20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:28:26 -0400
Received: from homer.mvista.com ([63.81.120.158]:11810 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760727AbXJXQ2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:28:24 -0400
Message-ID: <471F72AD.8030902@ct.jp.nec.com>
Date: Wed, 24 Oct 2007 09:28:29 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: vgoyal@in.ibm.com
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, hbabu@us.ibm.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       kexec@lists.infradead.org
Subject: Re: [PATCH 0/3] x86: unify crash_32/64.c
References: <47195763.1090803@ct.jp.nec.com> <20071024063434.GC4622@in.ibm.com>
In-Reply-To: <20071024063434.GC4622@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Fri, Oct 19, 2007 at 06:18:27PM -0700, Hiroshi Shimamoto wrote:
>> Hi,
>>
>> I made patches to unify crash_32/64.c.
>> There are three patches;
>> 1. add lapic_shutdown for x86_64
>> 2. add safe_smp_processor_id for x86_64
>> 3. unify crash_32/64.c
>>
>> I'm not sure that it's good to split to these patches.
>>
>> I've compiled on both of 32bit and 64bit, and tested
>> kdump on 64bit.
>>
> 
> Hi Hiroshi,
> 
> Thanks for the patches. Can you please also test it on 32bit to make
> sure nothing is broken.

Okay, I'll test it on 32bit.
A build problem already has been found on 32bit.

Thanks,
Hiroshi
