Return-Path: <linux-kernel-owner+w=401wt.eu-S1766000AbYECRwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766000AbYECRwb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 13:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757183AbYECRwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 13:52:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43327 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439AbYECRwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 13:52:24 -0400
Message-ID: <481CA63E.50504@zytor.com>
Date: Sat, 03 May 2008 10:51:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: James Courtier-Dutton <James@superbug.co.uk>
CC: Thomas Gleixner <tglx@linutronix.de>, jamal <hadi@cyberus.ca>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Jan Beulich <jbeulich@novell.com>
Subject: Re: i387/FPU init issues...
References: <1209810775.6972.37.camel@localhost> <alpine.LFD.1.10.0805031650120.6003@apollo.tec.linutronix.de> <481CA40A.7040906@zytor.com> <481CA5FC.6020004@superbug.co.uk>
In-Reply-To: <481CA5FC.6020004@superbug.co.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Courtier-Dutton wrote:
> H. Peter Anvin wrote:
>> Thomas Gleixner wrote:
>>>
>>> Jan, are you sure that P3 knows the P6 NOPs ? AFAICT its P4, but I
>>> have to dig up the manuals.
>>>
>>
>> Pentium III is the P6 core, so it will.
>>
>> Intel explicitly documents "all processors with family 6 or F."
>>
>> -hpa
> 
>  From the intel manual
> 
> 0F 1F /0 NOP
> The multi-byte form of NOP is available on processors with model encoding:
> • CPUID.01H.EAX[Bytes 11:8] = 0110B or 1111B
> The multi-byte NOP instruction does not alter the content of a register 
> and will not
> issue a memory operation. The instruction’s operation is the same in 
> non-64-bit
> modes and 64-bit mode.
> 

I believe that's what I just said...

	-hpa
