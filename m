Return-Path: <linux-kernel-owner+w=401wt.eu-S1754189AbYHLOPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbYHLOPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 10:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbYHLOO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 10:14:58 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:38577 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbYHLOO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 10:14:57 -0400
X-BigFish: VPS-17(z34a4lz1432R98dR1805Mzz10d3izzz32i6bh43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K5HRK8-02-K2H-01
Message-ID: <48A19ACB.8020109@amd.com>
Date: Tue, 12 Aug 2008 16:14:35 +0200
From: Peter Oruba <peter.oruba@amd.com>
Organization: AMD (OSRC)
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 4/5] [PATCH 4/5] x86: Minor correction to Intel	microcode
 patch loader.
References: <20080806152117.198754464@amd.com> <20080806152320.081968686@amd.com> <20080811192713.GG12788@elte.hu>
In-Reply-To: <20080811192713.GG12788@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Aug 2008 14:14:35.0917 (UTC) FILETIME=[BFD2C3D0:01C8FC85]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar schrieb:
> * Peter Oruba <peter.oruba@amd.com> wrote:
> 
>> Signed-off-by: Peter Oruba <peter.oruba@amd.com>
>> ---
>>  arch/x86/kernel/microcode_intel.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
>> index 4ab6ce3..8d69470 100644
>> --- a/arch/x86/kernel/microcode_intel.c
>> +++ b/arch/x86/kernel/microcode_intel.c
>> @@ -315,7 +315,7 @@ static void apply_microcode(int cpu)
>>  	unsigned long flags;
>>  	unsigned int val[2];
>>  	int cpu_num = raw_smp_processor_id();
>> -	struct ucode_cpu_info *uci = get_ucode_cpu_info(cpu);
>> +	struct ucode_cpu_info *uci = get_ucode_cpu_info(cpu_num);
> 
> hm, this does not apply to tip/x86/microcode nor tip/master nor 
> linus/master. Does it fix a bug in one of the earlier patches in this 
> 5/5 queue?
> 
> 	Ingo
> 
Yes, it's a fix for PATCH 3/5

-Peter

-- 
            |           AMD Saxony Limited Liability Company & Co. KG
  Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
  System    |                  Register Court Dresden: HRA 4896
  Research  |              General Partner authorized to represent:
  Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
            | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

