Return-Path: <linux-kernel-owner+w=401wt.eu-S1755738AbZKBQQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738AbZKBQQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:16:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755628AbZKBQQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:16:50 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:47147 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461AbZKBQQt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:16:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Gvn/oyxQOwCmtsNnDkCrp/CEzRnas3qkV2VVzfxHqOGBOTBzTSxqrP+qQrrw2xU29s
         8iW1E4cAIgVlC2pqvahg5l1k3IxpTpDuzCAbyLHcYFgkjpPBuz3ykaXe4r6cTFGKZwFR
         eQKsy+bkceJYUpszTg/r1bN/pU69BmxgvF/h0=
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.0911021658110.4203@wotan.suse.de>
References: <b8bf37780910310240u4aecdf89hb938df7952b572e@mail.gmail.com> 
	<alpine.LSU.2.00.0911021658110.4203@wotan.suse.de>
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Mon, 2 Nov 2009 14:16:32 -0200
Message-ID: <b8bf37780911020816r2cc4392cnb48645b09d15c0d2@mail.gmail.com>
Subject: Re: [PATCH 03/16] trivial: fix assorted "through" typos
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jiri!

On Mon, Nov 2, 2009 at 2:00 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Sat, 31 Oct 2009, André Goddard Rosa wrote:
>
>> diff --git a/arch/blackfin/kernel/cplb-mpu/cplbinit.c
>> b/arch/blackfin/kernel/cplb-mpu/cplbinit.c
>> index f7b9cdc..b52c1f8 100644
>> --- a/arch/blackfin/kernel/cplb-mpu/cplbinit.c
>> +++ b/arch/blackfin/kernel/cplb-mpu/cplbinit.c
>> @@ -38,7 +38,7 @@ void __init generate_cplb_tables_cpu(unsigned int cpu)
>>
>>  #ifdef CONFIG_BFIN_EXTMEM_DCACHEABLE
>>       d_cache = CPLB_L1_CHBL;
>> -#ifdef CONFIG_BFIN_EXTMEM_WRITETROUGH
>> +#ifdef CONFIG_BFIN_EXTMEM_WRITETHROUGH
>
> As this one is fixing a *real* bug, please separate it out from the other
> changes which basically just fix typos in comments.

Already done and taken care here:
http://marc.info/?l=linux-kernel&m=125701706006147&w=2

> On the other hand, please merge all the other changes together into one
> larger patch. We don't want gazillions of commits because you have found
> gazillions of words typed wrongly in comments.
>
> Thanks for taking care,

Sure thing, I will send a consolidated patch with these.

Thank you,
André
