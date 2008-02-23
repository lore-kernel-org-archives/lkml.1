Return-Path: <linux-kernel-owner+w=401wt.eu-S1762397AbYBWJrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762397AbYBWJrn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 04:47:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754772AbYBWJre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 04:47:34 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51149 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753640AbYBWJrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 04:47:33 -0500
Date: Sat, 23 Feb 2008 10:47:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Len Brown <lenb@kernel.org>
Cc: Rafael Wysocki <rjw@sisk.pl>, paolo.ciarrocchi@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: acpi_wakeup_address in .data vs .bss (Fwd: [PATCH 18/20] x86:
	Coding Style fixes to arch/x86/kernel/acpi/sleep.c)
Message-ID: <20080223094754.GB3081@elf.ucw.cz>
References: <200802230136.08926.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802230136.08926.lenb@kernel.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2008-02-23 01:36:08, Len Brown wrote:
> was there any particular reason we forced acpi_wakeup_address into .data
> instead of into .bss?

In my tree it is in .bss already... ...I think that was done during
"wakeup-to-.c" move.

So this patch is okay.

But you actually might want to drop this, preventing merge
conflict... 
									Pavel

> ----------  Forwarded Message  ----------
> 
> Subject: [PATCH 18/20] x86: Coding Style fixes to arch/x86/kernel/acpi/sleep.c
> Date: Friday 22 February 2008 17:11
> From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
> To: hpa <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>, tglx <tglx@linutronix.de>
> Cc: Linux Kernel <linux-kernel@vger.kernel.org>
> 
> File is now error free.
> Compile tested.
> 
> 
> Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
> ---
>  arch/x86/kernel/acpi/sleep.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
> index 6bc815c..dd78326 100644
> --- a/arch/x86/kernel/acpi/sleep.c
> +++ b/arch/x86/kernel/acpi/sleep.c
> @@ -13,7 +13,7 @@
>  #include <asm/smp.h>
>  
>  /* address in low memory of the wakeup routine. */
> -unsigned long acpi_wakeup_address = 0;
> +unsigned long acpi_wakeup_address;
>  unsigned long acpi_realmode_flags;
>  extern char wakeup_start, wakeup_end;
>  

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
