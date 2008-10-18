Return-Path: <linux-kernel-owner+w=401wt.eu-S1752726AbYJRHnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbYJRHnk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 03:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbYJRHnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 03:43:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58089 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbYJRHnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 03:43:31 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       David Howells <dhowells@redhat.com>
Subject: Re: [announce] new tree: "fix all build warnings, on all configs"
From: Andi Kleen <andi@firstfloor.org>
References: <20081017171139.GA1792@elte.hu>
Date: Sat, 18 Oct 2008 09:43:29 +0200
In-Reply-To: <20081017171139.GA1792@elte.hu> (Ingo Molnar's message of "Fri, 17 Oct 2008 19:11:39 +0200")
Message-ID: <87r66ejqla.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
>  		if (battery->have_sysfs_alarm)
> diff --git a/drivers/acpi/sleep/main.c b/drivers/acpi/sleep/main.c
> index d13194a..2276d75 100644
> --- a/drivers/acpi/sleep/main.c
> +++ b/drivers/acpi/sleep/main.c
> @@ -63,7 +63,7 @@ void __init acpi_old_suspend_ordering(void)
>  /**
>   *	acpi_pm_disable_gpes - Disable the GPEs.
>   */
> -static int acpi_pm_disable_gpes(void)
> +static inline int acpi_pm_disable_gpes(void)

Just to satisfy my curiosity, what compiler warning does marking functions inline 
fix?

Thanks.

-Andi

-- 
ak@linux.intel.com
