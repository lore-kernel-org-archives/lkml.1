Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbYKDUMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbYKDUMF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 15:12:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753740AbYKDULz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 15:11:55 -0500
Received: from rv-out-0506.google.com ([209.85.198.239]:27817 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679AbYKDULz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 15:11:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=eN+fkIK/hminU0qFE8lkGOgVlIaZIDPJ7pww/CzVYame9InpPideHJSucMUnWkzcya
         X8jpYZcg8x2Ej45qHMHkT+mBwr53yD0BHvS3zhNrLA5t6CK1dDRxdMnp2KWH/2JDHtwz
         d/sgu4LQY7it3Jqn8NvdPn98a1uWo1tAjZxSY=
Message-ID: <84144f020811041211l71b56d40u1aa909d867bc4445@mail.gmail.com>
Date: Tue, 4 Nov 2008 22:11:54 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] change CONFIG_NUMA description
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081105022553.7CB2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081105022553.7CB2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Google-Sender-Auth: 699576c1ecaed4d8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2008 at 7:27 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> CONFIG_NUMA description talk about a bit old thing.
> So, following changes are better.
>
> o CONFIG_NUMA is no longer EXPERIMENTAL
> Index: b/arch/x86/Kconfig
> ===================================================================
> --- a/arch/x86/Kconfig  2008-11-05 01:11:24.000000000 +0900
> +++ b/arch/x86/Kconfig  2008-11-05 02:09:38.000000000 +0900
> @@ -951,7 +951,7 @@ config ARCH_PHYS_ADDR_T_64BIT
>
>  # Common NUMA Features
>  config NUMA
> -       bool "Numa Memory Allocation and Scheduler Support (EXPERIMENTAL)"
> +       bool "Numa Memory Allocation and Scheduler Support"
>        depends on SMP
>        depends on X86_64 || (X86_32 && HIGHMEM64G && (X86_NUMAQ || X86_BIGSMP || X86_SUMMIT && ACPI) && EXPERIMENTAL)

You might want to remove the dependency to CONFIG_EXPERIMENTAL as well.

>        default n if X86_PC
> @@ -964,9 +964,8 @@ config NUMA
>
>          For 32-bit this is currently highly experimental and should be only
>          used for kernel development. It might also cause boot failures.
> -         For 64-bit this is recommended on all multiprocessor Opteron systems.
> -         If the system is EM64T, you should say N unless your system is
> -         EM64T NUMA.
> +         For 64-bit this is recommended if the system is Intel Core 7i or later or AMD Opteron.
> +         Otherwise, you should say N unless your system is EM64T NUMA.
>
>  comment "NUMA (Summit) requires SMP, 64GB highmem support, ACPI"
>        depends on X86_32 && X86_SUMMIT && (!HIGHMEM64G || !ACPI)
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
