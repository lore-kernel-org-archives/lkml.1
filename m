Return-Path: <linux-kernel-owner+w=401wt.eu-S1758549AbZABRY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549AbZABRY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 12:24:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757047AbZABRYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 12:24:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34977 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757029AbZABRYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 12:24:49 -0500
Date: Fri, 2 Jan 2009 18:24:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@infradead.org>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: nmi.c fix style problems
Message-ID: <20090102172439.GD6759@elte.hu>
References: <1230725102.3738.10.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230725102.3738.10.camel@jaswinder.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@infradead.org> wrote:

> Impact: cleanup, fix style problems
> 
> Fixes style problems:
> WARNING: Use #include <linux/smp.h> instead of <asm/smp.h>
> WARNING: Use #include <linux/nmi.h> instead of <asm/nmi.h>
> 
> total: 0 errors, 2 warnings
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/kernel/nmi.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
> index 8bd1bf9..45a09cc 100644
> --- a/arch/x86/kernel/nmi.c
> +++ b/arch/x86/kernel/nmi.c
> @@ -26,11 +26,10 @@
>  #include <linux/kernel_stat.h>
>  #include <linux/kdebug.h>
>  #include <linux/smp.h>
> +#include <linux/nmi.h>
>  
>  #include <asm/i8259.h>
>  #include <asm/io_apic.h>
> -#include <asm/smp.h>
> -#include <asm/nmi.h>
>  #include <asm/proto.h>
>  #include <asm/timer.h>

does this build fine on UP + IOAPIC ? asm/smp.h has some side-effects that 
brings in certain APIC definitions.

	Ingo
