Return-Path: <linux-kernel-owner+w=401wt.eu-S1753966AbZLYL4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbZLYL4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 06:56:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbZLYL4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 06:56:12 -0500
Received: from smtp-out4.blueyonder.co.uk ([195.188.213.7]:37856 "EHLO
	smtp-out4.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752009AbZLYL4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 06:56:10 -0500
Message-ID: <4B341149.9010106@blueyonder.co.uk>
Date: Fri, 25 Dec 2009 01:11:37 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.2 Thunderbird/3.0 ThunderBrowse/3.2.6.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: All kernels after 2.6.32-git10  show only 1 CPU ** Fixed in 2.6.33-rc2
 **
References: <4B324B76.9020901@blueyonder.co.uk> <4B33670C.7050503@blueyonder.co.uk>
In-Reply-To: <4B33670C.7050503@blueyonder.co.uk>
Content-Type: multipart/mixed;
 boundary="------------070800050007030907090502"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070800050007030907090502
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Just made some changes to .config, shall try building on the 2P box with
old .config to see if it's a config problem -- doubt so as the configs
were fine with earlier kernels.
Attaching the .config diff.
slipstream:~ # uname -r
2.6.33-rc2-smp
slipstream:~ # cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 16
model           : 4
model name      : AMD Phenom(tm) II X4 940 Processor
stepping        : 2
cpu MHz         : 3013.988
cache size      : 512 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 4
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 5
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good
nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit
wdt


bogomips        : 6027.96



TLB size        : 1024 4K pages



clflush size    : 64



cache_alignment : 64



address sizes   : 48 bits physical, 48 bits virtual



power management: ts ttp tm stc 100mhzsteps hwpstate




processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 16
model           : 4
model name      : AMD Phenom(tm) II X4 940 Processor
stepping        : 2
cpu MHz         : 3013.988
cache size      : 512 KB



physical id     : 0



siblings        : 4



core id         : 1



cpu cores       : 4



apicid          : 1



initial apicid  : 1



fpu             : yes



fpu_exception   : yes



cpuid level     : 5
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good
nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt
bogomips        : 6027.27
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

processor       : 2
vendor_id       : AuthenticAMD
cpu family      : 16
model           : 4
model name      : AMD Phenom(tm) II X4 940 Processor
stepping        : 2
cpu MHz         : 3013.988
cache size      : 512 KB
physical id     : 0
siblings        : 4
core id         : 2
cpu cores       : 4
apicid          : 2
initial apicid  : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 5
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good
nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt
bogomips        : 6027.27
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

processor       : 3
vendor_id       : AuthenticAMD
cpu family      : 16
model           : 4
model name      : AMD Phenom(tm) II X4 940 Processor
stepping        : 2
cpu MHz         : 3013.988
cache size      : 512 KB
physical id     : 0
siblings        : 4
core id         : 3
cpu cores       : 4
apicid          : 3
initial apicid  : 3
fpu             : yes
fpu_exception   : yes
cpuid level     : 5
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good
nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt
bogomips        : 6027.27
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate
Regards
Sid.

On 24/12/09 13:05, Sid Boyce wrote:
> On 23/12/09 16:55, Sid Boyce wrote:
>> On the 4P box, 2.6.32-git10 boots and shows 4 CPU's, 2.6.32-git12 boots
>> and shows 1 CPU, 2.6.32-git15 to 2.6.33-rc1-git3 1 CPU and lots of oops,
>> continues with something like "Sending NMI interrupts to CPU's",
>> [udev] unexpectedly returned with status 0x0100
>> [udev] failed while handling /devices/pci000:00 -----etc--- same for
>> other devices.
>> Unable to capture via serial console as USB doesn't come ready.
>>
>> On 2P laptop, up to 2.6.33-rc1 boots, 1 CPU and boot option "acpi=noirq"
>> needed, without it boot hangs, I think from 2.6.32-git15.
>>  Building kernels, I have used the .config from previous kernel and
>> "make oldconfig".
>>
>> # uname -r
>> 2.6.32-git12-smp
>> slipstream:~ # cat /proc/cpuinfo
>> processor       : 0
>> vendor_id       : AuthenticAMD
>> cpu family      : 16
>> model           : 4
>> model name      : AMD Phenom(tm) II X4 940 Processor
>> stepping        : 2
>> cpu MHz         : 3013.597
>> cache size      : 512 KB
>> physical id     : 0
>> siblings        : 1
>> core id         : 0
>> cpu cores       : 1
>> apicid          : 0
>> initial apicid  : 0
>> fpu             : yes
>> fpu_exception   : yes
>> cpuid level     : 5
>> wp              : yes
>> flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca
>> cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
>> pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc up rep_good nonstop_tsc
>> pni monitor cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm
>> sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt
>> bogomips        : 6027.18
>> TLB size        : 1024 4K pages
>> clflush size    : 64
>> cache_alignment : 64
>> address sizes   : 48 bits physical, 48 bits virtual
>> power management: ts ttp tm stc 100mhzsteps hwpstate
>>
>> # uname -r
>> 2.6.32-git10-smp
>>
>> # cat /proc/cpuinfo
>> processor       : 0
>> vendor_id       : AuthenticAMD
>> cpu family      : 16
>> model           : 4
>> model name      : AMD Phenom(tm) II X4 940 Processor
>> stepping        : 2
>> cpu MHz         : 3013.774
>> cache size      : 512 KB
>> physical id     : 0
>> siblings        : 4
>> core id         : 0
>> cpu cores       : 4
>> apicid          : 0
>> initial apicid  : 0
>> fpu             : yes
>> fpu_exception   : yes
>> cpuid level     : 5
>> wp              : yes
>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
>> mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
>> fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good
>> nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm
>> extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt
>> bogomips        : 6027.53
>> TLB size        : 1024 4K pages
>> clflush size    : 64
>> cache_alignment : 64
>> address sizes   : 48 bits physical, 48 bits virtual
>> power management: ts ttp tm stc 100mhzsteps hwpstate
>>
>> processor       : 1
>> vendor_id       : AuthenticAMD
>> cpu family      : 16
>> model           : 4
>> model name      : AMD Phenom(tm) II X4 940 Processor
>> stepping        : 2
>> cpu MHz         : 3013.774
>> cache size      : 512 KB
>> physical id     : 0
>> siblings        : 4
>> core id         : 1
>> cpu cores       : 4
>> apicid          : 1
>> initial apicid  : 1
>> fpu             : yes
>> fpu_exception   : yes
>> cpuid level     : 5
>> wp              : yes
>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
>> mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
>> fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good
>> nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm
>> extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt
>> bogomips        : 6027.27
>> TLB size        : 1024 4K pages
>> clflush size    : 64
>> cache_alignment : 64
>> address sizes   : 48 bits physical, 48 bits virtual
>> power management: ts ttp tm stc 100mhzsteps hwpstate
>>
>> etc., up to processor 4.
>>
>> On a 2P laptop
>> ===============
>> tindog:~ # uname -r
>> 2.6.33-rc1-smp
>>
>> tindog:~ # cat /proc/cpuinfo
>> processor       : 0
>> vendor_id       : AuthenticAMD
>> cpu family      : 15
>> model           : 67
>> model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 6000+
>> stepping        : 3
>> cpu MHz         : 1000.000
>> cache size      : 1024 KB
>> physical id     : 0
>> siblings        : 1
>> core id         : 0
>> cpu cores       : 1
>> apicid          : 0
>> initial apicid  : 0
>> fpu             : yes
>> fpu_exception   : yes
>> cpuid level     : 1
>> wp              : yes
>> flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca
>> cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
>> rdtscp lm 3dnowext 3dnow up rep_good pni cx16 lahf_lm cmp_legacy svm
>> extapic cr8_legacy
>> bogomips        : 2009.33
>> TLB size        : 1024 4K pages
>> clflush size    : 64
>> cache_alignment : 64
>> address sizes   : 40 bits physical, 48 bits virtual
>> power management: ts fid vid ttp tm stc
>>
>> The .config for the 4P and 2.6.33-rc1-git3 attached.
>> Regards
>> Sid.
>>
> 


-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

--------------070800050007030907090502
Content-Type: text/x-patch;
 name=".config.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=".config.diff"

--- /usr/src/linux-2.6.33-rc1-git4/.config	2009-12-24 00:39:42.720478049 +0000
+++ /usr/src/linux-2.6.33-rc2/.config	2009-12-25 00:01:08.869375402 +0000
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.33-rc1-git4
-# Thu Dec 24 00:39:42 2009
+# Linux kernel version: 2.6.33-rc2
+# Fri Dec 25 00:01:08 2009
 #
 CONFIG_64BIT=y
 # CONFIG_X86_32 is not set
@@ -159,7 +159,7 @@
 #
 CONFIG_PERF_EVENTS=y
 CONFIG_EVENT_PROFILE=y
-CONFIG_PERF_COUNTERS=y
+# CONFIG_PERF_COUNTERS is not set
 # CONFIG_DEBUG_PERF_USE_VMALLOC is not set
 CONFIG_VM_EVENT_COUNTERS=y
 CONFIG_PCI_QUIRKS=y
@@ -227,29 +227,29 @@
 # CONFIG_INLINE_SPIN_LOCK_BH is not set
 # CONFIG_INLINE_SPIN_LOCK_IRQ is not set
 # CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
-CONFIG_INLINE_SPIN_UNLOCK=y
+# CONFIG_INLINE_SPIN_UNLOCK is not set
 # CONFIG_INLINE_SPIN_UNLOCK_BH is not set
-CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
+# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
 # CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
 # CONFIG_INLINE_READ_TRYLOCK is not set
 # CONFIG_INLINE_READ_LOCK is not set
 # CONFIG_INLINE_READ_LOCK_BH is not set
 # CONFIG_INLINE_READ_LOCK_IRQ is not set
 # CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
-CONFIG_INLINE_READ_UNLOCK=y
+# CONFIG_INLINE_READ_UNLOCK is not set
 # CONFIG_INLINE_READ_UNLOCK_BH is not set
-CONFIG_INLINE_READ_UNLOCK_IRQ=y
+# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
 # CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
 # CONFIG_INLINE_WRITE_TRYLOCK is not set
 # CONFIG_INLINE_WRITE_LOCK is not set
 # CONFIG_INLINE_WRITE_LOCK_BH is not set
 # CONFIG_INLINE_WRITE_LOCK_IRQ is not set
 # CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
-CONFIG_INLINE_WRITE_UNLOCK=y
+# CONFIG_INLINE_WRITE_UNLOCK is not set
 # CONFIG_INLINE_WRITE_UNLOCK_BH is not set
-CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
+# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
 # CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
-CONFIG_MUTEX_SPIN_ON_OWNER=y
+# CONFIG_MUTEX_SPIN_ON_OWNER is not set
 CONFIG_FREEZER=y
 
 #
@@ -260,7 +260,7 @@
 CONFIG_HIGH_RES_TIMERS=y
 CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
 CONFIG_SMP=y
-CONFIG_X86_X2APIC=y
+# CONFIG_X86_X2APIC is not set
 # CONFIG_SPARSE_IRQ is not set
 # CONFIG_X86_MPPARSE is not set
 # CONFIG_X86_EXTENDED_PLATFORM is not set
@@ -330,9 +330,9 @@
 CONFIG_SWIOTLB=y
 CONFIG_IOMMU_HELPER=y
 CONFIG_IOMMU_API=y
-CONFIG_MAXSMP=y
-CONFIG_NR_CPUS=4096
-CONFIG_SCHED_SMT=y
+# CONFIG_MAXSMP is not set
+CONFIG_NR_CPUS=8
+# CONFIG_SCHED_SMT is not set
 CONFIG_SCHED_MC=y
 # CONFIG_PREEMPT_NONE is not set
 CONFIG_PREEMPT_VOLUNTARY=y
@@ -345,7 +345,7 @@
 CONFIG_X86_MCE_AMD=y
 CONFIG_X86_MCE_THRESHOLD=y
 # CONFIG_X86_MCE_INJECT is not set
-CONFIG_I8K=m
+# CONFIG_I8K is not set
 CONFIG_MICROCODE=m
 # CONFIG_MICROCODE_INTEL is not set
 CONFIG_MICROCODE_AMD=y
@@ -359,8 +359,8 @@
 CONFIG_K8_NUMA=y
 CONFIG_X86_64_ACPI_NUMA=y
 CONFIG_NODES_SPAN_OTHER_NODES=y
-CONFIG_NUMA_EMU=y
-CONFIG_NODES_SHIFT=9
+# CONFIG_NUMA_EMU is not set
+CONFIG_NODES_SHIFT=6
 CONFIG_ARCH_PROC_KCORE_TEXT=y
 CONFIG_ARCH_SPARSEMEM_DEFAULT=y
 CONFIG_ARCH_SPARSEMEM_ENABLE=y
@@ -377,7 +377,7 @@
 CONFIG_SPARSEMEM_VMEMMAP=y
 # CONFIG_MEMORY_HOTPLUG is not set
 CONFIG_PAGEFLAGS_EXTENDED=y
-CONFIG_SPLIT_PTLOCK_CPUS=4
+CONFIG_SPLIT_PTLOCK_CPUS=999999
 CONFIG_MIGRATION=y
 CONFIG_PHYS_ADDR_T_64BIT=y
 CONFIG_ZONE_DMA_FLAG=1
@@ -387,8 +387,7 @@
 CONFIG_KSM=y
 CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
 CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
-CONFIG_MEMORY_FAILURE=y
-CONFIG_HWPOISON_INJECT=y
+# CONFIG_MEMORY_FAILURE is not set
 CONFIG_X86_CHECK_BIOS_CORRUPTION=y
 CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
 CONFIG_X86_RESERVE_LOW_64K=y
@@ -398,7 +397,7 @@
 CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
 CONFIG_X86_PAT=y
 CONFIG_ARCH_USES_PG_UNCACHED=y
-CONFIG_EFI=y
+# CONFIG_EFI is not set
 CONFIG_SECCOMP=y
 CONFIG_CC_STACKPROTECTOR=y
 # CONFIG_HZ_100 is not set
@@ -414,7 +413,7 @@
 CONFIG_RELOCATABLE=y
 CONFIG_PHYSICAL_ALIGN=0x1000000
 CONFIG_HOTPLUG_CPU=y
-CONFIG_COMPAT_VDSO=y
+# CONFIG_COMPAT_VDSO is not set
 # CONFIG_CMDLINE_BOOL is not set
 CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
 CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID=y
@@ -435,17 +434,17 @@
 CONFIG_PM_RUNTIME=y
 CONFIG_ACPI=y
 CONFIG_ACPI_SLEEP=y
-CONFIG_ACPI_PROCFS=y
-CONFIG_ACPI_PROCFS_POWER=y
+# CONFIG_ACPI_PROCFS is not set
+# CONFIG_ACPI_PROCFS_POWER is not set
 CONFIG_ACPI_POWER_METER=m
 CONFIG_ACPI_SYSFS_POWER=y
-CONFIG_ACPI_PROC_EVENT=y
+# CONFIG_ACPI_PROC_EVENT is not set
 # CONFIG_ACPI_AC is not set
 # CONFIG_ACPI_BATTERY is not set
 CONFIG_ACPI_BUTTON=m
 CONFIG_ACPI_VIDEO=m
 CONFIG_ACPI_FAN=m
-CONFIG_ACPI_DOCK=y
+# CONFIG_ACPI_DOCK is not set
 CONFIG_ACPI_PROCESSOR=m
 CONFIG_ACPI_HOTPLUG_CPU=y
 CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
@@ -530,13 +529,11 @@
 CONFIG_K8_NB=y
 # CONFIG_PCCARD is not set
 CONFIG_HOTPLUG_PCI=m
-CONFIG_HOTPLUG_PCI_FAKE=m
+# CONFIG_HOTPLUG_PCI_FAKE is not set
 CONFIG_HOTPLUG_PCI_ACPI=m
-CONFIG_HOTPLUG_PCI_ACPI_IBM=m
-CONFIG_HOTPLUG_PCI_CPCI=y
-CONFIG_HOTPLUG_PCI_CPCI_ZT5550=m
-CONFIG_HOTPLUG_PCI_CPCI_GENERIC=m
-CONFIG_HOTPLUG_PCI_SHPC=m
+# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
+# CONFIG_HOTPLUG_PCI_CPCI is not set
+# CONFIG_HOTPLUG_PCI_SHPC is not set
 
 #
 # Executable file formats / Emulations
@@ -875,30 +872,15 @@
 CONFIG_RDS_TCP=m
 # CONFIG_RDS_DEBUG is not set
 # CONFIG_TIPC is not set
-CONFIG_ATM=m
-CONFIG_ATM_CLIP=m
-# CONFIG_ATM_CLIP_NO_ICMP is not set
-CONFIG_ATM_LANE=m
-CONFIG_ATM_MPOA=m
-CONFIG_ATM_BR2684=m
-# CONFIG_ATM_BR2684_IPFILTER is not set
+# CONFIG_ATM is not set
 CONFIG_STP=m
 CONFIG_BRIDGE=m
-CONFIG_NET_DSA=y
-CONFIG_NET_DSA_TAG_DSA=y
-CONFIG_NET_DSA_TAG_EDSA=y
-CONFIG_NET_DSA_TAG_TRAILER=y
-CONFIG_NET_DSA_MV88E6XXX=y
-CONFIG_NET_DSA_MV88E6060=y
-CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
-CONFIG_NET_DSA_MV88E6131=y
-CONFIG_NET_DSA_MV88E6123_61_65=y
+# CONFIG_NET_DSA is not set
 # CONFIG_VLAN_8021Q is not set
 # CONFIG_DECNET is not set
 CONFIG_LLC=m
 CONFIG_LLC2=m
-CONFIG_IPX=m
-CONFIG_IPX_INTERN=y
+# CONFIG_IPX is not set
 # CONFIG_ATALK is not set
 # CONFIG_X25 is not set
 # CONFIG_LAPB is not set
@@ -914,7 +896,6 @@
 CONFIG_NET_SCH_CBQ=m
 CONFIG_NET_SCH_HTB=m
 CONFIG_NET_SCH_HFSC=m
-CONFIG_NET_SCH_ATM=m
 CONFIG_NET_SCH_PRIO=m
 CONFIG_NET_SCH_MULTIQ=m
 CONFIG_NET_SCH_RED=m
@@ -978,7 +959,7 @@
 CONFIG_AX25=m
 CONFIG_AX25_DAMA_SLAVE=y
 CONFIG_NETROM=m
-CONFIG_ROSE=m
+# CONFIG_ROSE is not set
 
 #
 # AX.25 network device drivers
@@ -1313,7 +1294,7 @@
 # CONFIG_ICS932S401 is not set
 CONFIG_ENCLOSURE_SERVICES=m
 # CONFIG_CS5535_MFGPT is not set
-CONFIG_HP_ILO=m
+# CONFIG_HP_ILO is not set
 # CONFIG_ISL29003 is not set
 # CONFIG_DS1682 is not set
 # CONFIG_C2PORT is not set
@@ -1428,7 +1409,7 @@
 #
 CONFIG_SCSI_SPI_ATTRS=m
 CONFIG_SCSI_FC_ATTRS=m
-CONFIG_SCSI_FC_TGT_ATTRS=y
+# CONFIG_SCSI_FC_TGT_ATTRS is not set
 CONFIG_SCSI_ISCSI_ATTRS=m
 CONFIG_SCSI_SAS_ATTRS=m
 CONFIG_SCSI_SAS_LIBSAS=m
@@ -1439,7 +1420,6 @@
 CONFIG_SCSI_SRP_TGT_ATTRS=y
 CONFIG_SCSI_LOWLEVEL=y
 CONFIG_ISCSI_TCP=m
-# CONFIG_SCSI_CXGB3_ISCSI is not set
 # CONFIG_SCSI_BNX2_ISCSI is not set
 # CONFIG_BE2ISCSI is not set
 # CONFIG_BLK_DEV_3W_XXXX_RAID is not set
@@ -1464,38 +1444,30 @@
 # CONFIG_SCSI_HPTIOP is not set
 # CONFIG_SCSI_BUSLOGIC is not set
 CONFIG_VMWARE_PVSCSI=m
-CONFIG_LIBFC=m
+# CONFIG_LIBFC is not set
 # CONFIG_LIBFCOE is not set
 # CONFIG_FCOE is not set
 # CONFIG_FCOE_FNIC is not set
 # CONFIG_SCSI_DMX3191D is not set
-CONFIG_SCSI_EATA=m
-CONFIG_SCSI_EATA_TAGGED_QUEUE=y
-CONFIG_SCSI_EATA_LINKED_COMMANDS=y
-CONFIG_SCSI_EATA_MAX_TAGS=16
-CONFIG_SCSI_FUTURE_DOMAIN=m
-CONFIG_SCSI_GDTH=m
-CONFIG_SCSI_IPS=m
-CONFIG_SCSI_INITIO=m
+# CONFIG_SCSI_EATA is not set
+# CONFIG_SCSI_FUTURE_DOMAIN is not set
+# CONFIG_SCSI_GDTH is not set
+# CONFIG_SCSI_IPS is not set
+# CONFIG_SCSI_INITIO is not set
 # CONFIG_SCSI_INIA100 is not set
-CONFIG_SCSI_STEX=m
-CONFIG_SCSI_SYM53C8XX_2=m
-CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
-CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
-CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
-CONFIG_SCSI_SYM53C8XX_MMIO=y
+# CONFIG_SCSI_STEX is not set
+# CONFIG_SCSI_SYM53C8XX_2 is not set
 # CONFIG_SCSI_IPR is not set
-CONFIG_SCSI_QLOGIC_1280=m
-CONFIG_SCSI_QLA_FC=m
-CONFIG_SCSI_QLA_ISCSI=m
-CONFIG_SCSI_LPFC=m
-# CONFIG_SCSI_LPFC_DEBUG_FS is not set
-CONFIG_SCSI_DC395x=m
-CONFIG_SCSI_DC390T=m
-CONFIG_SCSI_DEBUG=m
+# CONFIG_SCSI_QLOGIC_1280 is not set
+# CONFIG_SCSI_QLA_FC is not set
+# CONFIG_SCSI_QLA_ISCSI is not set
+# CONFIG_SCSI_LPFC is not set
+# CONFIG_SCSI_DC395x is not set
+# CONFIG_SCSI_DC390T is not set
+# CONFIG_SCSI_DEBUG is not set
 # CONFIG_SCSI_PMCRAID is not set
 # CONFIG_SCSI_PM8001 is not set
-CONFIG_SCSI_SRP=m
+# CONFIG_SCSI_SRP is not set
 # CONFIG_SCSI_BFA_FC is not set
 # CONFIG_SCSI_DH is not set
 # CONFIG_SCSI_OSD_INITIATOR is not set
@@ -1659,9 +1631,9 @@
 CONFIG_MDIO_GPIO=m
 CONFIG_NET_ETHERNET=y
 CONFIG_MII=m
-CONFIG_HAPPYMEAL=m
-CONFIG_SUNGEM=m
-CONFIG_CASSINI=m
+# CONFIG_HAPPYMEAL is not set
+# CONFIG_SUNGEM is not set
+# CONFIG_CASSINI is not set
 CONFIG_NET_VENDOR_3COM=y
 CONFIG_VORTEX=m
 CONFIG_TYPHOON=m
@@ -1679,7 +1651,7 @@
 CONFIG_WINBOND_840=m
 CONFIG_DM9102=m
 CONFIG_ULI526X=m
-CONFIG_HP100=m
+# CONFIG_HP100 is not set
 # CONFIG_IBM_NEW_EMAC_ZMII is not set
 # CONFIG_IBM_NEW_EMAC_RGMII is not set
 # CONFIG_IBM_NEW_EMAC_TAH is not set
@@ -1691,84 +1663,57 @@
 CONFIG_PCNET32=m
 CONFIG_AMD8111_ETH=m
 CONFIG_ADAPTEC_STARFIRE=m
-CONFIG_B44=m
-CONFIG_B44_PCI_AUTOSELECT=y
-CONFIG_B44_PCICORE_AUTOSELECT=y
-CONFIG_B44_PCI=y
+# CONFIG_B44 is not set
 CONFIG_FORCEDETH=m
 CONFIG_FORCEDETH_NAPI=y
 CONFIG_E100=m
 # CONFIG_FEALNX is not set
-CONFIG_NATSEMI=m
-CONFIG_NE2K_PCI=m
+# CONFIG_NATSEMI is not set
+# CONFIG_NE2K_PCI is not set
 CONFIG_8139CP=m
 CONFIG_8139TOO=m
 # CONFIG_8139TOO_PIO is not set
 # CONFIG_8139TOO_TUNE_TWISTER is not set
 CONFIG_8139TOO_8129=y
 # CONFIG_8139_OLD_RX_RESET is not set
-CONFIG_R6040=m
-CONFIG_SIS900=m
-CONFIG_EPIC100=m
+# CONFIG_R6040 is not set
+# CONFIG_SIS900 is not set
+# CONFIG_EPIC100 is not set
 # CONFIG_SMSC9420 is not set
-CONFIG_SUNDANCE=m
-# CONFIG_SUNDANCE_MMIO is not set
-CONFIG_TLAN=m
+# CONFIG_SUNDANCE is not set
+# CONFIG_TLAN is not set
 # CONFIG_KS8842 is not set
 # CONFIG_KS8851_MLL is not set
-CONFIG_VIA_RHINE=m
-# CONFIG_VIA_RHINE_MMIO is not set
-CONFIG_SC92031=m
-CONFIG_ATL2=m
+# CONFIG_VIA_RHINE is not set
+# CONFIG_SC92031 is not set
+# CONFIG_ATL2 is not set
 CONFIG_NETDEV_1000=y
-CONFIG_ACENIC=m
-# CONFIG_ACENIC_OMIT_TIGON_I is not set
+# CONFIG_ACENIC is not set
 CONFIG_DL2K=m
 CONFIG_E1000=m
 CONFIG_E1000E=m
 CONFIG_IP1000=m
 CONFIG_IGB=m
 # CONFIG_IGBVF is not set
-CONFIG_NS83820=m
-CONFIG_HAMACHI=m
-CONFIG_YELLOWFIN=m
+# CONFIG_NS83820 is not set
+# CONFIG_HAMACHI is not set
+# CONFIG_YELLOWFIN is not set
 CONFIG_R8169=m
-CONFIG_SIS190=m
+# CONFIG_SIS190 is not set
 CONFIG_SKGE=m
 # CONFIG_SKGE_DEBUG is not set
 CONFIG_SKY2=m
 # CONFIG_SKY2_DEBUG is not set
-CONFIG_VIA_VELOCITY=m
+# CONFIG_VIA_VELOCITY is not set
 CONFIG_TIGON3=m
 CONFIG_BNX2=m
 CONFIG_CNIC=m
-CONFIG_QLA3XXX=m
+# CONFIG_QLA3XXX is not set
 CONFIG_ATL1=m
 CONFIG_ATL1E=m
 CONFIG_ATL1C=m
 CONFIG_JME=m
-CONFIG_NETDEV_10000=y
-CONFIG_MDIO=m
-CONFIG_CHELSIO_T1=m
-CONFIG_CHELSIO_T1_1G=y
-CONFIG_CHELSIO_T3_DEPENDS=y
-CONFIG_CHELSIO_T3=m
-# CONFIG_ENIC is not set
-CONFIG_IXGBE=m
-CONFIG_IXGB=m
-CONFIG_S2IO=m
-# CONFIG_VXGE is not set
-CONFIG_MYRI10GE=m
-CONFIG_NETXEN_NIC=m
-CONFIG_NIU=m
-# CONFIG_MLX4_EN is not set
-# CONFIG_MLX4_CORE is not set
-CONFIG_TEHUTI=m
-CONFIG_BNX2X=m
-# CONFIG_QLGE is not set
-CONFIG_SFC=m
-CONFIG_SFC_MTD=y
-# CONFIG_BE2NET is not set
+# CONFIG_NETDEV_10000 is not set
 # CONFIG_TR is not set
 CONFIG_WLAN=y
 CONFIG_LIBERTAS_THINFIRM=m
@@ -1841,22 +1786,13 @@
 CONFIG_IWL5000=y
 CONFIG_IWL3945=m
 CONFIG_IWL3945_SPECTRUM_MEASUREMENT=y
-CONFIG_IWM=m
-# CONFIG_IWM_DEBUG is not set
+# CONFIG_IWM is not set
 CONFIG_LIBERTAS=m
 CONFIG_LIBERTAS_USB=m
 CONFIG_LIBERTAS_SDIO=m
 # CONFIG_LIBERTAS_DEBUG is not set
-CONFIG_HERMES=m
-CONFIG_HERMES_CACHE_FW_ON_INIT=y
-CONFIG_PLX_HERMES=m
-CONFIG_TMD_HERMES=m
-CONFIG_NORTEL_HERMES=m
-CONFIG_PCI_HERMES=m
-CONFIG_P54_COMMON=m
-CONFIG_P54_USB=m
-CONFIG_P54_PCI=m
-CONFIG_P54_LEDS=y
+# CONFIG_HERMES is not set
+# CONFIG_P54_COMMON is not set
 CONFIG_RT2X00=m
 CONFIG_RT2400PCI=m
 CONFIG_RT2500PCI=m
@@ -1920,7 +1856,6 @@
 CONFIG_USB_HSO=m
 # CONFIG_USB_NET_INT51X1 is not set
 # CONFIG_WAN is not set
-# CONFIG_ATM_DRIVERS is not set
 CONFIG_IEEE802154_DRIVERS=m
 # CONFIG_IEEE802154_FAKEHARD is not set
 CONFIG_XEN_NETDEV_FRONTEND=y
@@ -1935,7 +1870,6 @@
 CONFIG_PPP_BSDCOMP=m
 CONFIG_PPP_MPPE=m
 CONFIG_PPPOE=m
-CONFIG_PPPOATM=m
 CONFIG_PPPOL2TP=m
 CONFIG_SLIP=m
 CONFIG_SLIP_COMPRESSED=y
@@ -2007,31 +1941,29 @@
 CONFIG_MOUSE_GPIO=m
 # CONFIG_MOUSE_SYNAPTICS_I2C is not set
 CONFIG_INPUT_JOYSTICK=y
-CONFIG_JOYSTICK_ANALOG=m
-CONFIG_JOYSTICK_A3D=m
-CONFIG_JOYSTICK_ADI=m
-CONFIG_JOYSTICK_COBRA=m
-CONFIG_JOYSTICK_GF2K=m
-CONFIG_JOYSTICK_GRIP=m
-CONFIG_JOYSTICK_GRIP_MP=m
-CONFIG_JOYSTICK_GUILLEMOT=m
-CONFIG_JOYSTICK_INTERACT=m
-CONFIG_JOYSTICK_SIDEWINDER=m
-CONFIG_JOYSTICK_TMDC=m
+# CONFIG_JOYSTICK_ANALOG is not set
+# CONFIG_JOYSTICK_A3D is not set
+# CONFIG_JOYSTICK_ADI is not set
+# CONFIG_JOYSTICK_COBRA is not set
+# CONFIG_JOYSTICK_GF2K is not set
+# CONFIG_JOYSTICK_GRIP is not set
+# CONFIG_JOYSTICK_GRIP_MP is not set
+# CONFIG_JOYSTICK_GUILLEMOT is not set
+# CONFIG_JOYSTICK_INTERACT is not set
+# CONFIG_JOYSTICK_SIDEWINDER is not set
+# CONFIG_JOYSTICK_TMDC is not set
 CONFIG_JOYSTICK_IFORCE=m
 CONFIG_JOYSTICK_IFORCE_USB=y
 CONFIG_JOYSTICK_IFORCE_232=y
-CONFIG_JOYSTICK_WARRIOR=m
-CONFIG_JOYSTICK_MAGELLAN=m
-CONFIG_JOYSTICK_SPACEORB=m
-CONFIG_JOYSTICK_SPACEBALL=m
-CONFIG_JOYSTICK_STINGER=m
-CONFIG_JOYSTICK_TWIDJOY=m
-CONFIG_JOYSTICK_ZHENHUA=m
+# CONFIG_JOYSTICK_WARRIOR is not set
+# CONFIG_JOYSTICK_MAGELLAN is not set
+# CONFIG_JOYSTICK_SPACEORB is not set
+# CONFIG_JOYSTICK_SPACEBALL is not set
+# CONFIG_JOYSTICK_STINGER is not set
+# CONFIG_JOYSTICK_TWIDJOY is not set
+# CONFIG_JOYSTICK_ZHENHUA is not set
 CONFIG_JOYSTICK_JOYDUMP=m
-CONFIG_JOYSTICK_XPAD=m
-CONFIG_JOYSTICK_XPAD_FF=y
-CONFIG_JOYSTICK_XPAD_LEDS=y
+# CONFIG_JOYSTICK_XPAD is not set
 CONFIG_INPUT_TABLET=y
 CONFIG_TABLET_USB_ACECAD=m
 CONFIG_TABLET_USB_AIPTEK=m
@@ -2216,7 +2148,7 @@
 # I2C system bus drivers (mostly embedded / system-on-chip)
 #
 CONFIG_I2C_GPIO=m
-CONFIG_I2C_OCORES=m
+# CONFIG_I2C_OCORES is not set
 # CONFIG_I2C_SIMTEC is not set
 
 #
@@ -2277,7 +2209,7 @@
 # AC97 GPIO expanders:
 #
 CONFIG_W1=m
-CONFIG_W1_CON=y
+# CONFIG_W1_CON is not set
 
 #
 # 1-wire Bus Masters
@@ -2290,11 +2222,10 @@
 #
 # 1-wire Slaves
 #
-CONFIG_W1_SLAVE_THERM=m
-CONFIG_W1_SLAVE_SMEM=m
+# CONFIG_W1_SLAVE_THERM is not set
+# CONFIG_W1_SLAVE_SMEM is not set
 # CONFIG_W1_SLAVE_DS2431 is not set
-CONFIG_W1_SLAVE_DS2433=m
-CONFIG_W1_SLAVE_DS2433_CRC=y
+# CONFIG_W1_SLAVE_DS2433 is not set
 CONFIG_W1_SLAVE_DS2760=m
 # CONFIG_W1_SLAVE_BQ27000 is not set
 CONFIG_POWER_SUPPLY=y
@@ -2463,8 +2394,7 @@
 # Multifunction device drivers
 #
 # CONFIG_MFD_CORE is not set
-CONFIG_MFD_SM501=m
-CONFIG_MFD_SM501_GPIO=y
+# CONFIG_MFD_SM501 is not set
 # CONFIG_HTC_PASIC3 is not set
 # CONFIG_UCB1400_CORE is not set
 # CONFIG_TPS65010 is not set
@@ -2861,7 +2791,6 @@
 CONFIG_FB_VGA16=m
 CONFIG_FB_UVESA=m
 CONFIG_FB_VESA=y
-CONFIG_FB_EFI=y
 # CONFIG_FB_N411 is not set
 # CONFIG_FB_HGA is not set
 # CONFIG_FB_S1D13XXX is not set
@@ -2889,7 +2818,6 @@
 # CONFIG_FB_PM3 is not set
 # CONFIG_FB_CARMINE is not set
 # CONFIG_FB_GEODE is not set
-# CONFIG_FB_SM501 is not set
 # CONFIG_FB_VIRTUAL is not set
 CONFIG_XEN_FBDEV_FRONTEND=m
 # CONFIG_FB_METRONOME is not set
@@ -2986,16 +2914,14 @@
 # CONFIG_SND_AU8830 is not set
 # CONFIG_SND_AW2 is not set
 # CONFIG_SND_AZT3328 is not set
-CONFIG_SND_BT87X=m
-# CONFIG_SND_BT87X_OVERCLOCK is not set
+# CONFIG_SND_BT87X is not set
 CONFIG_SND_CA0106=m
 # CONFIG_SND_CMIPCI is not set
-CONFIG_SND_OXYGEN_LIB=m
 # CONFIG_SND_OXYGEN is not set
 # CONFIG_SND_CS4281 is not set
 # CONFIG_SND_CS46XX is not set
 # CONFIG_SND_CS5530 is not set
-CONFIG_SND_CS5535AUDIO=m
+# CONFIG_SND_CS5535AUDIO is not set
 CONFIG_SND_CTXFI=m
 # CONFIG_SND_DARLA20 is not set
 # CONFIG_SND_GINA20 is not set
@@ -3049,7 +2975,7 @@
 CONFIG_SND_INTEL8X0=m
 # CONFIG_SND_INTEL8X0M is not set
 # CONFIG_SND_KORG1212 is not set
-CONFIG_SND_LX6464ES=m
+# CONFIG_SND_LX6464ES is not set
 # CONFIG_SND_MAESTRO3 is not set
 # CONFIG_SND_MIXART is not set
 # CONFIG_SND_NM256 is not set
@@ -3062,15 +2988,15 @@
 # CONFIG_SND_TRIDENT is not set
 CONFIG_SND_VIA82XX=m
 CONFIG_SND_VIA82XX_MODEM=m
-CONFIG_SND_VIRTUOSO=m
+# CONFIG_SND_VIRTUOSO is not set
 # CONFIG_SND_VX222 is not set
 # CONFIG_SND_YMFPCI is not set
 CONFIG_SND_USB=y
 CONFIG_SND_USB_AUDIO=m
-CONFIG_SND_USB_USX2Y=m
+# CONFIG_SND_USB_USX2Y is not set
 CONFIG_SND_USB_CAIAQ=m
 CONFIG_SND_USB_CAIAQ_INPUT=y
-CONFIG_SND_USB_US122L=m
+# CONFIG_SND_USB_US122L is not set
 CONFIG_SND_SOC=m
 CONFIG_SND_SOC_I2C_AND_SPI=m
 CONFIG_SND_SOC_ALL_CODECS=m
@@ -3347,11 +3273,6 @@
 # CONFIG_USB_TEST is not set
 CONFIG_USB_ISIGHTFW=m
 # CONFIG_USB_VST is not set
-CONFIG_USB_ATM=m
-CONFIG_USB_SPEEDTOUCH=m
-CONFIG_USB_CXACRU=m
-CONFIG_USB_UEAGLEATM=m
-CONFIG_USB_XUSBATM=m
 CONFIG_USB_GADGET=m
 # CONFIG_USB_GADGET_DEBUG is not set
 # CONFIG_USB_GADGET_DEBUG_FILES is not set
@@ -3550,12 +3471,7 @@
 #
 # on-CPU RTC drivers
 #
-CONFIG_DMADEVICES=y
-
-#
-# DMA Devices
-#
-# CONFIG_INTEL_IOATDMA is not set
+# CONFIG_DMADEVICES is not set
 CONFIG_AUXDISPLAY=y
 CONFIG_UIO=m
 CONFIG_UIO_CIF=m
@@ -3670,26 +3586,7 @@
 # CONFIG_SAMSUNG_LAPTOP is not set
 # CONFIG_STRIP is not set
 # CONFIG_FB_SM7XX is not set
-CONFIG_X86_PLATFORM_DEVICES=y
-# CONFIG_ACER_WMI is not set
-# CONFIG_ACERHDF is not set
-# CONFIG_ASUS_LAPTOP is not set
-# CONFIG_DELL_WMI is not set
-# CONFIG_FUJITSU_LAPTOP is not set
-# CONFIG_HP_WMI is not set
-# CONFIG_MSI_LAPTOP is not set
-# CONFIG_PANASONIC_LAPTOP is not set
-# CONFIG_COMPAL_LAPTOP is not set
-# CONFIG_SONY_LAPTOP is not set
-# CONFIG_THINKPAD_ACPI is not set
-# CONFIG_INTEL_MENLOW is not set
-# CONFIG_EEEPC_LAPTOP is not set
-CONFIG_ACPI_WMI=m
-# CONFIG_MSI_WMI is not set
-# CONFIG_ACPI_ASUS is not set
-# CONFIG_TOPSTAR_LAPTOP is not set
-# CONFIG_ACPI_TOSHIBA is not set
-# CONFIG_TOSHIBA_BT_RFKILL is not set
+# CONFIG_X86_PLATFORM_DEVICES is not set
 
 #
 # Firmware Drivers
@@ -3697,7 +3594,6 @@
 CONFIG_EDD=m
 # CONFIG_EDD_OFF is not set
 CONFIG_FIRMWARE_MEMMAP=y
-CONFIG_EFI_VARS=m
 # CONFIG_DELL_RBU is not set
 # CONFIG_DCDBAS is not set
 CONFIG_DMIID=y
@@ -3973,7 +3869,7 @@
 CONFIG_NLS_KOI8_U=m
 CONFIG_NLS_UTF8=m
 CONFIG_DLM=m
-# CONFIG_DLM_DEBUG is not set
+CONFIG_DLM_DEBUG=y
 
 #
 # Kernel hacking
@@ -3987,7 +3883,7 @@
 CONFIG_STRIP_ASM_SYMS=y
 CONFIG_UNUSED_SYMBOLS=y
 CONFIG_DEBUG_FS=y
-# CONFIG_HEADERS_CHECK is not set
+CONFIG_HEADERS_CHECK=y
 CONFIG_DEBUG_KERNEL=y
 # CONFIG_DEBUG_SHIRQ is not set
 # CONFIG_DETECT_SOFTLOCKUP is not set
@@ -4003,13 +3899,16 @@
 CONFIG_DEBUG_KMEMLEAK=y
 CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE=400
 CONFIG_DEBUG_KMEMLEAK_TEST=m
-# CONFIG_DEBUG_RT_MUTEXES is not set
-# CONFIG_RT_MUTEX_TESTER is not set
-# CONFIG_DEBUG_SPINLOCK is not set
-# CONFIG_DEBUG_MUTEXES is not set
-# CONFIG_DEBUG_LOCK_ALLOC is not set
+CONFIG_DEBUG_RT_MUTEXES=y
+CONFIG_DEBUG_PI_LIST=y
+CONFIG_RT_MUTEX_TESTER=y
+CONFIG_DEBUG_SPINLOCK=y
+CONFIG_DEBUG_MUTEXES=y
+CONFIG_DEBUG_LOCK_ALLOC=y
 # CONFIG_PROVE_LOCKING is not set
+CONFIG_LOCKDEP=y
 # CONFIG_LOCK_STAT is not set
+# CONFIG_DEBUG_LOCKDEP is not set
 # CONFIG_DEBUG_SPINLOCK_SLEEP is not set
 # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
 CONFIG_STACKTRACE=y
@@ -4074,6 +3973,7 @@
 # CONFIG_MMIOTRACE is not set
 CONFIG_RING_BUFFER_BENCHMARK=m
 CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
+# CONFIG_BUILD_DOCSRC is not set
 # CONFIG_DYNAMIC_DEBUG is not set
 # CONFIG_DMA_API_DEBUG is not set
 # CONFIG_SAMPLES is not set
@@ -4135,11 +4035,11 @@
 CONFIG_IMA_MEASURE_PCR_IDX=10
 CONFIG_IMA_AUDIT=y
 CONFIG_IMA_LSM_RULES=y
-CONFIG_DEFAULT_SECURITY_SELINUX=y
+# CONFIG_DEFAULT_SECURITY_SELINUX is not set
 # CONFIG_DEFAULT_SECURITY_SMACK is not set
-# CONFIG_DEFAULT_SECURITY_TOMOYO is not set
+CONFIG_DEFAULT_SECURITY_TOMOYO=y
 # CONFIG_DEFAULT_SECURITY_DAC is not set
-CONFIG_DEFAULT_SECURITY="selinux"
+CONFIG_DEFAULT_SECURITY="tomoyo"
 CONFIG_XOR_BLOCKS=m
 CONFIG_ASYNC_CORE=m
 CONFIG_ASYNC_MEMCPY=m
@@ -4297,5 +4197,4 @@
 CONFIG_HAS_IOPORT=y
 CONFIG_HAS_DMA=y
 CONFIG_CHECK_SIGNATURE=y
-CONFIG_CPUMASK_OFFSTACK=y
 CONFIG_NLATTR=y

--------------070800050007030907090502--

