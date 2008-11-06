Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbYKFKPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbYKFKPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 05:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbYKFKPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 05:15:08 -0500
Received: from rv-out-0506.google.com ([209.85.198.237]:29415 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbYKFKPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 05:15:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Iuzi2PasSRC/idijaSUdUta7LuOWuOsUlcenxEOfDj9EHEYRJf9R4lkv14FURMv3ln
         OrVGYfzELkNTtGLE/UPYY/Iy+ZDBE7ob6zfziYTCiAXUhyB+pA+wLCelpfUWwg57bmvl
         9tBzlcT/TWBjFuK+Ix2YCkXo7J4BKAxSdTe7k=
Message-ID: <84144f020811060215n25bf1e3ah5ad17e664b146764@mail.gmail.com>
Date: Thu, 6 Nov 2008 12:15:06 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] change CONFIG_NUMA description
Cc: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "the arch/x86 maintainers" <x86@kernel.org>
In-Reply-To: <20081106085301.GB4890@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081105022553.7CB2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20081106085301.GB4890@elte.hu>
X-Google-Sender-Auth: 19639acc9788dfe9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Thu, Nov 6, 2008 at 10:53 AM, Ingo Molnar <mingo@elte.hu> wrote:
> From fd51b2d7d5df932767b89e00d0871a38a2c53e74 Mon Sep 17 00:00:00 2001
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Date: Wed, 5 Nov 2008 02:27:19 +0900
> Subject: [PATCH] x86: update CONFIG_NUMA description
>
> Impact: clarify/update CONFIG_NUMA text
>
> CONFIG_NUMA description talk about a bit old thing.
> So, following changes are better.
>
>  o CONFIG_NUMA is no longer EXPERIMENTAL
>
>  o Opteron is not the only processor of NUMA topology on x86_64 no longer,
>   but also Intel Core7i has it.
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/Kconfig |   16 ++++++++++------
>  1 files changed, 10 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 350bee1..38ae04b 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -951,22 +951,26 @@ config ARCH_PHYS_ADDR_T_64BIT
>
>  # Common NUMA Features
>  config NUMA
> -       bool "Numa Memory Allocation and Scheduler Support (EXPERIMENTAL)"
> +       bool "Numa Memory Allocation and Scheduler Support"
>        depends on SMP
>        depends on X86_64 || (X86_32 && HIGHMEM64G && (X86_NUMAQ || X86_BIGSMP || X86_SUMMIT && ACPI) && EXPERIMENTAL)

Why does this depend on CONFIG_EXPERIMENTAL still?

>        default n if X86_PC
>        default y if (X86_NUMAQ || X86_SUMMIT || X86_BIGSMP)
>        help
>          Enable NUMA (Non Uniform Memory Access) support.
> +
>          The kernel will try to allocate memory used by a CPU on the
>          local memory controller of the CPU and add some more
>          NUMA awareness to the kernel.
>
