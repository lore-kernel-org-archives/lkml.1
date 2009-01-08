Return-Path: <linux-kernel-owner+w=401wt.eu-S1760259AbZAHOns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760259AbZAHOns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 09:43:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbZAHOnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 09:43:40 -0500
Received: from rv-out-0506.google.com ([209.85.198.233]:26133 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbZAHOnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 09:43:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=AoFKpKZsNi8gnlGcAD72taR1ofkRJSSvXfgszVti6z1OZiVY7E/OInSQtQEUNGCnWX
         1trZsGEd4Y0c80Xwj66/k0bmoN5Lu73sfX1c9Gk5WL2Hfz9nmusmU7P7yTJJ3ARjqzFA
         I/A/kT3YoYAI0BYpQZF945bpAcYDN+ouSHYPs=
Message-ID: <3f9a31f40901080643i4a355168gcdf12ea706c34e3b@mail.gmail.com>
Date: Thu, 8 Jan 2009 20:13:38 +0530
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

Hello Ingo,

On Sun, Jan 4, 2009 at 10:53 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:
>
>>
>> Currently I rename fields of few mpc_X structures from
>> arch/x86/include/asm/mpspec_def.h. In this file struct
>> intel_mp_floating is still remaining with mpf_X fields, Is this also
>> need to be fixed ? if yes then mpf_intel name is OK ?
>>

I send :
[PATCH -tip 1/2] x86: rename intel_mp_floating to mpf_intel
[PATCH -tip 2/2] x86: rename all fields of mpf_intel mpf_X to X

Is this OK ?

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

struct mpc_ioapic and struct mpc_intsrc is based on MultiProcessor
Specification Version 1.4

But I am not able to find the specification Manual of:

struct mp_config_ioapic and struct mp_config_intsrc.
(arch/x86/include/asm/io_apic.h)

Can you please point me out why the fields of struct mp_config_ioapic
and struct mp_config_intsrc are different from MultiProcessor
Specification Version 1.4

Thanks
--
JSR
