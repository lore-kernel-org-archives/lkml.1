Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbYAWOha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbYAWOha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 09:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbYAWOhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 09:37:22 -0500
Received: from relay2.sgi.com ([192.48.171.30]:40661 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752176AbYAWOhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 09:37:20 -0500
Message-ID: <4797511E.9020704@sgi.com>
Date: Wed, 23 Jan 2008 06:37:18 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
CC: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <clameter@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: remove duplicated line about x86_bios_cpu_apicid_early_ptr
References: <200801230056.16424.yinghai.lu@sun.com> <47974C53.2060202@sgi.com>
In-Reply-To: <47974C53.2060202@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Yinghai Lu wrote:
>> [PATCH] x86_64: remove duplicated line about x86_bios_cpu_apicid_early_ptr
>>
>> Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
>>
>> diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
>> index 2643a8f..b587166 100644
>> --- a/arch/x86/kernel/setup_64.c
>> +++ b/arch/x86/kernel/setup_64.c
>> @@ -349,7 +349,6 @@ void __init setup_arch(char **cmdline_p)
>>  #ifdef CONFIG_NUMA
>>  	x86_cpu_to_node_map_early_ptr = (void *)&x86_cpu_to_node_map_init;
>>  #endif
>> -	x86_bios_cpu_apicid_early_ptr = (void *)&x86_bios_cpu_apicid_init;
>>  #endif
>>  
>>  #ifdef CONFIG_ACPI
> 
> 
> Thanks Yinghai!
> 
> I wonder how this got past my testing (I do build and test !SMP and !NUMA
> versions.)  I'll check into this.

Hmm, never mind.  Coffee has cleared up my confusion...

> 
> Regards,
> Mike

