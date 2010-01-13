Return-Path: <linux-kernel-owner+w=401wt.eu-S1753769Ab0AMFos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab0AMFos (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 00:44:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486Ab0AMFos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 00:44:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37625 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753086Ab0AMFoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 00:44:46 -0500
Date: Tue, 12 Jan 2010 21:44:43 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.33-rc4
Message-ID: <alpine.LFD.2.00.1001122139411.17145@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hmm. Odd release. Something like 40% of the patches are in DRM (mostly 
nouveau and radeon, both staging, so it's a bit less scary than it sounds. 
But there's a noticeable i915 component too). That's all pretty unusual, 
afaik.

There's some boot loader compression updates too that have already turned 
out to be a bit painful on non-x86/arm platforms (but we'll sort it out), 
various arch updates (mips, arm, mn10300), networking, and filesystems.

Go forth and compile,

		Linus

---
Abhijit Pagare (1):
      ARM: OMAP3: PM: Fix the Invalid CM_CLKSTCTRL reg access.

Adam Jackson (2):
      drm/edid: Skip empty CVT codepoints
      drm/edid: Fix CVT width/height decode

Adrian Hunter (2):
      mmc_block: fix queue cleanup
      mmc: allow for MMC v4.4

Al Viro (1):
      mn10300: fix several bogus includes on abs2305

Alan Carvalho de Assis (1):
      mx27: mxt_td60: Remove not used UART pins

Albin Tonnerre (4):
      lib: add support for LZO-compressed kernels
      arm: add support for LZO-compressed kernels
      x86: add support for LZO-compressed kernels
      Add LZO compression support for initramfs and old-style initrd

Alex Deucher (10):
      drm/radeon/kms: fallback to default connector table
      drm/radeon/kms: add primary dac adj values table
      drm/radeon/kms: add missing breaks in i2c and ss lookups
      drm/radeon/kms: fix typo in atom connector type handling
      drm/radeon/kms: whitespace changes to ObjectID.h
      drm/radeon/kms: pull in the latest upstream ObjectID.h changes
      drm: Add eDP connector type
      drm/radeon/kms: add support for eDP (embedded DisplayPort)
      drm/radeon/kms: detect sideport memory on IGP chips
      drm/radeon/kms: add additional safe regs for r4xx/rs6xx and r5xx

Alexander Beregalov (2):
      pcmcia: ncmlan_cs: remove odd bracket
      drm/radeon: mkregtable.c: close a file before exit

Alexander Shishkin (1):
      omap2/3: make serial_in_override() address the right uart port

Amit Kumar Salecha (4):
      netxen: fix tx ring memory leak
      netxen: fix smatch warning
      netxen: fix set mac addr
      netxen: update version to 4.0.72

Ananth N Mavinakayanahalli (1):
      Revert "x86, apic: Use logical flat on intel with <= 8 logical cpus"

Andi Kleen (1):
      kernel/signal.c: fix kernel information leak with print-fatal-signals=1

Andrea Arcangeli (1):
      mm: hugetlb: fix clear_huge_page()

Andreas Fenkart (1):
      mm: make totalhigh_pages unsigned long

Andrew Lutomirski (1):
      drm/i915: Fix RC6 suspend/resume

Andrew Morton (3):
      net/sctp/socket.c: squish warning
      drm/i915: fix unused var
      percpu: avoid calling __pcpu_ptr_to_addr(NULL)

Andrew Vasquez (1):
      [SCSI] qla2xxx: Extend base EEH support in qla2xxx.

Anil Ravindranath (1):
      [SCSI] pmcraid: fix to avoid twice scsi_dma_unmap for a command

Anirban Chakraborty (1):
      [SCSI] qla2xxx: Fix for a multiqueue bug in CPU affinity mode

Anisse Astier (1):
      hp-wmi: remove double free caused by merge conflict

Anna Lemehova (1):
      mmc_block: add dev_t initialization check

Anton Blanchard (2):
      [IA64] cpumask_of_node() should handle -1 as a node
      MIPS: cpumask_of_node() should handle -1 as a node

Anton Vorontsov (4):
      phylib: Fix deadlock on resume
      phylib: Properly reinitialize PHYs after hibernation
      ucc_geth: Fix netdev watchdog triggering on suspend
      fsl_pq_mdio: Fix iomem unmapping for non-eTSEC2.0 controllers

Arjan van de Ven (1):
      ipvs: Add boundary check on ioctl arguments

Atsushi Nemoto (1):
      MIPS: TXx9: Cleanup builtin-cmdline processing

Avi Kivity (1):
      core, x86: make LIST_POISON less deadly

Bahadir Balban (1):
      ARM: 5858/1: Remove unused vma_vm_flags macro from v7wbi_flush_user_tlb_range

Baruch Siach (3):
      mx25: s/NO_PAD_CTL/NO_PAD_CTRL/
      mx25: add support for FEC on i.MX25
      mx25: pdk: add platform code for FEC support

Ben Dooks (1):
      ARM: S3C64XX: Fix possible clock look in EPLL and MPLL clock chains

Ben Hutchings (4):
      via-velocity: Give RX descriptors to the NIC later on open or MTU change
      modules: Skip empty sections when exporting section notes
      dmfe/tulip: Let dmfe handle DM910x except for SPARC on-board chips
      Documentation/3c509: document ethtool support

Ben Skeggs (9):
      drm/nv50: ignore vbios table's claim to the contrary if EDID says >8bpc
      drm/nouveau: fix handling of fbcon colours in 8bpp
      drm/nouveau: remove unused nouveau_channel_idle() function
      drm/nv50: restore correct cache1 get/put address on fifoctx load
      drm/nouveau: have ttm's fault handler called directly
      drm/nv50: prevent a possible ctxprog hang
      drm/nv04: differentiate between nv04/nv05
      drm/nouveau: use dma.max rather than pushbuf size for checking GET validity
      drm/nouveau: initialise DMA tracking parameters earlier

Bernard Pidoux F6BVP (1):
      rose_loopback_timer sets VC number <= ROSE_DEFAULT_MAXVC

Bjorn Helgaas (3):
      agp/hp: fixup hp agp after ACPI changes
      agp/hp: fail gracefully if we don't find an IOC
      mn10300: use generic pci_enable_resources()

Boaz Harrosh (2):
      exofs: fix pnfs_osd re-definitions in pre-pnfs trees
      exofs: simple_write_end does not mark_inode_dirty

Bruce Allan (5):
      e1000e: call pci_save_state() after pci_restore_state()
      e1000e: don't accumulate PHY statistics on PHY read failure
      e1000e: perform 10/100 adaptive IFS only on parts that support it
      e1000e: e1000e_enable_tx_pkt_filtering() returns wrong value
      e1000e: fix and commonize code for setting the receive address registers

Bryn M. Reeves (1):
      [SCSI] megaraid_sas: remove sysfs poll_mode_io world writeable permissions

Chris Wilson (2):
      drm/i915: Hold struct mutex whilst pinning power context bo.
      drm/i915: Permit pinning whilst the device is 'suspended'

Christoph Hellwig (3):
      nfsd: make sure data is on disk before calling ->fsync
      xfs: use DECLARE_EVENT_CLASS
      xfs: fix timestamp handling in xfs_setattr

Clemens Ladisch (1):
      hwmon: (k10temp) Blacklist more family 10h processors

Colin Tuckley (1):
      ARM: 5873/1: ARM: Fix the reset logic for ARM RealView boards

Corbin Simpson (1):
      drm/radeon/kms: Workaround RV410/R420 CP errata (V3)

Cory Maccarrone (4):
      omap: gpio: Simultaneously requested rising and falling edge
      omap1: Add 7xx clocks and pin muxes for SPI
      OMAP1 clock: Add missing clocks for OMAP 7xx
      OMAP1 clock: remove __initdata from struct clk_functions to prevent crash

Cyril Hrubis (1):
      [ARM] pxa: fix strange characters in zaurus gpio .desc

Dan Carpenter (3):
      hamradio: avoid null deref v3
      rrunner: fix buffer overflow
      sound: oss: off by one bug

Daniel T Chen (2):
      ALSA: atiixp: Specify codec for Foxconn RC4107MA-RS2
      ALSA: ac97: Add Dell Dimension 2400 to Headphone/Line Jack Sense blacklist

Daniel Vetter (1):
      drm/i915: fix order of fence release wrt flushing

Darren Jenkins (5):
      drm/radeon/radeon_connectors.c: add a NULL test before dereference
      drm/radeon/radeon_fence.c: move a dereference below the NULL test
      drm/radeon/radeon_device.c: move a dereference below a NULL test
      gpu/drm/radeon/radeon_irq.c: move a dereference below a NULL test
      drm/radeon: fix a couple of array index errors

Dave Airlie (2):
      drm/kms/fb: check for depth changes from userspace for resizing.
      drm: reduce WARN_ON to a printk.

Dave Anderson (1):
      cgroups: fix 2.6.32 regression causing BUG_ON() in cgroup_diput()

Dave Chinner (4):
      xfs: kill some warnings on i386 builds
      xfs: Don't flush stale inodes
      xfs: Ensure we force all busy extents in range to disk
      lib: Introduce generic list_sort function

Dave Jones (1):
      remove my email address from checkpatch.

Dave Liu (1):
      ucc_geth: Fix the wrong the Rx/Tx FIFO size

David Daney (3):
      MIPS: Cleanup forgotten label_module_alloc in tlbex.c
      MIPS: Octeon: Add sched_clock() to csrc-octeon.c
      MIPS: Octeon: Use non-overflowing arithmetic in sched_clock

David Howells (5):
      mn10300: wire up missing new syscalls
      mn10300: use KERN_ERR not KERN_ERROR
      mn10300: insert PCI root bus resources for the ASB2305 devel motherboard
      mn10300: make the ASB2305's PCnet32 NIC work by using the PCI bridge's SRAM
      mn10300: update the ASB2303 defconfig

David John (2):
      PCI: Check the node argument passed to cpumask_of_node
      drm: Keep disabled outputs disabled after suspend / resume

David S. Miller (1):
      cxgb3i: Fix flags test.

David VomLehn (1):
      MIPS: PowerTV: Remove extra r4k_clockevent_init() call

Denis Kirjanov (1):
      vxge: use pci_dma_mapping_error to test return value

Duane Grigsby (1):
      [SCSI] qla2xxx: Added to EEH support.

Ed Lin (1):
      [SCSI] stex: fix scan of nonexistent lun

Eli Cohen (1):
      mlx4_core: Fix cleanup in __mlx4_init_one() error path

Eric Anholt (1):
      drm/i915: In the debugfs interface, unmap our address instead of the page's.

Eric Miao (4):
      [ARM] pxafb: fix building issue of incorrect reference
      [ARM] pxa/poodle: fix incorrect 'gpio_card_detect' of MMC
      [ARM] pxa: update pwm_backlight->notify() to include missed 'struct device *'
      [ARM] pxa: fix compiler warnings of unused variable 'id' in cpu_is_pxa9*()

Felipe Balbi (1):
      OMAP2xxx clock: clk2xxx.c doesn't compile if CPUFREQ is enabled

Florian Fainelli (3):
      ipvs: ip_vs_wrr.c: use lib/gcd.c
      .gitignore: ignore vmlinuz
      MIPS: BCM63xx: Fix whitespace damaged board_bcm963xx.c

Florian Westphal (1):
      netfilter: ebtables: enforce CAP_NET_ADMIN

Francisco Jerez (13):
      drm/nouveau: Add cache_flush/pull fifo engine functions.
      drm/nouveau: Pre-G80 tiling support.
      drm/nouveau: Make the MM aware of pre-G80 tiling.
      drm/i2c/ch7006: Drop build time dependency to nouveau.
      drm/nouveau: Fix "general protection fault" in the flipd/flips eviction path.
      drm/nouveau: No need to force evict=true when swapping evicted BOs back in.
      drm/nouveau: Drop redundant placement initialization.
      drm/nouveau: Clean up the nv17-nv4x load detection code a bit.
      drm/nouveau: Implement nv42-nv43 TV load detection.
      drm/nouveau: Don't skip card take down on nv0x.
      drm/nouveau: Allocate a per-channel instance of NV_SW.
      drm/nouveau: Use the software object for fencing.
      drm/nv04: Context switching fixes.

Frederic Weisbecker (6):
      reiserfs: Fix mistake in down_write() conversion
      reiserfs: Fix recursive lock on lchown
      reiserfs: Relax the lock before truncating pages
      reiserfs: Relax lock on xattr removing
      reiserfs: Don't call reiserfs_get_acl() with the reiserfs lock
      reiserfs: Relax reiserfs_xattr_set_handle() while acquiring xattr locks

Giridhar Malavali (1):
      [SCSI] qla2xxx: Update version number to 8.03.01-k9.

Greg Ungerer (1):
      m68knommu: fix definitions of __pa() and __va()

Guennadi Liakhovetski (1):
      mx3: add support for the mt9v022 camera sensor to pcm037 platform

H Hartley Sweeten (1):
      [ARM] pxa: use resource_size() in pwm.c

Haojian Zhuang (3):
      [ARM] pxa/zylonite: simplify reduntant gpio settings on mmc slot
      [ARM] pxa: do not enable L2 after MMU is enabled
      [ARM] pxa: enable L2 if present in XSC3

Heiko Carstens (1):
      x86: copy_from_user() should not return -EFAULT

Hidetoshi Seto (1):
      PCI: pcie portdrv: style cleanup

Huang Weiyi (1):
      OMAP2: remove duplicated #include

J. Bruce Fields (1):
      nfsd: fix "insecure" export option

Jack Morgenstein (1):
      IB/mlx4: Initialize SRQ scatter entries when creating an SRQ

James Smart (6):
      [SCSI] lpfc 8.3.7: Fix FC protocol errors
      [SCSI] lpfc 8.3.7: Fix NPIV operation errors
      [SCSI] lpfc 8.3.7: Fix hardware/SLI relates issues
      [SCSI] lpfc 8.3.7: Fix SCSI protocol related errors.
      [SCSI] lpfc 8.3.7: Fix discovery failures.
      [SCSI] lpfc 8.3.7: Update Driver version to 8.3.7

Jamie Iles (1):
      ARM: 5866/1: arm ptrace: use unsigned types for kernel pt_regs

Jan Dumon (6):
      hso: Add Vendor/Product ID's for new devices
      hso: Fix for endian issues on big endian machines
      hso: don't change the state of a closed port
      hso: Attempt to recover from usb bus errors
      hso: Fix for 5 sec timeouts with v2.x firmware
      hso: fixed missing newlines

Jan Kara (1):
      quota: Fix dquot_transfer for filesystems different from ext4

Jani Nikula (1):
      gpiolib: fix poll(2) support reconfigure on sysfs polarity change

Janusz Krzysztofik (1):
      omap: McBSP: Fix possible port lockout

Jarek Poplawski (2):
      af_packet: Don't use skb after dev_queue_xmit()
      sky2: Fix oops in sky2_xmit_frame() after TX timeout

Jarkko Lavinen (1):
      mmc_block: fix probe error cleanup bug

Jason Wessel (2):
      maccess,probe_kernel: Allow arch specific override probe_kernel_(read|write)
      blackfin,kgdb,probe_kernel: Cleanup probe_kernel_read/write

Jeff Layton (1):
      sunrpc: on successful gss error pipe write, don't return error

Jerome Glisse (4):
      drm/radeon/kms: Schedule host path read cache flush through the ring V2
      drm/radeon/kms: Make sure we release AGP device if we acquired it
      drm: Avoid calling vblank function is vblank wasn't initialized
      drm/radeon/kms: Don't try to enable IRQ if we have no handler installed

Jesse Barnes (3):
      drm/i915: only enable hotplug for detected outputs
      drm/i915: execbuf2 support
      drm/i915: remove render reclock support

Jie Zhang (1):
      NOMMU: Use copy_*_user_page() in access_process_vm()

Jiri Slaby (4):
      [IA64] use helpers for rlimits
      drm/radeon/kms: fix memory leak
      NET: atlx, fix memory leak
      reiserfs: Fix unreachable statement

Joakim Tjernlund (1):
      zlib: optimize inffast when copying direct from output

Joe Perches (1):
      scripts/get_maintainer.pl: fix file exclusion X: logic

Julia Lawall (4):
      drivers/isdn: eliminate duplicated test
      drivers/net/can: Correct NULL test
      drivers/net : Correct the size argument to kzalloc
      MIPS: Alchemy: Correct code taking the size of a pointer

KOSAKI Motohiro (1):
      proc: partially revert "procfs: provide stack information for threads"

Ken Kawasaki (1):
      pcnet_cs: add cis of KTI PE520 pcmcia network card

Kevin Hilman (1):
      OMAP3: clock: add clockdomains for UART1 & 2

Kevin Winchester (1):
      agp: correct missing cleanup on error in agp_add_bridge

Kristian Høgsberg (3):
      drm/i915: Move PCI IDs into i915 driver
      drm/i915: Implement IS_* macros using static tables
      drm/i915: Track whether cursor needs physical address in intel_device_info

Krzysztof Halasa (1):
      dma-debug: allow DMA_BIDIRECTIONAL mappings to be synced with DMA_FROM_DEVICE and

Krzysztof Helt (2):
      sbawe: fix memory detection part 2
      ALSA: ac97: add AC97 STMicroelectronics' codecs

Li Jie (3):
      ARM: 5863/1: fix bugs of clock source of NUC900
      ARM: 5864/1: Implement arch_reset() in NUC900
      ARM: 5865/1: nuc900 ethernet driver needs mii

Linus Torvalds (1):
      Linux 2.6.33-rc4

Linus Walleij (1):
      ARM: 5867/1: Update U300 defconfig

Luca Barbieri (1):
      drm/nouveau: Fix null deref in nouveau_fence_emit due to deleted fence

Luca Tettamanti (3):
      drm/radeon/kms: rs600: use correct mask for SW interrupt
      hwmon: (asus_atk0110) Refactor interface probe code
      hwmon: (asus_atk0110) Add debugfs interface

Maarten Maathuis (2):
      drm/nouveau: better alignment of bo sizes and use roundup instead of ALIGN
      drm/nv50: make the blocksize depend on vram size

Marc Zyngier (3):
      [ARM] pxa/zeus: make internal zeus_get_pcb_info static
      [ARM] pxa/zeus: relax memory timings on Zeus ethernet ports
      [ARM] pxa/zeus: provide power-source information when APM is enabled

Marcin Kościelnicki (1):
      drm/nv04: Fix set_operation software method.

Marcin Slusarz (2):
      drm/nv50: fix fillrect color
      drm/nouveau: create function for "dealing" with gpu lockup

Marek Vasut (2):
      [ARM] pxa/littleton: add UART3 GPIO config
      [ARM] pxa/littleton: select CPU_PXA300 and CPU_PXA310

Mark Brown (2):
      cs89x0: Always report failure to request interrupt
      ASoC: Fix WM8350 DSP mode B configuration

Mark Salter (3):
      mn10300: signal stack fix
      mn10300: objcopy flags fix
      mn10300: add cc clobbers to asm statements

Masami Hiramatsu (1):
      kmod: fix resource leak in call_usermodehelper_pipe()

Matthew Garrett (1):
      drm/i915: Don't check for lid presence when detecting LVDS

Michael Hennerich (1):
      gpio: adp5588-gpio: new driver for ADP5588 GPIO expanders

Michael Hernandez (1):
      [SCSI] qla2xxx: Get the link data rate explicitly during device resync.

Miguel Aguilar (1):
      DaVinci: DM365: Add the device_enable for the DaVinci Keyscan

Mikael Pettersson (1):
      sata_promise: don't classify overruns as HSM errors

Mike Frysinger (2):
      FDPIC: Respect PT_GNU_STACK exec protection markings when creating NOMMU stack
      NOMMU: Avoiding duplicate icache flushes of shared maps

Minchan Kim (1):
      smaps: fix wrong rss count

Márton Németh (1):
      hwmon: Make PCI device ids constant

OGAWA Hirofumi (2):
      nfs: fix oops in nfs_rename()
      rtc_cmos: convert shutdown to new pnp_driver->shutdown

Octavian Purdila (2):
      ip: fix mc_loop checks for tunnels with multicast outer addresses
      tcp: update the netstamp_needed counter when cloning sockets

Or Gerlitz (1):
      IB/mlx4: Fix queue overflow check in post_recv

PJ Waskiewicz (1):
      ixgbe: Fix compiler warning about variable being used uninitialized

Patrick McHardy (1):
      netfilter: nf_ct_ftp: fix out of bounds read in update_nl_seq()

Paul Walmsley (7):
      OMAP2xxx IO mapping: mark DSP mappings as being 2420-only
      OMAP2420 IO mapping: move IVA mapping virtual address out of vmalloc space
      OMAP3 clock: McBSP 2, 3, 4 functional clock parent is PER_96M_FCLK, not CORE_96M_FCLK
      OMAP clock: remove incorrect EXPORT_SYMBOL()s
      OMAP2xxx OPP: clean up comments in OPP data
      OMAP clock/CPUFreq: add clk_exit_cpufreq_table()
      OMAP2 clock: dynamically allocate CPUFreq frequency table

Peter Huewe (1):
      video/omap: add __init/__exit macros to drivers/video/omap/lcd_htcherald.c

Peter Hüwe (2):
      ARM: 5870/1: arch/arm: Fix build failure for defconfigs without CONFIG_ISA_DMA_API set
      ARM: 5871/1: arch/arm: Fix build failure for lpd7a404_defconfig caused by missing includes

Rabin Vincent (1):
      ARM: 5868/1: ARM: fix "BUG: using smp_processor_id() in preemptible code"

Rafael J. Wysocki (2):
      PCI/PM: Use per-device D3 delays
      DRM / i915: Fix resume regression on MSI Wind U100 w/o KMS

Rakesh Ranjan (2):
      [SCSI] cxgb3i: Fix a login over vlan issue
      cxgb3i: Fix a login over vlan issue

Randy Dunlap (6):
      sunrpc: fix build-time warning
      kgdb: Fix kernel-doc format error in kgdb.h
      docs: large update to ioctl-number.txt
      power: fix kernel-doc notation
      Documentation: update ring-buffer-design.txt
      documentation: update kernel-doc-nano-HOWTO information

Robert P. J. Day (1):
      IB/addr: Correct CONFIG_IPv6 to CONFIG_IPV6

Roel Kluin (5):
      ALSA: test off by one in setsamplerate()
      drm/kms: Fix &&/|| confusion in drm_fb_helper_connector_parse_command_line()
      omap: &&/|| confusion in iommu_put()
      omap3: add missing parentheses
      omap3: add missing parentheses

Roger Blofeld (1):
      hwmon: (adt7462) Fix pin 28 monitoring

Russell King (3):
      ARM: add missing recvmmsg syscall number
      ARM: Fix wrong dmb
      ARM: Ensure ARMv6/7 mm files are built using appropriate assembler options

Rusty Russell (1):
      Revert "x86: Side-step lguest problem by only building cmpxchg8b_emu for pre-Pentium"

Saeed Bishara (1):
      mv643xx_eth: don't include cache padding in rx desc buffer size

Santosh Shilimkar (1):
      ARM: 5872/1: ARM: include needed linux/cpu.h in asm/cpu.h

Sascha Hauer (1):
      lib/rational.c needs module.h

Sekhar Nori (3):
      davinci: cp_intc: provide set_wake function
      davinci: da8xx/omap-l1: mark RTC as a wakeup source
      davinci: enable ARCH_HAS_HOLES_MEMORYMODEL for DaVinci

Simon Kagstrom (1):
      ARM: 5874/1: serial21285: fix disable_irq-from-interrupt-handler deadlock

Sonic Zhang (1):
      blackfin,kgdb: Do not put PC in gdb_regs into retx.

Sriram (1):
      TI DaVinci EMAC: Handle emac module clock correctly.

Stephen Hemminger (1):
      drivers/cpuidle/governors/menu.c: fix undefined reference to `__udivdi3'

Steven Whitehouse (4):
      GFS2: Ensure uptodate inode size when using O_APPEND
      GFS2: Fix locking bug in rename
      GFS2: Fix gfs2_xattr_acl_chmod()
      GFS2: Use MAX_LFS_FILESIZE for meta inode size

Sucheta Chakraborty (2):
      netxen: fix ethtool register dump
      netxen: fix ethtool link test

Suresh Siddha (1):
      x86, irq: Check move_in_progress before freeing the vector mapping

Takashi Iwai (2):
      ALSA: usb-audio - Avoid Oops after disconnect
      ALSA: hda - Fix ALC861-VD capture source mixer

Tejun Heo (2):
      ata_piix: enable 32bit PIO on SATA piix
      libata: retry link resume if necessary

Thomas Champagne (1):
      pmu_battery: Fix battery full reporting

Tobias Klauser (1):
      drm/i915: Storage class should be before const qualifier

Tomaz Mertelj (1):
      hwmon: driver for Texas Instruments amc6821 chip

Tomi Valkeinen (12):
      OMAP: DSS2: DSI: fix VC channels in send_short and send_null
      OMAP: DSS2: DSI: print debug DCS cmd in hex
      OMAP: DSS2: Collect interrupt statistics
      OMAP: DSS2: Fix crash when panel doesn't define enable_te()
      OMAP: DSS2: RFBI: convert to new kfifo API
      OMAP: OMAPFB: fix clk_get for RFBI
      OMAP: OMAPFB: add dummy release function for omapdss
      MAINTAINERS: change omapfb maintainer
      MAINTAINERS: Combine DSS2 and OMAPFB2 into one entry
      OMAP: DSS2: OMAPFB: fix omapfb_free_fbmem()
      OMAP: DSS2: Make check-delay-loops consistent
      OMAP: DSS2: OMAPFB: fix crash when panel driver was not loaded

Tony Lindgren (3):
      omap: Remove uninitialized warning for gpio.c
      omap1: Fix compile for omap1_bl.c
      omap3: Fix booting if package is uninitialized

Tony Luck (3):
      [IA64] sanity in #include files.  Move fnptr to types.h
      [IA64] __per_cpu_idtrs[] is a memory hog
      [IA64] move fnptr definition inside #ifdef __KERNEL__

Trond Myklebust (2):
      SUNRPC: Fix up an error return value in gss_import_sec_context_kerberos()
      SUNRPC: Fix the return value in gss_import_sec_context()

Tuukka Toivonen (1):
      OMAP3 clock: Add capability to change rate of dpll4_m5_ck

Ursula Braun (1):
      claw: use "claw" as root device name

Uwe Kleine-König (3):
      [ARM] pxa/ttc_dkb: remove duplicate macro definition
      imx/mx3: depend on USB_ULPI for otg_ulpi_create
      vsnprintf: fix reference for compressed ipv6 addresses

Vaibhav Hiremath (3):
      Davinci VPFE Capture: Take i2c adapter id through platform data
      omap3: EVM: Choose OMAP_PACKAGE_CBB
      OMAP: DSS2: Fix compile warning

Valentin Longchamp (1):
      mx31moboard: fix usbh device names

Vegard Nossum (1):
      kmemcheck: make bitfield annotations truly no-ops when disabled

Ville Syrjälä (1):
      OMAP: DSS2: Reject scaling settings when they cannot be supported

Vimal Singh (1):
      omap2/3: ZOOM: Correcting key mapping for few keys

Wolfgang Denk (1):
      ARM: MX3: make CPU revision number detection work on all boards

Wu Zhangjin (1):
      MIPS: Cleanup and Fixup of compressed kernel support

Xiaotian Feng (1):
      sunrpc: fix peername failed on closed listener

Yinghai Lu (2):
      x86: Fix size for ex trampoline with 32bit
      x86/pci: Intel ioh bus num reg accessing fix

Yoichi Yuasa (13):
      MIPS: VR41xx: Use strlcat() for the command line arguments
      MIPS: AR7: Remove kgdb_enabled
      MIPS: PowerTV: Remove unused prom_getcmdline()
      MIPS: PowerTV: Remove unused ptv_memsize
      MIPS: PowerTV: Remove mips_machine_halt()
      MIPS: PowerTV: Remove unused platform_die()
      MIPS: PowerTV: simplify prom_init_cmdline() and merge into prom_init()
      MIPS: Cobalt use strlcat() for the command line arguments
      MIPS: AR7: Remove unused prom_getchar()
      MIPS: BCM63xx: Remove duplicate CONFIG_CMDLINE.
      MIPS: Malta, PowerTV: Remove unnecessary "Linux started"
      MIPS: Move vmlinux.ecoff to arch/mips/boot
      MIPS: Ignore vmlinux.*

Yong Wang (1):
      hwmon: (coretemp) Fix TjMax for Atom N450/D410/D510 CPUs

Youquan,Song (2):
      PCI: AER: fix aer inject result in kernel oops
      PCIe AER: prevent AER injection if hardware masks error reporting

Zhao Yakui (6):
      drm/i915: Add MALATA PC-81005 to ACPI LID quirk list
      drm/i915: Update LVDS connector status when receiving ACPI LID event
      drm/i915: Enable/disable the dithering for LVDS based on VBT setting
      drm/i915: Make the BPC in FDI rx/transcoder be consistent with that in pipeconf on Ironlake
      drm/i915: Select the correct BPC for LVDS on Ironlake
      drm/i915: Add DP dpll limit on ironlake and use existing DPLL search function

Zhenyu Wang (4):
      drm/i915: implement new pm ops for i915
      drm/i915: Reload hangcheck timer too for Ironlake
      drm/i915: remove full registers dump debug
      drm: remove address mask param for drm_pci_alloc()

roel kluin (5):
      usbnet: test off by one
      atarilance: timeout ignored in lance_open()
      niu: timeout ignored in tcam_wait_bit()
      net: Test off by one in sh_eth_reset()
      broadcom: Fix &&/|| confusion in bcm54xx_adjust_rxrefclk()
