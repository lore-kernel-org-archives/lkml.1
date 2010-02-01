Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab0BAQWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 11:22:49 -0500
Received: from mail-bw0-f223.google.com ([209.85.218.223]:34707 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab0BAQWr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 11:22:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=f+7iX1afqkyl8JE9dVLxLoKHSv1Mp7VcVtTvP8fGrWLevd4zFKMaQxtvE658tmkA+x
         MGH/9pVa3wAN4KjWuJE4aPSHncBj0TU8Y5TC4bnqr/99qDQUK7/2ebAZj30FAxixCPHA
         inGASM8cnd79hpq7fbeVWYJ1KWVWRutsVAyQY=
MIME-Version: 1.0
In-Reply-To: <201002011209.13540.rusty@rustcorp.com.au>
References: <817ecb6f1001311522q52bf4eebmb748c486dcd5ad35@mail.gmail.com>
	 <201002011209.13540.rusty@rustcorp.com.au>
Date: Mon, 1 Feb 2010 11:22:45 -0500
Message-ID: <817ecb6f1002010822j769ccda6wfc39c0dbd42420cd@mail.gmail.com>
Subject: Re: [PATCH v8] RO/NX protection for loadable kernel modules
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-next@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Needs more brackets around arguments, otherwise someone calling it with
> a complex expression will get very upset.
[...]

Done.

> The core_text_size test should be enough here.

Done.

>> +                     begin_pfn = PFN_DOWN((unsigned long)mod->module_core);
>> +                     end_pfn = PFN_DOWN((unsigned long)mod->module_core +
>> +                                             mod->core_text_size);
>> +                     if (end_pfn > begin_pfn)
>> +                             set_memory_rw(begin_pfn << PAGE_SHIFT,
>> +                                                     end_pfn - begin_pfn);
>
> Much of this code might be neater if you created a helper:

Done.

> But these are minor: patch looks good!

Thanks for your feedback!
