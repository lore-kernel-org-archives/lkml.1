Return-Path: <linux-kernel-owner+w=401wt.eu-S1764822AbZDHSfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764822AbZDHSfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 14:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757913AbZDHSfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 14:35:20 -0400
Received: from gw.goop.org ([64.81.55.164]:46902 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757423AbZDHSfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 14:35:18 -0400
Message-ID: <49DCEE63.2010103@goop.org>
Date: Wed, 08 Apr 2009 11:35:15 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: mingo@elte.hu, akpm@linux-foundation.org, x86@kernel.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       nickpiggin@yahoo.com.au, tglx@linutronix.de, ysato@users.sourceforge.jp
Subject: Re: [PATCH] FRV: Use <asm-generic/pgtable.h> in NOMMU mode
References: <21081.1239214221@redhat.com> <20090408183011.24150.43310.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090408183011.24150.43310.stgit@warthog.procyon.org.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> asm-frv/pgtable.h could just #include <asm-generic/pgtable.h> in NOMMU mode
> rather than #defining macros for lazy MMU and CPU stuff.
>   

OK, thanks.  Do you mind this patch going via tip.git?

    J
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
>
>  include/asm-frv/pgtable.h |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
>
>
> diff --git a/include/asm-frv/pgtable.h b/include/asm-frv/pgtable.h
> index e16fdb1..3323301 100644
> --- a/include/asm-frv/pgtable.h
> +++ b/include/asm-frv/pgtable.h
> @@ -71,10 +71,8 @@ static inline int pte_file(pte_t pte) { return 0; }
>  #define swapper_pg_dir		((pgd_t *) NULL)
>  
>  #define pgtable_cache_init()		do {} while (0)
> -#define arch_enter_lazy_mmu_mode()	do {} while (0)
> -#define arch_leave_lazy_mmu_mode()	do {} while (0)
> -#define arch_enter_lazy_cpu_mode()	do {} while (0)
> -#define arch_leave_lazy_cpu_mode()	do {} while (0)
> +
> +#include <asm-generic/pgtable.h>
>  
>  #else /* !CONFIG_MMU */
>  /*****************************************************************************/
>
>   

