Return-Path: <linux-kernel-owner+w=401wt.eu-S1754447AbYGXOgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447AbYGXOgs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 10:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbYGXOgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 10:36:40 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:10223 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbYGXOgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 10:36:39 -0400
X-BigFish: VPS-14(zz1432R98dR936eT62a3Lzz10d3izzz32i6bh87il63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K4ILWI-02-0XP-01
Date: Thu, 24 Jul 2008 16:36:14 +0200
From: Robert Richter <robert.richter@amd.com>
To: Maynard Johnson <maynardj@us.ibm.com>
CC: Barry Kasindorf <barry.kasindorf@amd.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [PATCH 11/24] x86/oprofile: Add IBS support for AMD CPUs,
	model specific code
Message-ID: <20080724143613.GR17134@erda.amd.com>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com> <1216753748-11261-12-git-send-email-robert.richter@amd.com> <48888E7C.7040504@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <48888E7C.7040504@us.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 24 Jul 2008 14:36:21.0802 (UTC) FILETIME=[A457C0A0:01C8ED9A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.07.08 09:15:24, Maynard Johnson wrote:
> Robert Richter wrote:
>> From: Barry Kasindorf <barry.kasindorf@amd.com>
>> This patchset supports the new profiling hardware available in the
>> latest AMD CPUs in the oProfile driver.
>> Signed-off-by: Barry Kasindorf <barry.kasindorf@amd.com>
>> Signed-off-by: Robert Richter <robert.richter@amd.com>
>> ---
>>  arch/x86/oprofile/op_model_athlon.c |  257 
>> +++++++++++++++++++++++++++++++++++
>>  1 files changed, 257 insertions(+), 0 deletions(-)
>> diff --git a/arch/x86/oprofile/op_model_athlon.c 
>> b/arch/x86/oprofile/op_model_athlon.c
>> index 40ecb02..229e0b4 100644
>> --- a/arch/x86/oprofile/op_model_athlon.c
>> +++ b/arch/x86/oprofile/op_model_athlon.c
>> @@ -9,9 +9,13 @@
>>   * @author Philippe Elie
>>   * @author Graydon Hoare
>>   * @author Robert Richter <robert.richter@amd.com>
>> + * @author Barry Kasindorf
>>  */
> [snip]
>> +
>> +struct op_ibs_config {
>> +	unsigned long op_enabled;
>> +	unsigned long fetch_enabled;
>> +	unsigned long max_cnt_fetch;
>> +	unsigned long max_cnt_op;
>> +	unsigned long rand_en;
>> +	unsigned long dispatched_ops;
> I don't see dispatched_ops being used either by your kernel driver changes 
> or by the userspace changes submitted by Jason.

This is a RevC feature. I think there is a revision check needed and
thus Barry did not yet implement it.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

