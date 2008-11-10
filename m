Return-Path: <linux-kernel-owner+w=401wt.eu-S1753620AbYKJPc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbYKJPc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 10:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbYKJPcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 10:32:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54840 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbYKJPcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 10:32:48 -0500
Message-ID: <491853F6.7030803@zytor.com>
Date: Mon, 10 Nov 2008 07:32:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mark McLoughlin <markmc@redhat.com>
CC: akataria@vmware.com, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
Subject: Re: [PATCH 2/4] Hypervisor detection and get tsc_freq from	hypervisor
References: <1224894104.28224.72.camel@alok-dev1>	 <20081027110134.GC13641@elte.hu>  <1225129306.28018.9.camel@alok-dev1> <1226320720.4068.54.camel@blaa>
In-Reply-To: <1226320720.4068.54.camel@blaa>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark McLoughlin wrote:
>>
>> diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
>> index f73e95d..78478f2 100644
>> --- a/arch/x86/include/asm/cpufeature.h
>> +++ b/arch/x86/include/asm/cpufeature.h
>> @@ -117,6 +117,7 @@
>>  #define X86_FEATURE_XSAVE	(4*32+26) /* XSAVE/XRSTOR/XSETBV/XGETBV */
>>  #define X86_FEATURE_OSXSAVE	(4*32+27) /* "" XSAVE enabled in the OS */
>>  #define X86_FEATURE_AVX		(4*32+28) /* Advanced Vector Extensions */
>> +#define X86_FEATURE_HYPERVISOR	(4*32+31) /* Running on a hypervisor */
> 
> I don't see you set this anywhere.
> 

This bit is set by the hypervisor in the pattern returned by the CPUID
instruction.

	-hpa
