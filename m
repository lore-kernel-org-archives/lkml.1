Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbYA0BD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbYA0BD1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 20:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbYA0BDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 20:03:20 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:30243 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbYA0BDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 20:03:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=joEGS+J2OLDAG62Ok+OiLVYy2HNKiImryNoi6jJ3teEWp1FTy8Wew3MkD3va34GUs1m2quuE+lrywYkRa4jAmGbTj6Knm40hkObowJZe793qwTZnc9xibQFJSfY6hOorpGfhRcihXcV17qIjvixo5P04Xfx0UlFKqJayLY6b6HQ=
Message-ID: <86802c440801261703k22b6a51ft6254690f3b211efb@mail.gmail.com>
Date: Sat, 26 Jan 2008 17:03:18 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ian Campbell" <ijc@hellion.org.uk>
Subject: Re: [PATCH 5/9] x86: Unify strings in arch/x86/boot/compressed/misc_??.c
Cc: linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <25c98f11d5811cdee328b2e6c400a36c875bc9b8.1201348185.git.ijc@hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ff184a8ea93f18a787bb9bd0c860036219b83ee0.1201348185.git.ijc@hellion.org.uk>
	 <25c98f11d5811cdee328b2e6c400a36c875bc9b8.1201348185.git.ijc@hellion.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 26, 2008 3:54 AM, Ian Campbell <ijc@hellion.org.uk> wrote:
> It seems pretty arbitrary which version survives, so I chose the 32
> bit version.
>
> Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> ---
>  arch/x86/boot/compressed/misc_64.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/boot/compressed/misc_64.c b/arch/x86/boot/compressed/misc_64.c
> index 8c1573b..bd822b7 100644
> --- a/arch/x86/boot/compressed/misc_64.c
> +++ b/arch/x86/boot/compressed/misc_64.c
> @@ -372,8 +372,8 @@ asmlinkage void decompress_kernel(void *rmode, unsigned long heap,
>                 error("Destination address too large");
>
>         makecrc();
> -       putstr(".\nDecompressing Linux...");
> +       putstr("Uncompressing Linux... ");
>         gunzip();
> -       putstr("done.\nBooting the kernel.\n");
> +       putstr("Ok, booting the kernel.\n");
>         return;
>  }

64 bit old print out seem more clear. again can you change that in misc_32.c

YH
