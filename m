Return-Path: <linux-kernel-owner+w=401wt.eu-S1756814AbZEUUKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbZEUUKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 16:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbZEUUKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 16:10:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57411 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbZEUUKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 16:10:36 -0400
Message-ID: <4A15B4E2.8010908@zytor.com>
Date: Thu, 21 May 2009 13:09:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: "H. Peter Anvin" <hpa@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Robert Richter <robert.richter@amd.com>, Dave Jones <davej@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 1/10 -tip] x86: Add cpufeature for Processor Name
References: <1242142530.2547.11.camel@ht.satnam>	 <1242142623.2547.13.camel@ht.satnam>  <4A14F0A1.3000605@kernel.org> <1242891510.8204.3.camel@localhost.localdomain>
In-Reply-To: <1242891510.8204.3.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
>>>
>> Pointless and wrong.  The presence of the processor name is not the same
>> thing as the presence of specific MSRs, which are model-specific.
>>
> 
>>From AMD's BIOS and Kernel Developer’s Guide(BKDG) Manual :
> 
>  MSRC001_00[35:30] Processor Name String Registers
> Reset: 0000 0000 0000 0000h. These registers holds the CPUID name string in ASCII. The state of these regis-
> ters are returned by CPUID instructions, CPUID Fn8000_000[4:2]. BIOS should set these registers to the
> AMD-provided product name for the processor. Each register contains a block of 8 ASCII characters; the least
> byte corresponds to the first ASCII character of the block; the most-significant byte corresponds to the last
> character of the block. MSRC001_0030 contains the first block of the name string; MSRC001_0035 contains
> the last block of the name string.
> 
>   Bits    Description
>   63:0 CpuNameString. Read-write.
> 

Yes.  Non-AMD processors also have the brand name string in CPUID, but
set them though other means.

	-hpa
