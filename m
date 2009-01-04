Return-Path: <linux-kernel-owner+w=401wt.eu-S1759328AbZADRei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759328AbZADRei (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 12:34:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755984AbZADReb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 12:34:31 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:62836 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968AbZADRea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 12:34:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tSSAIYW1ZBsLNGjxLrc4lyOOe2ODq6Vid1LGhJFKG+hiTeLQHFmQB9uMpIHrBnkxfQ
         vqEQB4xJ7Ua3lnrXmF2OAjxEIQaQbMpWJ9FVhr008LsakpFpenwxoaYCVj+LHy40wuUb
         TX9yX2Q/z5zsBonFdDZwnUfjrzFiLNqfdKy9c=
Message-ID: <3f9a31f40901040934g5f48a2e0q332180ace15bedfe@mail.gmail.com>
Date: Sun, 4 Jan 2009 23:04:28 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: mpparse.c fix style problems
Cc: "Jaswinder Singh Rajput" <jaswinder@infradead.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "x86 maintainers" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090104172319.GA1238@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1230723533.3738.8.camel@jaswinder.satnam>
	 <20090102172150.GC6759@elte.hu>
	 <3f9a31f40901040917i52df1ef5i7d86ddee05d4d0b1@mail.gmail.com>
	 <20090104172319.GA1238@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 4, 2009 at 10:53 PM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> Similarly in arch/x86/include/asm/io_apic.h :
>> 1. struct mp_config_ioapic with mp_X fields (what name will be best ?)
>> 2. struct mp_config_intsrc with mp_X fields
>>
>> These are also used in arch/x86/kernel/mpparse.c
>>
>> Please let me know should I fix mp_X things first or should I proceed
>> further in mpparse.c as per your suggestions.
>
> i think those should be standardized to mpc_X too, and the fields should
> lose their mp_ prefix.
>

Earlier we was having 2 sets :-

struct mpc_config_ioapic (mpspec) and mp_config_ioapic (ioapic)
struct mpc_config_intsrc (mpspec) and mp_config_intsrc (ioapic)

We moved struct mpc_config_X to struct mpc_X

I want to know what should be name for mp_config_ioapic. Is struct
mp_ioapic is OK ?

JSR
