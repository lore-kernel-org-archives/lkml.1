Return-Path: <linux-kernel-owner+w=401wt.eu-S1757094AbZJaKXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094AbZJaKXA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 06:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314AbZJaKXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 06:23:00 -0400
Received: from mail-vw0-f192.google.com ([209.85.212.192]:65113 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbZJaKW7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 06:22:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=YmXWDUgfqbHm8Cy6a97DGQcsG7CguuscQF2lj/N2ru9wP018gWL6MkNok+wV4ktJ5G
         Q4l/a5wjD7ruWWPyonQNuL1neh6MxML5TYsWwdTo2aOw7BTKtDl8IxMR3b+Yw3meRs1T
         zmW8tQdbrrpKayxvb9e8mrpxJUZh0ftU4HBo0=
MIME-Version: 1.0
In-Reply-To: <4AEC0EBE.2040308@crca.org.au>
References: <b8bf37780910310240u4aecdf89hb938df7952b572e@mail.gmail.com> 
	<4AEC0EBE.2040308@crca.org.au>
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Sat, 31 Oct 2009 08:22:44 -0200
Message-ID: <b8bf37780910310322h32fd4b4anb5424dd22099c1f4@mail.gmail.com>
Subject: Re: [PATCH 03/16] trivial: fix assorted "through" typos
To: Nigel Cunningham <ncunningham@crca.org.au>
Cc: trivial@kernel.org, linux list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 31, 2009 at 8:17 AM, Nigel Cunningham
<ncunningham@crca.org.au> wrote:
> I've only looked at this one, but something caught my eye...
>
> André Goddard Rosa wrote:
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
>>       d_cache |= CPLB_L1_AOW | CPLB_WT;
>>  #endif
>>  #endif
>
> "Surely that can't be the only time?", I thought. But it is - all of the
> other #ifdefs are spelled correctly, so you're probably fixing a
> hard-to-find bug here! Good catch!

Good, that's why I made it a separate patch.

> Makes me wonder if anyone's written a tool to find things like this -
> #ifdefs that will never be defined...

Yeah, I thought the same thing; surely it would be nice...
Probably it's not only the one case, I suppose.

With regards,
André
