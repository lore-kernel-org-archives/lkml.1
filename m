Return-Path: <linux-kernel-owner+w=401wt.eu-S965707AbXG2W74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965707AbXG2W74 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 18:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750843AbXG2W7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 18:59:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:54889 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbXG2W7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 18:59:46 -0400
Subject: Re: [PATCH] powerpc: clean out a bunch of duplicate includes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Engebretsen <engebret@us.ibm.com>,
       Peter Bergner <bergner@us.ibm.com>, Mike Corrigan <mikec@us.ibm.com>,
       Olof Johansson <olof@lixom.net>, Cort Dougan <cort@cs.nmt.edu>,
       Dan Malek <dmalek@jlc.net>, Mike Corrigan <mikejc@us.ibm.com>,
       Gabriel Paubert <paubert@iram.es>, Anton Blanchard <anton@au.ibm.com>,
       Rohit Seth <rohit.seth@intel.com>, Gary Thomas <gdt@linuxppc.org>,
       Paul Mackerras <paulus@cs.anu.edu.au>, Matt Porter <mporter@mvista.com>,
       Sylvain Munaut <tnt@246tnt.com>,
       Dale Farnsworth <dfarnsworth@mvista.com>,
       Grant Erickson <grant@lcse.umn.edu>, Dan Malek <dan@net4x.com>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200707300018.26324.jesper.juhl@gmail.com>
References: <200707300018.26324.jesper.juhl@gmail.com>
Content-Type: text/plain
Date: Mon, 30 Jul 2007 08:58:43 +1000
Message-Id: <1185749924.5495.371.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-30 at 00:18 +0200, Jesper Juhl wrote:
> Hi,
> 
> Here's a patch to clean out a bunch of duplicate includes from 
> arch/powerpc/
> 
> Please consider for inclusion.

Ah.. historical stuff stacking up :-)

> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> ---
> 
>  arch/powerpc/kernel/btext.c                |    1 -
>  arch/powerpc/kernel/crash.c                |    1 -
>  arch/powerpc/kernel/iommu.c                |    1 -
>  arch/powerpc/kernel/prom.c                 |    1 -
>  arch/powerpc/kernel/time.c                 |    1 -
>  arch/powerpc/mm/hash_utils_64.c            |    1 -
>  arch/powerpc/mm/hugetlbpage.c              |    3 ---
>  arch/powerpc/mm/init_32.c                  |    1 -
>  arch/powerpc/mm/mem.c                      |    1 -
>  arch/powerpc/platforms/52xx/mpc52xx_pic.c  |    1 -
>  arch/powerpc/platforms/chrp/setup.c        |    1 -
>  arch/powerpc/platforms/chrp/smp.c          |    1 -
>  arch/powerpc/platforms/iseries/setup.c     |    1 -
>  arch/powerpc/platforms/powermac/low_i2c.c  |    1 -
>  arch/powerpc/platforms/powermac/udbg_adb.c |    1 -
>  arch/powerpc/platforms/pseries/lpar.c      |    1 -
>  16 files changed, 0 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/btext.c b/arch/powerpc/kernel/btext.c
> index e7b6846..3ef51fb 100644
> --- a/arch/powerpc/kernel/btext.c
> +++ b/arch/powerpc/kernel/btext.c
> @@ -11,7 +11,6 @@
>  #include <asm/sections.h>
>  #include <asm/prom.h>
>  #include <asm/btext.h>
> -#include <asm/prom.h>
>  #include <asm/page.h>
>  #include <asm/mmu.h>
>  #include <asm/pgtable.h>
> diff --git a/arch/powerpc/kernel/crash.c b/arch/powerpc/kernel/crash.c
> index 37658ea..77c749a 100644
> --- a/arch/powerpc/kernel/crash.c
> +++ b/arch/powerpc/kernel/crash.c
> @@ -24,7 +24,6 @@
>  #include <linux/init.h>
>  #include <linux/irq.h>
>  #include <linux/types.h>
> -#include <linux/irq.h>
>  
>  #include <asm/processor.h>
>  #include <asm/machdep.h>
> diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
> index c08ceca..e4ec6ee 100644
> --- a/arch/powerpc/kernel/iommu.c
> +++ b/arch/powerpc/kernel/iommu.c
> @@ -30,7 +30,6 @@
>  #include <linux/spinlock.h>
>  #include <linux/string.h>
>  #include <linux/dma-mapping.h>
> -#include <linux/init.h>
>  #include <linux/bitops.h>
>  #include <asm/io.h>
>  #include <asm/prom.h>
> diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
> index a38197b..0028fe6 100644
> --- a/arch/powerpc/kernel/prom.c
> +++ b/arch/powerpc/kernel/prom.c
> @@ -52,7 +52,6 @@
>  #include <asm/pSeries_reconfig.h>
>  #include <asm/pci-bridge.h>
>  #include <asm/kexec.h>
> -#include <asm/system.h>
>  
>  #ifdef DEBUG
>  #define DBG(fmt...) printk(KERN_ERR fmt)
> diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
> index 727a669..c85d9b0 100644
> --- a/arch/powerpc/kernel/time.c
> +++ b/arch/powerpc/kernel/time.c
> @@ -72,7 +72,6 @@
>  #include <asm/iseries/it_lp_queue.h>
>  #include <asm/iseries/hv_call_xm.h>
>  #endif
> -#include <asm/smp.h>
>  
>  /* keep track of when we need to update the rtc */
>  time_t last_rtc_update;
> diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_64.c
> index bc7b0ce..c2bf404 100644
> --- a/arch/powerpc/mm/hash_utils_64.c
> +++ b/arch/powerpc/mm/hash_utils_64.c
> @@ -49,7 +49,6 @@
>  #include <asm/tlb.h>
>  #include <asm/cacheflush.h>
>  #include <asm/cputable.h>
> -#include <asm/abs_addr.h>
>  #include <asm/sections.h>
>  #include <asm/spu.h>
>  
> diff --git a/arch/powerpc/mm/hugetlbpage.c b/arch/powerpc/mm/hugetlbpage.c
> index 4835f73..ba5f12a 100644
> --- a/arch/powerpc/mm/hugetlbpage.c
> +++ b/arch/powerpc/mm/hugetlbpage.c
> @@ -22,11 +22,8 @@
>  #include <asm/mmu_context.h>
>  #include <asm/machdep.h>
>  #include <asm/cputable.h>
> -#include <asm/tlb.h>
>  #include <asm/spu.h>
>  
> -#include <linux/sysctl.h>
> -
>  #define NUM_LOW_AREAS	(0x100000000UL >> SID_SHIFT)
>  #define NUM_HIGH_AREAS	(PGTABLE_RANGE >> HTLB_AREA_SHIFT)
>  
> diff --git a/arch/powerpc/mm/init_32.c b/arch/powerpc/mm/init_32.c
> index e1f5ded..d65995a 100644
> --- a/arch/powerpc/mm/init_32.c
> +++ b/arch/powerpc/mm/init_32.c
> @@ -41,7 +41,6 @@
>  #include <asm/machdep.h>
>  #include <asm/btext.h>
>  #include <asm/tlb.h>
> -#include <asm/prom.h>
>  #include <asm/lmb.h>
>  #include <asm/sections.h>
>  
> diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
> index f0e7eed..32dcfc9 100644
> --- a/arch/powerpc/mm/mem.c
> +++ b/arch/powerpc/mm/mem.c
> @@ -42,7 +42,6 @@
>  #include <asm/machdep.h>
>  #include <asm/btext.h>
>  #include <asm/tlb.h>
> -#include <asm/prom.h>
>  #include <asm/lmb.h>
>  #include <asm/sections.h>
>  #include <asm/vdso.h>
> diff --git a/arch/powerpc/platforms/52xx/mpc52xx_pic.c b/arch/powerpc/platforms/52xx/mpc52xx_pic.c
> index fbfff95..8c464c5 100644
> --- a/arch/powerpc/platforms/52xx/mpc52xx_pic.c
> +++ b/arch/powerpc/platforms/52xx/mpc52xx_pic.c
> @@ -22,7 +22,6 @@
>  #include <linux/init.h>
>  #include <linux/sched.h>
>  #include <linux/signal.h>
> -#include <linux/stddef.h>
>  #include <linux/delay.h>
>  #include <linux/irq.h>
>  #include <linux/hardirq.h>
> diff --git a/arch/powerpc/platforms/chrp/setup.c b/arch/powerpc/platforms/chrp/setup.c
> index 373de4c..dde5ef4 100644
> --- a/arch/powerpc/platforms/chrp/setup.c
> +++ b/arch/powerpc/platforms/chrp/setup.c
> @@ -32,7 +32,6 @@
>  #include <linux/seq_file.h>
>  #include <linux/root_dev.h>
>  #include <linux/initrd.h>
> -#include <linux/module.h>
>  #include <linux/timer.h>
>  
>  #include <asm/io.h>
> diff --git a/arch/powerpc/platforms/chrp/smp.c b/arch/powerpc/platforms/chrp/smp.c
> index 3ea0eb7..a137d13 100644
> --- a/arch/powerpc/platforms/chrp/smp.c
> +++ b/arch/powerpc/platforms/chrp/smp.c
> @@ -29,7 +29,6 @@
>  #include <asm/residual.h>
>  #include <asm/time.h>
>  #include <asm/machdep.h>
> -#include <asm/smp.h>
>  #include <asm/mpic.h>
>  #include <asm/rtas.h>
>  
> diff --git a/arch/powerpc/platforms/iseries/setup.c b/arch/powerpc/platforms/iseries/setup.c
> index 13a8b19..fad493e 100644
> --- a/arch/powerpc/platforms/iseries/setup.c
> +++ b/arch/powerpc/platforms/iseries/setup.c
> @@ -41,7 +41,6 @@
>  #include <asm/time.h>
>  #include <asm/paca.h>
>  #include <asm/cache.h>
> -#include <asm/sections.h>
>  #include <asm/abs_addr.h>
>  #include <asm/iseries/hv_lp_config.h>
>  #include <asm/iseries/hv_call_event.h>
> diff --git a/arch/powerpc/platforms/powermac/low_i2c.c b/arch/powerpc/platforms/powermac/low_i2c.c
> index efdf5eb..da2007e 100644
> --- a/arch/powerpc/platforms/powermac/low_i2c.c
> +++ b/arch/powerpc/platforms/powermac/low_i2c.c
> @@ -40,7 +40,6 @@
>  #include <linux/completion.h>
>  #include <linux/platform_device.h>
>  #include <linux/interrupt.h>
> -#include <linux/completion.h>
>  #include <linux/timer.h>
>  #include <linux/mutex.h>
>  #include <asm/keylargo.h>
> diff --git a/arch/powerpc/platforms/powermac/udbg_adb.c b/arch/powerpc/platforms/powermac/udbg_adb.c
> index 6124e59..b1882e4 100644
> --- a/arch/powerpc/platforms/powermac/udbg_adb.c
> +++ b/arch/powerpc/platforms/powermac/udbg_adb.c
> @@ -12,7 +12,6 @@
>  #include <asm/xmon.h>
>  #include <asm/prom.h>
>  #include <asm/bootx.h>
> -#include <asm/machdep.h>
>  #include <asm/errno.h>
>  #include <asm/pmac_feature.h>
>  #include <asm/processor.h>
> diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
> index 8cc6eee..ea327ca 100644
> --- a/arch/powerpc/platforms/pseries/lpar.c
> +++ b/arch/powerpc/platforms/pseries/lpar.c
> @@ -35,7 +35,6 @@
>  #include <asm/tlbflush.h>
>  #include <asm/tlb.h>
>  #include <asm/prom.h>
> -#include <asm/abs_addr.h>
>  #include <asm/cputable.h>
>  #include <asm/udbg.h>
>  #include <asm/smp.h>
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

