Return-Path: <linux-kernel-owner+w=401wt.eu-S1757774AbZCSJne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774AbZCSJne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 05:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759462AbZCSJnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 05:43:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:34935 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759224AbZCSJnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 05:43:05 -0400
Message-ID: <49C213A2.4040609@monstr.eu>
Date: Thu, 19 Mar 2009 10:42:58 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.17 (X11/20081001)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, john.williams@petalogix.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Microblaze linux support
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu> <20090319072256.GA5069@elte.hu>
In-Reply-To: <20090319072256.GA5069@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

>> Hi all,
>>
>> I think that is the right time to send you next pack with 
>> Microblaze support. It is seventh pack - some previous packs
>> was review by community and I hope there are not any big faults.
> 
> I have not done a deep review, but there's a lot of avoidable easy 
> style bugs in the patches. All the patches together, passed through 
> scripts/checkpatch.pl give ~200 errors:
> 
>   total: 40 errors, 146 warnings, 15737 lines checked
> 
> A quick look suggests that most of the warnings pinpoint real 
> problems. (and you can ignore false positives)

I fixed coding style issue which was there. Some of them are false positive.
I don't want to disturb people with next big pack and next version that's why I
updated only branch on git (Patches has name microblaze_v8-pre)
Below is part of log with faults which are announcing with checkpatch.pl script
+ my comments. I remove patches without any fault.

Thanks for noticing me in cases where I am wrong.

Thanks,
Michal



> 
> Thanks,
> 
> 	Ingo


ERROR: spaces prohibited around that ':' (ctx:WxW)
#2588: FILE: arch/microblaze/kernel/prom_parse.c:637:
+	cells = prop ? *(u32 *)prop : of_n_addr_cells(dn);
 	                            ^

ERROR: spaces prohibited around that ':' (ctx:WxW)
#2594: FILE: arch/microblaze/kernel/prom_parse.c:643:
+	cells = prop ? *(u32 *)prop : of_n_size_cells(dn);
 	                            ^

total: 2 errors, 0 warnings, 2910 lines checked

0004-microblaze_v8-pre-Open-firmware-files.patch has style problems, please
review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.


I think that this is correct coding style (Same for PowerPC)
-------------------------------------------------------------------------------------------



WARNING: do not add new typedefs
#127: FILE: arch/microblaze/include/asm/signal.h:107:
+typedef unsigned long old_sigset_t; /* at least 32 bits */

WARNING: do not add new typedefs
#129: FILE: arch/microblaze/include/asm/signal.h:109:
+typedef struct {

WARNING: do not add new typedefs
#161: FILE: arch/microblaze/include/asm/signal.h:141:
+typedef unsigned long sigset_t;

WARNING: do not add new typedefs
#178: FILE: arch/microblaze/include/asm/signal.h:158:
+typedef struct sigaltstack {

total: 0 errors, 4 warnings, 701 lines checked

0007-microblaze_v8-pre-Signal-support.patch has style problems, please review.
If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.



False positive.
-------------------------------------------------------------------------------------------



WARNING: do not add new typedefs
#57: FILE: arch/microblaze/include/asm/module.h:35:
+typedef struct { volatile int counter; } module_t;

WARNING: Use of volatile is usually wrong: see
Documentation/volatile-considered-harmful.txt
#57: FILE: arch/microblaze/include/asm/module.h:35:
+typedef struct { volatile int counter; } module_t;

WARNING: externs should be avoided in .c files
#92: FILE: arch/microblaze/kernel/microblaze_ksyms.c:27:
+extern void __ashldi3(void);

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
#93: FILE: arch/microblaze/kernel/microblaze_ksyms.c:28:
+EXPORT_SYMBOL(__ashldi3);

WARNING: externs should be avoided in .c files
#94: FILE: arch/microblaze/kernel/microblaze_ksyms.c:29:
+extern void __ashrdi3(void);

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
#95: FILE: arch/microblaze/kernel/microblaze_ksyms.c:30:
+EXPORT_SYMBOL(__ashrdi3);

WARNING: externs should be avoided in .c files
#96: FILE: arch/microblaze/kernel/microblaze_ksyms.c:31:
+extern void __divsi3(void);

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
#97: FILE: arch/microblaze/kernel/microblaze_ksyms.c:32:
+EXPORT_SYMBOL(__divsi3);

WARNING: externs should be avoided in .c files
#98: FILE: arch/microblaze/kernel/microblaze_ksyms.c:33:
+extern void __lshrdi3(void);

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
#99: FILE: arch/microblaze/kernel/microblaze_ksyms.c:34:
+EXPORT_SYMBOL(__lshrdi3);

WARNING: externs should be avoided in .c files
#100: FILE: arch/microblaze/kernel/microblaze_ksyms.c:35:
+extern void __modsi3(void);

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
#101: FILE: arch/microblaze/kernel/microblaze_ksyms.c:36:
+EXPORT_SYMBOL(__modsi3);

WARNING: externs should be avoided in .c files
#102: FILE: arch/microblaze/kernel/microblaze_ksyms.c:37:
+extern void __mulsi3(void);

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
#103: FILE: arch/microblaze/kernel/microblaze_ksyms.c:38:
+EXPORT_SYMBOL(__mulsi3);

WARNING: externs should be avoided in .c files
#104: FILE: arch/microblaze/kernel/microblaze_ksyms.c:39:
+extern void __muldi3(void);

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
#105: FILE: arch/microblaze/kernel/microblaze_ksyms.c:40:
+EXPORT_SYMBOL(__muldi3);

WARNING: externs should be avoided in .c files
#106: FILE: arch/microblaze/kernel/microblaze_ksyms.c:41:
+extern void __ucmpdi2(void);

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
#107: FILE: arch/microblaze/kernel/microblaze_ksyms.c:42:
+EXPORT_SYMBOL(__ucmpdi2);

WARNING: externs should be avoided in .c files
#108: FILE: arch/microblaze/kernel/microblaze_ksyms.c:43:
+extern void __udivsi3(void);

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
#109: FILE: arch/microblaze/kernel/microblaze_ksyms.c:44:
+EXPORT_SYMBOL(__udivsi3);

WARNING: externs should be avoided in .c files
#110: FILE: arch/microblaze/kernel/microblaze_ksyms.c:45:
+extern void __umodsi3(void);

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
#111: FILE: arch/microblaze/kernel/microblaze_ksyms.c:46:
+EXPORT_SYMBOL(__umodsi3);

total: 0 errors, 22 warnings, 231 lines checked

0011-microblaze_v8-pre-kernel-modules-support.patch has style problems, please
review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.


False positive
-------------------------------------------------------------------------------------------

WARNING: usage of NR_CPUS is often wrong - consider using cpu_possible(),
num_possible_cpus(), for_each_possible_cpu(), etc
#367: FILE: arch/microblaze/kernel/cpu/mb.c:130:
+	return i < NR_CPUS ? (void *) (i + 1) : NULL;

total: 0 errors, 1 warnings, 438 lines checked

0013-microblaze_v8-pre-PVR-support-cpuinfo-support.patch has style problems,
please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.


NR_CPUS is used almost in all arch (x86 use it too)
-------------------------------------------------------------------------------------------

ERROR: Don't use kernel_thread(): see Documentation/feature-removal-schedule.txt
#216: FILE: arch/microblaze/kernel/process.c:163:
+int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)

total: 1 errors, 0 warnings, 213 lines checked

0024-microblaze_v8-pre-process-and-init-task-function.patch has style problems,
please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.


I am not sure but I found implementation of kernel_thread in x86, powerpc has
asm implementation. Arm use C implementation as we have for MB.
-------------------------------------------------------------------------------------------


WARNING: do not add new typedefs
#112: FILE: arch/microblaze/include/asm/timex.h:14:
+typedef unsigned long cycles_t;

total: 0 errors, 1 warnings, 90 lines checked

0025-microblaze_v8-pre-delay.h-timex.h.patch has style problems, please review.
 If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.
WARNING: do not add new typedefs
#35: FILE: arch/microblaze/include/asm/ptrace.h:15:
+typedef unsigned long microblaze_reg_t;

total: 0 errors, 1 warnings, 250 lines checked

0026-microblaze_v8-pre-ptrace-support.patch has style problems, please review.
If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.


False positive
-------------------------------------------------------------------------------------------


WARNING: Use of volatile is usually wrong: see
Documentation/volatile-considered-harmful.txt
#41: FILE: arch/microblaze/kernel/traps.c:23:
+void __bad_xchg(volatile void *ptr, int size)

total: 0 errors, 1 warnings, 105 lines checked

0028-microblaze_v8-pre-traps-support.patch has style problems, please review.
If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.


ARM has the same implemtation - I think that's ok.

-------------------------------------------------------------------------------------------
WARNING: do not add new typedefs
#39: FILE: arch/microblaze/include/asm/mmu.h:13:
+typedef struct {

total: 0 errors, 1 warnings, 277 lines checked

0029-microblaze_v8-pre-memory-inicialization-MMU-TLB.patch has style problems,
please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

false positive
-------------------------------------------------------------------------------------------

WARNING: do not add new typedefs
#82: FILE: arch/microblaze/include/asm/page.h:60:
+typedef struct page *pgtable_t;

WARNING: do not add new typedefs
#83: FILE: arch/microblaze/include/asm/page.h:61:
+typedef struct { unsigned long pte; }          pte_t;

WARNING: do not add new typedefs
#84: FILE: arch/microblaze/include/asm/page.h:62:
+typedef struct { unsigned long pgprot; }       pgprot_t;

WARNING: do not add new typedefs
#85: FILE: arch/microblaze/include/asm/page.h:63:
+typedef struct { unsigned long ste[64]; }      pmd_t;

WARNING: do not add new typedefs
#86: FILE: arch/microblaze/include/asm/page.h:64:
+typedef struct { pmd_t         pue[1]; }       pud_t;

WARNING: do not add new typedefs
#87: FILE: arch/microblaze/include/asm/page.h:65:
+typedef struct { pud_t         pge[1]; }       pgd_t;

WARNING: do not add new typedefs
#184: FILE: arch/microblaze/include/asm/segment.h:16:
+typedef struct {

total: 0 errors, 7 warnings, 205 lines checked

0030-microblaze_v8-pre-page.h-segment.h-unaligned.h.patch has style problems,
please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.


false positive
-------------------------------------------------------------------------------------------

WARNING: do not add new typedefs
#38: FILE: arch/microblaze/include/asm/posix_types.h:18:
+typedef unsigned long	__kernel_ino_t;

WARNING: do not add new typedefs
#39: FILE: arch/microblaze/include/asm/posix_types.h:19:
+typedef unsigned int	__kernel_mode_t;

WARNING: do not add new typedefs
#40: FILE: arch/microblaze/include/asm/posix_types.h:20:
+typedef unsigned int	__kernel_nlink_t;

WARNING: do not add new typedefs
#41: FILE: arch/microblaze/include/asm/posix_types.h:21:
+typedef long		__kernel_off_t;

WARNING: do not add new typedefs
#42: FILE: arch/microblaze/include/asm/posix_types.h:22:
+typedef int		__kernel_pid_t;

WARNING: do not add new typedefs
#43: FILE: arch/microblaze/include/asm/posix_types.h:23:
+typedef unsigned int	__kernel_ipc_pid_t;

WARNING: do not add new typedefs
#44: FILE: arch/microblaze/include/asm/posix_types.h:24:
+typedef unsigned int	__kernel_uid_t;

WARNING: do not add new typedefs
#45: FILE: arch/microblaze/include/asm/posix_types.h:25:
+typedef unsigned int	__kernel_gid_t;

WARNING: do not add new typedefs
#46: FILE: arch/microblaze/include/asm/posix_types.h:26:
+typedef unsigned long	__kernel_size_t;

WARNING: do not add new typedefs
#47: FILE: arch/microblaze/include/asm/posix_types.h:27:
+typedef long		__kernel_ssize_t;

WARNING: do not add new typedefs
#48: FILE: arch/microblaze/include/asm/posix_types.h:28:
+typedef int		__kernel_ptrdiff_t;

WARNING: do not add new typedefs
#49: FILE: arch/microblaze/include/asm/posix_types.h:29:
+typedef long		__kernel_time_t;

WARNING: do not add new typedefs
#50: FILE: arch/microblaze/include/asm/posix_types.h:30:
+typedef long		__kernel_suseconds_t;

WARNING: do not add new typedefs
#51: FILE: arch/microblaze/include/asm/posix_types.h:31:
+typedef long		__kernel_clock_t;

WARNING: do not add new typedefs
#52: FILE: arch/microblaze/include/asm/posix_types.h:32:
+typedef int		__kernel_timer_t;

WARNING: do not add new typedefs
#53: FILE: arch/microblaze/include/asm/posix_types.h:33:
+typedef int		__kernel_clockid_t;

WARNING: do not add new typedefs
#54: FILE: arch/microblaze/include/asm/posix_types.h:34:
+typedef int		__kernel_daddr_t;

WARNING: do not add new typedefs
#55: FILE: arch/microblaze/include/asm/posix_types.h:35:
+typedef char 		*__kernel_caddr_t;

WARNING: do not add new typedefs
#56: FILE: arch/microblaze/include/asm/posix_types.h:36:
+typedef unsigned short	__kernel_uid16_t;

WARNING: do not add new typedefs
#57: FILE: arch/microblaze/include/asm/posix_types.h:37:
+typedef unsigned short	__kernel_gid16_t;

WARNING: do not add new typedefs
#58: FILE: arch/microblaze/include/asm/posix_types.h:38:
+typedef unsigned int	__kernel_uid32_t;

WARNING: do not add new typedefs
#59: FILE: arch/microblaze/include/asm/posix_types.h:39:
+typedef unsigned int	__kernel_gid32_t;

WARNING: do not add new typedefs
#62: FILE: arch/microblaze/include/asm/posix_types.h:42:
+typedef long long	__kernel_loff_t;

WARNING: do not add new typedefs
#65: FILE: arch/microblaze/include/asm/posix_types.h:45:
+typedef struct {

WARNING: do not add new typedefs
#119: FILE: arch/microblaze/include/asm/types.h:24:
+typedef unsigned short umode_t;


false positive
-------------------------------------------------------------------------------------------

WARNING: Use of volatile is usually wrong: see
Documentation/volatile-considered-harmful.txt
#37: FILE: arch/microblaze/include/asm/io.h:19:
+static inline unsigned char __raw_readb(const volatile void __iomem *addr)

WARNING: Use of volatile is usually wrong: see
Documentation/volatile-considered-harmful.txt
#39: FILE: arch/microblaze/include/asm/io.h:21:
+	return *(volatile unsigned char __force *)addr;

WARNING: Use of volatile is usually wrong: see
Documentation/volatile-considered-harmful.txt
#41: FILE: arch/microblaze/include/asm/io.h:23:
+static inline unsigned short __raw_readw(const volatile void __iomem *addr)

WARNING: Use of volatile is usually wrong: see
Documentation/volatile-considered-harmful.txt
#43: FILE: arch/microblaze/include/asm/io.h:25:
+	return *(volatile unsigned short __force *)addr;

WARNING: Use of volatile is usually wrong: see
Documentation/volatile-considered-harmful.txt
#45: FILE: arch/microblaze/include/asm/io.h:27:
+static inline unsigned int __raw_readl(const volatile void __iomem *addr)

WARNING: Use of volatile is usually wrong: see
Documentation/volatile-considered-harmful.txt
#47: FILE: arch/microblaze/include/asm/io.h:29:
+	return *(volatile unsigned int __force *)addr;

WARNING: Use of volatile is usually wrong: see
Documentation/volatile-considered-harmful.txt
#49: FILE: arch/microblaze/include/asm/io.h:31:
+static inline unsigned long __raw_readq(const volatile void __iomem *addr)

WARNING: Use of volatile is usually wrong: see
Documentation/volatile-considered-harmful.txt
#51: FILE: arch/microblaze/include/asm/io.h:33:
+	return *(volatile unsigned long __force *)addr;

WARNING: Use of volatile is usually wrong: see
Documentation/volatile-considered-harmful.txt
#53: FILE: arch/microblaze/include/asm/io.h:35:
+static inline void __raw_writeb(unsigned char v, volatile void __iomem *addr)

WARNING: Use of volatile is usually wrong: see
Documentation/volatile-considered-harmful.txt
#55: FILE: arch/microblaze/include/asm/io.h:37:
+	*(volatile unsigned char __force *)addr = v;

WARNING: Use of volatile is usually wrong: see
Documentation/volatile-considered-harmful.txt
#57: FILE: arch/microblaze/include/asm/io.h:39:
+static inline void __raw_writew(unsigned short v, volatile void __iomem *addr)

WARNING: Use of volatile is usually wrong: see
Documentation/volatile-considered-harmful.txt
#59: FILE: arch/microblaze/include/asm/io.h:41:
+	*(volatile unsigned short __force *)addr = v;

WARNING: Use of volatile is usually wrong: see
Documentation/volatile-considered-harmful.txt
#61: FILE: arch/microblaze/include/asm/io.h:43:
+static inline void __raw_writel(unsigned int v, volatile void __iomem *addr)

WARNING: Use of volatile is usually wrong: see
Documentation/volatile-considered-harmful.txt
#63: FILE: arch/microblaze/include/asm/io.h:45:
+	*(volatile unsigned int __force *)addr = v;

WARNING: Use of volatile is usually wrong: see
Documentation/volatile-considered-harmful.txt
#65: FILE: arch/microblaze/include/asm/io.h:47:
+static inline void __raw_writeq(unsigned long v, volatile void __iomem *addr)

WARNING: Use of volatile is usually wrong: see
Documentation/volatile-considered-harmful.txt
#67: FILE: arch/microblaze/include/asm/io.h:49:
+	*(volatile unsigned long __force *)addr = v;

WARNING: Use of volatile is usually wrong: see
Documentation/volatile-considered-harmful.txt
#75: FILE: arch/microblaze/include/asm/io.h:57:
+static inline unsigned char readb(const volatile void __iomem *addr)

WARNING: Use of volatile is usually wrong: see
Documentation/volatile-considered-harmful.txt
#77: FILE: arch/microblaze/include/asm/io.h:59:
+	return *(volatile unsigned char __force *)addr;

WARNING: Use of volatile is usually wrong: see
Documentation/volatile-considered-harmful.txt
#79: FILE: arch/microblaze/include/asm/io.h:61:
+static inline unsigned short readw(const volatile void __iomem *addr)

WARNING: Use of volatile is usually wrong: see
Documentation/volatile-considered-harmful.txt
#81: FILE: arch/microblaze/include/asm/io.h:63:
+	return le16_to_cpu(*(volatile unsigned short __force *)addr);

WARNING: Use of volatile is usually wrong: see
Documentation/volatile-considered-harmful.txt
#83: FILE: arch/microblaze/include/asm/io.h:65:
+static inline unsigned int readl(const volatile void __iomem *addr)

WARNING: Use of volatile is usually wrong: see
Documentation/volatile-considered-harmful.txt
#85: FILE: arch/microblaze/include/asm/io.h:67:
+	return le32_to_cpu(*(volatile unsigned int __force *)addr);

WARNING: Use of volatile is usually wrong: see
Documentation/volatile-considered-harmful.txt
#87: FILE: arch/microblaze/include/asm/io.h:69:
+static inline void writeb(unsigned char v, volatile void __iomem *addr)

WARNING: Use of volatile is usually wrong: see
Documentation/volatile-considered-harmful.txt
#89: FILE: arch/microblaze/include/asm/io.h:71:
+	*(volatile unsigned char __force *)addr = v;

WARNING: Use of volatile is usually wrong: see
Documentation/volatile-considered-harmful.txt
#91: FILE: arch/microblaze/include/asm/io.h:73:
+static inline void writew(unsigned short v, volatile void __iomem *addr)

WARNING: Use of volatile is usually wrong: see
Documentation/volatile-considered-harmful.txt
#93: FILE: arch/microblaze/include/asm/io.h:75:
+	*(volatile unsigned short __force *)addr = cpu_to_le16(v);

WARNING: Use of volatile is usually wrong: see
Documentation/volatile-considered-harmful.txt
#95: FILE: arch/microblaze/include/asm/io.h:77:
+static inline void writel(unsigned int v, volatile void __iomem *addr)

WARNING: Use of volatile is usually wrong: see
Documentation/volatile-considered-harmful.txt
#97: FILE: arch/microblaze/include/asm/io.h:79:
+	*(volatile unsigned int __force *)addr = cpu_to_le32(v);

WARNING: Use of volatile is usually wrong: see
Documentation/volatile-considered-harmful.txt
#146: FILE: arch/microblaze/include/asm/io.h:128:
+static inline unsigned long __iomem virt_to_phys(volatile void *address)

total: 0 errors, 29 warnings, 209 lines checked

0035-microblaze_v8-pre-io.h-IO-operations.patch has style problems, please
review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

false positive - same as powerpc
-------------------------------------------------------------------------------------------


WARNING: do not add new typedefs
#44: FILE: arch/microblaze/include/asm/hardirq.h:21:
+typedef struct {

total: 0 errors, 1 warnings, 153 lines checked

0038-microblaze_v8-pre-headers-for-irq.patch has style problems, please review.
 If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

false positive
-------------------------------------------------------------------------------------------

ERROR: Don't use kernel_thread(): see Documentation/feature-removal-schedule.txt
#105: FILE: arch/microblaze/include/asm/processor.h:85:
+extern int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);

WARNING: Use of volatile is usually wrong: see
Documentation/volatile-considered-harmful.txt
#162: FILE: arch/microblaze/include/asm/system.h:43:
+void __bad_xchg(volatile void *ptr, int size);

WARNING: Use of volatile is usually wrong: see
Documentation/volatile-considered-harmful.txt
#164: FILE: arch/microblaze/include/asm/system.h:45:
+static inline unsigned long __xchg(unsigned long x, volatile void *ptr,

WARNING: Use of volatile is usually wrong: see
Documentation/volatile-considered-harmful.txt
#173: FILE: arch/microblaze/include/asm/system.h:54:
+		ret = *(volatile unsigned char *)ptr;

WARNING: Use of volatile is usually wrong: see
Documentation/volatile-considered-harmful.txt
#174: FILE: arch/microblaze/include/asm/system.h:55:
+		*(volatile unsigned char *)ptr = x;

WARNING: Use of volatile is usually wrong: see
Documentation/volatile-considered-harmful.txt
#180: FILE: arch/microblaze/include/asm/system.h:61:
+		ret = *(volatile unsigned long *)ptr;

WARNING: Use of volatile is usually wrong: see
Documentation/volatile-considered-harmful.txt
#181: FILE: arch/microblaze/include/asm/system.h:62:
+		*(volatile unsigned long *)ptr = x;

total: 1 errors, 6 warnings, 184 lines checked

0041-microblaze_v8-pre-system.h-processor.h.patch has style problems, please
review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.



kernel thread - as above. xchg -> sam as arm. Am I right?

-------------------------------------------------------------------------------------------

WARNING: do not add new typedefs
#34: FILE: arch/microblaze/include/asm/termbits.h:14:
+typedef unsigned char	cc_t;

WARNING: do not add new typedefs
#35: FILE: arch/microblaze/include/asm/termbits.h:15:
+typedef unsigned int	speed_t;

WARNING: do not add new typedefs
#36: FILE: arch/microblaze/include/asm/termbits.h:16:
+typedef unsigned int	tcflag_t;

total: 0 errors, 3 warnings, 291 lines checked

0044-microblaze_v8-pre-termbits.h-termios.h.patch has style problems, please
review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

false positive
-------------------------------------------------------------------------------------------

ERROR: Aspace prohibited after that '&' (ctx:WxW)
#152: FILE: arch/microblaze/include/asm/thread_info.h:102:
+	return (struct thread_info *)(sp & ~(THREAD_SIZE-1));
 	                                 ^

total: 1 errors, 0 warnings, 176 lines checked

0053-microblaze_v8-pre-string.h-thread_info.h.patch has style problems, please
review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.


I think here is correct coding style.
-------------------------------------------------------------------------------------------

That's all.
M


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
