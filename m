Return-Path: <linux-kernel-owner+w=401wt.eu-S1760939AbXETCCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760939AbXETCCS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 22:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757876AbXETCCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 22:02:09 -0400
Received: from colo.lackof.org ([198.49.126.79]:44874 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756757AbXETCCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 22:02:07 -0400
X-Greylist: delayed 1927 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 May 2007 22:02:07 EDT
Date: Sat, 19 May 2007 19:29:50 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       parisc-linux@parisc-linux.org, trivial@kernel.org
Subject: Re: [parisc-linux] [PATCH] spelling fixes: arch/parisc/
Message-ID: <20070520012950.GA20195@colo.lackof.org>
References: <4644C72A.4000608@simon.arlott.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4644C72A.4000608@simon.arlott.org.uk>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2007 at 08:42:34PM +0100, Simon Arlott wrote:
> Spelling fixes in arch/parisc/.
> 
> Signed-off-by: Simon Arlott <simon@fire.lp0.eu>

Acked-by: Grant Grundler <grundler@parisc-linux.org>

thanks!
grant

> ---
> arch/parisc/kernel/firmware.c    |    4 ++--
> arch/parisc/kernel/perf.c        |   12 ++++++------
> arch/parisc/kernel/processor.c   |    8 ++++----
> arch/parisc/kernel/setup.c       |    2 +-
> arch/parisc/kernel/signal32.h    |    2 +-
> arch/parisc/kernel/smp.c         |    6 +++---
> arch/parisc/kernel/time.c        |    2 +-
> arch/parisc/kernel/traps.c       |    2 +-
> arch/parisc/math-emu/dbl_float.h |    4 ++--
> arch/parisc/math-emu/dfsqrt.c    |    2 +-
> arch/parisc/math-emu/sfsqrt.c    |    2 +-
> arch/parisc/math-emu/sgl_float.h |    4 ++--
> arch/parisc/mm/init.c            |   10 +++++-----
> 13 files changed, 30 insertions(+), 30 deletions(-)
> 
> diff --git a/arch/parisc/kernel/firmware.c b/arch/parisc/kernel/firmware.c
> index 39dc835..fd6552c 100644
> --- a/arch/parisc/kernel/firmware.c
> +++ b/arch/parisc/kernel/firmware.c
> @@ -634,7 +634,7 @@ EXPORT_SYMBOL(pdc_lan_station_id);
>  * pdc_stable_read - Read data from Stable Storage.
>  * @staddr: Stable Storage address to access.
>  * @memaddr: The memory address where Stable Storage data shall be copied.
> - * @count: number of bytes to transfert. count is multiple of 4.
> + * @count: number of bytes to transfer. count is multiple of 4.
>  *
>  * This PDC call reads from the Stable Storage address supplied in staddr
>  * and copies count bytes to the memory address memaddr.
> @@ -660,7 +660,7 @@ EXPORT_SYMBOL(pdc_stable_read);
>  * pdc_stable_write - Write data to Stable Storage.
>  * @staddr: Stable Storage address to access.
>  * @memaddr: The memory address where Stable Storage data shall be read 
>  from.
> - * @count: number of bytes to transfert. count is multiple of 4.
> + * @count: number of bytes to transfer. count is multiple of 4.
>  *
>  * This PDC call reads count bytes from the supplied memaddr address,
>  * and copies count bytes to the Stable Storage address staddr.
> diff --git a/arch/parisc/kernel/perf.c b/arch/parisc/kernel/perf.c
> index a46bc62..d324021 100644
> --- a/arch/parisc/kernel/perf.c
> +++ b/arch/parisc/kernel/perf.c
> @@ -171,7 +171,7 @@ static const uint64_t perf_bitmasks[] = {
> 
> /*
>  * Write control bitmasks for Pa-8700 processor given
> - * somethings have changed slightly.
> + * some things have changed slightly.
>  */
> static const uint64_t perf_bitmasks_piranha[] = {
> 	0x0000000000000000ul,     /* first dbl word must be zero */
> @@ -574,27 +574,27 @@ static int perf_stop_counters(uint32_t *raddr)
> 		if (!perf_rdr_read_ubuf(16, userbuf))
> 			return -13;
> 
> -		/* Counter0 is bits 1398 thru 1429 */
> +		/* Counter0 is bits 1398 to 1429 */
> 		tmp64 =  (userbuf[21] << 22) & 0x00000000ffc00000;
> 		tmp64 |= (userbuf[22] >> 42) & 0x00000000003fffff;
> 		/* OR sticky0 (bit 1430) to counter0 bit 32 */
> 		tmp64 |= (userbuf[22] >> 10) & 0x0000000080000000;
> 		raddr[0] = (uint32_t)tmp64;
> 
> -		/* Counter1 is bits 1431 thru 1462 */
> +		/* Counter1 is bits 1431 to 1462 */
> 		tmp64 =  (userbuf[22] >> 9) & 0x00000000ffffffff;
> 		/* OR sticky1 (bit 1463) to counter1 bit 32 */
> 		tmp64 |= (userbuf[22] << 23) & 0x0000000080000000;
> 		raddr[1] = (uint32_t)tmp64;
> 
> -		/* Counter2 is bits 1464 thru 1495 */
> +		/* Counter2 is bits 1464 to 1495 */
> 		tmp64 =  (userbuf[22] << 24) & 0x00000000ff000000;
> 		tmp64 |= (userbuf[23] >> 40) & 0x0000000000ffffff;
> 		/* OR sticky2 (bit 1496) to counter2 bit 32 */
> 		tmp64 |= (userbuf[23] >> 8) & 0x0000000080000000;
> 		raddr[2] = (uint32_t)tmp64;
> 		
> -		/* Counter3 is bits 1497 thru 1528 */
> +		/* Counter3 is bits 1497 to 1528 */
> 		tmp64 =  (userbuf[23] >> 7) & 0x00000000ffffffff;
> 		/* OR sticky3 (bit 1529) to counter3 bit 32 */
> 		tmp64 |= (userbuf[23] << 25) & 0x0000000080000000;
> @@ -616,7 +616,7 @@ static int perf_stop_counters(uint32_t *raddr)
> 		userbuf[23] = 0;
> 
> 		/* 
> -		 * Write back the zero'ed bytes + the image given
> +		 * Write back the zeroed bytes + the image given
> 		 * the read was destructive.
> 		 */
> 		perf_rdr_write(16, userbuf);
> diff --git a/arch/parisc/kernel/processor.c b/arch/parisc/kernel/processor.c
> index dd5d0cb..15992f4 100644
> --- a/arch/parisc/kernel/processor.c
> +++ b/arch/parisc/kernel/processor.c
> @@ -63,7 +63,7 @@ extern int update_cr16_clocksource(void);	/* from 
> time.c */
> ** will call register_parisc_driver(&cpu_driver) before calling 
> do_inventory().
> **
> ** The goal of consolidating CPU initialization into one place is
> -** to make sure all CPU's get initialized the same way.
> +** to make sure all CPUs get initialized the same way.
> ** The code path not shared is how PDC hands control of the CPU to the OS.
> ** The initialization of OS data structures is the same (done below).
> */
> @@ -166,7 +166,7 @@ static int __init processor_probe(struct parisc_device 
> *dev)
> #endif
> 
> 	/*
> -	** CONFIG_SMP: init_smp_config() will attempt to get CPU's into
> +	** CONFIG_SMP: init_smp_config() will attempt to get CPUs into
> 	** OS control. RENDEZVOUS is the default state - see mem_set above.
> 	**	p->state = STATE_RENDEZVOUS;
> 	*/
> @@ -334,7 +334,7 @@ int __init init_per_cpu(int cpunum)
> }
> 
> /*
> - * Display cpu info for all cpu's.
> + * Display CPU info for all CPUs.
>  */
> int
> show_cpuinfo (struct seq_file *m, void *v)
> @@ -393,7 +393,7 @@ static struct parisc_driver cpu_driver __read_mostly = {
> };
> 
> /**
> - * processor_init - Processor initalization procedure.
> + * processor_init - Processor initialization procedure.
>  *
>  * Register this driver.
>  */
> diff --git a/arch/parisc/kernel/setup.c b/arch/parisc/kernel/setup.c
> index 9818919..9d2a1d5 100644
> --- a/arch/parisc/kernel/setup.c
> +++ b/arch/parisc/kernel/setup.c
> @@ -162,7 +162,7 @@ void __init setup_arch(char **cmdline_p)
> }
> 
> /*
> - * Display cpu info for all cpu's.
> + * Display CPU info for all CPUs.
>  * for parisc this is in processor.c
>  */
> extern int show_cpuinfo (struct seq_file *m, void *v);
> diff --git a/arch/parisc/kernel/signal32.h b/arch/parisc/kernel/signal32.h
> index e39b38a..c780084 100644
> --- a/arch/parisc/kernel/signal32.h
> +++ b/arch/parisc/kernel/signal32.h
> @@ -113,7 +113,7 @@ int copy_siginfo_from_user32 (siginfo_t *to, 
> compat_siginfo_t __user *from);
> /* In a deft move of uber-hackery, we decide to carry the top half of all
>  * 64-bit registers in a non-portable, non-ABI, hidden structure.
>  * Userspace can read the hidden structure if it *wants* but is never
> - * guaranteed to be in the same place. Infact the uc_sigmask from the
> + * guaranteed to be in the same place. In fact the uc_sigmask from the
>  * ucontext_t structure may push the hidden register file downards
>  */
> struct compat_regfile {
> diff --git a/arch/parisc/kernel/smp.c b/arch/parisc/kernel/smp.c
> index 6ba9257..4bf7cd1 100644
> --- a/arch/parisc/kernel/smp.c
> +++ b/arch/parisc/kernel/smp.c
> @@ -8,7 +8,7 @@
> ** Lots of stuff stolen from arch/alpha/kernel/smp.c
> ** ...and then parisc stole from arch/ia64/kernel/smp.c. Thanks David! :^)
> **
> -** Thanks to John Curry and Ullas Ponnadi. I learned alot from their work.
> +** Thanks to John Curry and Ullas Ponnadi. I learned a lot from their work.
> ** -grant (1/12/2001)
> **
> **	This program is free software; you can redistribute it and/or modify
> @@ -419,7 +419,7 @@ smp_cpu_init(int cpunum)
> 		BUG();
> 	enter_lazy_tlb(&init_mm, current);
> 
> -	init_IRQ();   /* make sure no IRQ's are enabled or pending */
> +	init_IRQ();   /* make sure no IRQs are enabled or pending */
> 	start_cpu_itimer();
> }
> 
> @@ -552,7 +552,7 @@ void __devinit smp_prepare_boot_cpu(void)
> 
> /*
> ** inventory.c:do_inventory() hasn't yet been run and thus we
> -** don't 'discover' the additional CPU's until later.
> +** don't 'discover' the additional CPUs until later.
> */
> void __init smp_prepare_cpus(unsigned int max_cpus)
> {
> diff --git a/arch/parisc/kernel/time.c b/arch/parisc/kernel/time.c
> index 07a991a..8b3062a 100644
> --- a/arch/parisc/kernel/time.c
> +++ b/arch/parisc/kernel/time.c
> @@ -191,7 +191,7 @@ int update_cr16_clocksource(void)
> {
> 	int change = 0;
> 
> -	/* since the cr16 cycle counters are not syncronized across CPUs,
> +	/* since the cr16 cycle counters are not synchronized across CPUs,
> 	   we'll check if we should switch to a safe clocksource: */
> 	if (clocksource_cr16.rating != 0 && num_online_cpus() > 1) {
> 		clocksource_change_rating(&clocksource_cr16, 0);
> diff --git a/arch/parisc/kernel/traps.c b/arch/parisc/kernel/traps.c
> index 745ff74..6c05545 100644
> --- a/arch/parisc/kernel/traps.c
> +++ b/arch/parisc/kernel/traps.c
> @@ -615,7 +615,7 @@ void handle_interruption(int code, struct pt_regs *regs)
> 		
> 	case 13:
> 		/* Conditional Trap
> -		   The condition succees in an instruction which traps 
> +		   The condition succeeds in an instruction which traps 
> 		   on condition  */
> 		if(user_mode(regs)){
> 			si.si_signo = SIGFPE;
> diff --git a/arch/parisc/math-emu/dbl_float.h 
> b/arch/parisc/math-emu/dbl_float.h
> index 1570e2e..0c2fa9a 100644
> --- a/arch/parisc/math-emu/dbl_float.h
> +++ b/arch/parisc/math-emu/dbl_float.h
> @@ -22,7 +22,7 @@
>     PA header file -- do not include this header file for non-PA builds.
> #endif
> 
> -/* 32-bit word grabing functions */
> +/* 32-bit word grabbing functions */
> #define Dbl_firstword(value) Dallp1(value)
> #define Dbl_secondword(value) Dallp2(value)
> #define Dbl_thirdword(value) dummy_location
> @@ -37,7 +37,7 @@
> #define Dbl_allp1(object) Dallp1(object)
> #define Dbl_allp2(object) Dallp2(object)
> 
> -/* dbl_and_signs ands the sign bits of each argument and puts the result
> +/* dbl_and_signs ANDs the sign bits of each argument and puts the result
>  * into the first argument. dbl_or_signs ors those same sign bits */
> #define Dbl_and_signs( src1dst, src2)		\
>     Dallp1(src1dst) = (Dallp1(src2)|~((unsigned int)1<<31)) & 
>     Dallp1(src1dst)
> diff --git a/arch/parisc/math-emu/dfsqrt.c b/arch/parisc/math-emu/dfsqrt.c
> index b6ed106..9542c6d 100644
> --- a/arch/parisc/math-emu/dfsqrt.c
> +++ b/arch/parisc/math-emu/dfsqrt.c
> @@ -76,7 +76,7 @@ dbl_fsqrt(
>                 }
>                 /*
>                  * Return quiet NaN or positive infinity.
> -		 *  Fall thru to negative test if negative infinity.
> +		 *  Fall through to negative test if negative infinity.
>                  */
> 		if (Dbl_iszero_sign(srcp1) || 
> 		    Dbl_isnotzero_mantissa(srcp1,srcp2)) {
> diff --git a/arch/parisc/math-emu/sfsqrt.c b/arch/parisc/math-emu/sfsqrt.c
> index cd3f6db..4657a12 100644
> --- a/arch/parisc/math-emu/sfsqrt.c
> +++ b/arch/parisc/math-emu/sfsqrt.c
> @@ -76,7 +76,7 @@ sgl_fsqrt(
>                 }
>                 /*
>                  * Return quiet NaN or positive infinity.
> -		 *  Fall thru to negative test if negative infinity.
> +		 *  Fall through to negative test if negative infinity.
>                  */
> 		if (Sgl_iszero_sign(src) || Sgl_isnotzero_mantissa(src)) {
>                 	*dstptr = src;
> diff --git a/arch/parisc/math-emu/sgl_float.h 
> b/arch/parisc/math-emu/sgl_float.h
> index 82519a5..4ee4cc9 100644
> --- a/arch/parisc/math-emu/sgl_float.h
> +++ b/arch/parisc/math-emu/sgl_float.h
> @@ -23,7 +23,7 @@
>     PA header file -- do not include this header file for non-PA builds.
> #endif
> 
> -/* 32-bit word grabing functions */
> +/* 32-bit word grabbing functions */
> #define Sgl_firstword(value) Sall(value)
> #define Sgl_secondword(value) dummy_location
> #define Sgl_thirdword(value) dummy_location
> @@ -36,7 +36,7 @@
> #define Sgl_exponentmantissa(object) Sexponentmantissa(object)
> #define Sgl_all(object) Sall(object)
> 
> -/* sgl_and_signs ands the sign bits of each argument and puts the result
> +/* sgl_and_signs ANDs the sign bits of each argument and puts the result
>  * into the first argument. sgl_or_signs ors those same sign bits */
> #define Sgl_and_signs( src1dst, src2)		\
>     Sall(src1dst) = (Sall(src2)|~((unsigned int)1<<31)) & Sall(src1dst)
> diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
> index 75ea9f2..e724b36 100644
> --- a/arch/parisc/mm/init.c
> +++ b/arch/parisc/mm/init.c
> @@ -890,7 +890,7 @@ void __init paging_init(void)
> #ifdef CONFIG_PA20
> 
> /*
> - * Currently, all PA20 chips have 18 bit protection id's, which is the
> + * Currently, all PA20 chips have 18 bit protection IDs, which is the
>  * limiting factor (space ids are 32 bits).
>  */
> 
> @@ -899,10 +899,10 @@ void __init paging_init(void)
> #else
> 
> /*
> - * Currently we have a one-to-one relationship between space id's and
> - * protection id's. Older parisc chips (PCXS, PCXT, PCXL, PCXL2) only
> - * support 15 bit protection id's, so that is the limiting factor.
> - * PCXT' has 18 bit protection id's, but only 16 bit spaceids, so it's
> + * Currently we have a one-to-one relationship between space IDs and
> + * protection IDs. Older parisc chips (PCXS, PCXT, PCXL, PCXL2) only
> + * support 15 bit protection IDs, so that is the limiting factor.
> + * PCXT' has 18 bit protection IDs, but only 16 bit spaceids, so it's
>  * probably not worth the effort for a special case here.
>  */
> 
> -- 
> 1.5.0.1
> 
> -- 
> Simon Arlott
> _______________________________________________
> parisc-linux mailing list
> parisc-linux@lists.parisc-linux.org
> http://lists.parisc-linux.org/mailman/listinfo/parisc-linux
