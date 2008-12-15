Return-Path: <linux-kernel-owner+w=401wt.eu-S1755866AbYLOTxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbYLOTxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 14:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbYLOTxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 14:53:24 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:7815 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbYLOTxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 14:53:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=YQGmlf7t2dC0qR7GZh5jLp1a+G86XvBZz8gFHCsp9SVrb6VlubSt1y51ssqbgLpc5u
         4xRuwHEIHd0ZrXA8kLNGCuTdXOMRl8PUdvaODIsFjQEZLcK3kbfMSeqvTzWVDxLC05Zx
         VHwoO8/womEo7ANpc3PM9SJAgYdB7/9KP6uyc=
Message-ID: <86802c440812151153l25a2351ds5e0a8a648262759d@mail.gmail.com>
Date: Mon, 15 Dec 2008 11:53:22 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Jaswinder Singh" <jaswinder@infradead.org>
Subject: Re: [PATCH] x86: irqinit_64.c declare init_ISA_irqs before they get used
Cc: "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1229362945.15326.16.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1229362945.15326.16.camel@jaswinder.satnam>
X-Google-Sender-Auth: 0ef1ad2e8ca330e3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2008 at 9:42 AM, Jaswinder Singh
<jaswinder@infradead.org> wrote:
> Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
>
> Included asm/arch_hooks.h for init_ISA_irqs
> ---
>  arch/x86/kernel/irqinit_64.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
> index b33d02f..d1f9663 100644
> --- a/arch/x86/kernel/irqinit_64.c
> +++ b/arch/x86/kernel/irqinit_64.c
> @@ -21,6 +21,7 @@
>  #include <asm/delay.h>
>  #include <asm/desc.h>
>  #include <asm/apic.h>
> +#include <asm/arch_hooks.h>
>  #include <asm/i8259.h>


not needed.

could change that to static for 64bit.

YH
