Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbYHLXUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbYHLXUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 19:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbYHLXUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 19:20:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51762 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752113AbYHLXU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 19:20:29 -0400
Date: Tue, 12 Aug 2008 16:20:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@suse.cz>
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, trivial@kernel.org
Subject: Re: acpi: trivial cleanups
Message-Id: <20080812162013.b139035b.akpm@linux-foundation.org>
In-Reply-To: <20080812102434.GA2676@elf.ucw.cz>
References: <20080812102434.GA2676@elf.ucw.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2008 12:24:34 +0200
Pavel Machek <pavel@suse.cz> wrote:

> 
> Trivial cleanups for ACPI. Fix misspelling in printk(), fix mismerge,
> add file header.
> 
>
> --- a/drivers/acpi/processor_core.c
> +++ b/drivers/acpi/processor_core.c
> @@ -123,7 +123,7 @@ struct acpi_processor_errata errata __re
>  static int set_no_mwait(const struct dmi_system_id *id)
>  {
>  	printk(KERN_NOTICE PREFIX "%s detected - "
> -		"disable mwait for CPU C-stetes\n", id->ident);
> +		"disabling mwait for CPU C-states\n", id->ident);
>  	idle_nomwait = 1;
>  	return 0;

OK

> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> index 283c08f..cf5b1b7 100644
> --- a/drivers/acpi/processor_idle.c
> +++ b/drivers/acpi/processor_idle.c
> @@ -41,7 +41,6 @@ #include <linux/sched.h>	/* need_resched
>  #include <linux/pm_qos_params.h>
>  #include <linux/clockchips.h>
>  #include <linux/cpuidle.h>
> -#include <linux/cpuidle.h>

OK

>  /*
>   * Include the apic definitions for x86 to have the APIC timer related defines
> diff --git a/drivers/acpi/reboot.c b/drivers/acpi/reboot.c
> index a6b662c..b4d9cb3 100644
> --- a/drivers/acpi/reboot.c
> +++ b/drivers/acpi/reboot.c
> @@ -1,4 +1,8 @@
> -
> +/*
> + * Reset the machine using the RESET_REG
> + *
> + * Distribute under GPL.
> + */

That was a trivial dirtyup.  Should at least be "Distributed under the
GPL" but I suspect that the policy in drivers/acpi/ is to add fancier
copyright text than this.


