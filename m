Return-Path: <linux-kernel-owner+w=401wt.eu-S1754824AbYKJJBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbYKJJBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 04:01:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbYKJJBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 04:01:38 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:56454 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbYKJJBi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 04:01:38 -0500
Message-ID: <4917F85E.5080306@cosmosbay.com>
Date: Mon, 10 Nov 2008 10:01:18 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] OProfile fixes for v2.6.28
References: <20081107171339.GQ9785@erda.amd.com>	<4917EB51.9020304@cosmosbay.com> <87ljvsott2.fsf@basil.nowhere.org>
In-Reply-To: <87ljvsott2.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 10 Nov 2008 10:01:20 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen a écrit :
> Eric Dumazet <dada1@cosmosbay.com> writes:
> 
>> diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
>> index 3f1b81a..716d26f 100644
>> --- a/arch/x86/oprofile/op_model_ppro.c
>> +++ b/arch/x86/oprofile/op_model_ppro.c
>> @@ -69,7 +69,7 @@ static void ppro_setup_ctrs(struct op_msrs const * const msrs)
>>  	int i;
>>  
>>  	if (!reset_value) {
>> -		reset_value = kmalloc(sizeof(unsigned) * num_counters,
>> +		reset_value = kmalloc(sizeof(reset_value[0]) * num_counters,
> 
> Thanks for tracking this down.
> 
> But that still doesn't explain why 2.6.27 fails too?

No :(

In fact 2.6.24 fails too. Oprofile never worked correctly.

Still investigating...

