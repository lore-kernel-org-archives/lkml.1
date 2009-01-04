Return-Path: <linux-kernel-owner+w=401wt.eu-S1758077AbZADRRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077AbZADRRY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 12:17:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754513AbZADRRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 12:17:16 -0500
Received: from rv-out-0506.google.com ([209.85.198.230]:25642 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429AbZADRRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 12:17:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=E5Vqzm7142E28nqWUq73Bsz+IqzMZJ1HlpqZ68sXsV4VtTCqz3MzGnWxmcfu9UE6Dh
         9btLXuX3tHLcnlSNsC9qZKi4tTzduQje+7bPkzZrI+32tLLQ7rwX8nx0ta5eaPEGMlaQ
         rsxlgc1JaSUcw3+r+tdKlz72X+u3ja5b2BAxI=
Message-ID: <3f9a31f40901040917i52df1ef5i7d86ddee05d4d0b1@mail.gmail.com>
Date: Sun, 4 Jan 2009 22:47:13 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: mpparse.c fix style problems
Cc: "Jaswinder Singh Rajput" <jaswinder@infradead.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "x86 maintainers" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090102172150.GC6759@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1230723533.3738.8.camel@jaswinder.satnam>
	 <20090102172150.GC6759@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

On Fri, Jan 2, 2009 at 10:51 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> i think it would be cleaner to rename all the the mpc->mpc_X fields to
> mpc->X - that alone would give 4 characters per usage site. (we already
> know that it's an 'mpc' entity - no need to duplicate that in the field
> too)
>

I send [PATCH -tip 0/7] x86 rename all fields mpc_X to X based on this.

Currently I rename fields of few mpc_X structures from
arch/x86/include/asm/mpspec_def.h. In this file struct
intel_mp_floating is still remaining with mpf_X fields, Is this also
need to be fixed ? if yes then mpf_intel name is OK ?

Similarly in arch/x86/include/asm/io_apic.h :
1. struct mp_config_ioapic with mp_X fields (what name will be best ?)
2. struct mp_config_intsrc with mp_X fields

These are also used in arch/x86/kernel/mpparse.c

Please let me know should I fix mp_X things first or should I proceed
further in mpparse.c as per your suggestions.

Thank you,
JSR
