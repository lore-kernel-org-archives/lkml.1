Return-Path: <linux-kernel-owner+w=401wt.eu-S1757504AbZLXWAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504AbZLXWAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 17:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757471AbZLXWAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 17:00:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757442AbZLXWA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 17:00:27 -0500
Date: Thu, 24 Dec 2009 14:00:24 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.33-rc2 - Merry Christmas ...
Message-ID: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



.. or wahetever it is you'll be celebrating today/tomorrow.

And if you aren't celebrating anything at all, but instead sitting in your 
dark basement feeling lonely and bored, you can at least try out the 
latest -rc kernel. Because it's better than moping around doing nothing.

And if you _are_ celebrating, but are having a bit of an overload of ham 
(or are getting fed up with losing all your clothes in strip dreidel and 
having people point and snigger at you, if that's what gets you through 
the holidays), take a break, compile a kernel, and try it out for size. 

Because while your pants may not fit you for the next month, the new 
kernel might just fit your computer perfectly.

The dirstat says it all: mostly drivers (much of it staging updates, 
especially as nouveau also counts as staging even if it's not physically 
there). But a smattering of changes all over (scheduler, vfs, arch, kfifo 
etc):

   2.9% Documentation/
   2.4% arch/arm/
   3.4% arch/powerpc/
   2.7% arch/x86/
   9.4% arch/
   9.8% drivers/gpu/drm/nouveau/
   2.8% drivers/gpu/drm/radeon/
  15.4% drivers/gpu/drm/
   6.4% drivers/platform/x86/
  12.1% drivers/staging/dst/
  13.4% drivers/staging/sm7xx/
  27.1% drivers/staging/
  10.3% drivers/usb/serial/
  11.9% drivers/usb/
  69.3% drivers/
   3.7% fs/
   6.4% include/linux/
   6.5% include/
   3.4% kernel/
   2.4% sound/pci/hda/
   3.3% sound/

I'd have been happier with a smaller -rc2, but I've seen worse too, so I'm 
not going to complain. 

And now I'm off to peel potatoes. And then to eat them.

Have fun,

		Linus

---
Al Viro (4):
      fix braindamage in audit_tree.c untag_chunk()
      fix more leaks in audit_tree.c tag_chunk()
      Fix f_flags/f_mode in case of lookup_instantiate_filp() from open(pathname, 3)
      Sanitize f_flags helpers

Alan Cox (1):
      jfs: Fix 32bit build warning

Alan Stern (5):
      PM: Use pm_runtime_put_sync in system resume
      PM: Runtime PM documentation update
      USB: power management documentation update
      USB: rename usb_configure_device
      USB: fix bugs in usb_(de)authorize_device

Albert Herranz (3):
      powerpc/gamecube/wii: Fix off-by-one error in ugecon/usbgecko_udbg
      powerpc/gc/wii: hlwd-pic: convert irq_desc.lock to raw_spinlock
      powerpc/gc/wii: Remove get_irq_desc()

Alex Chiang (11):
      ACPI: processor: call _PDC early
      ACPI: processor: introduce arch_has_acpi_pdc
      ACPI: processor: unify arch_acpi_processor_init_pdc
      ACPI: processor: factor out common _PDC settings
      ACPI: processor: finish unifying arch_acpi_processor_init_pdc()
      ACPI: processor: unify arch_acpi_processor_cleanup_pdc
      ACPI: processor: introduce acpi_processor_alloc_pdc()
      ACPI: processor: change acpi_processor_eval_pdc interface
      ACPI: processor: open code acpi_processor_cleanup_pdc
      ACPI: processor: change acpi_processor_set_pdc() interface
      ACPI: processor: remove _PDC object list from struct acpi_processor

Alex Deucher (6):
      drm/radeon/kms/atom: fill in proper defines for digital setup
      drm/radeon/kms: fix legacy rmx
      drm/radeon/kms: set proper default tv standard
      drm/radeon/kms: add cvt mode if we only have lvds w/h and no edid (v4)
      drm/radeon/kms: never combine LVDS with another encoder
      drm/radeon/kms: add definitions for v4 power tables

Alexey Dobriyan (4):
      powerpc/iseries: Convert to proc_fops
      netns: fix net.ipv6.route.gc_min_interval_ms in netns
      asus_acpi: convert to seq_file
      toshiba_acpi: convert to seq_file

Alexey Starikovskiy (1):
      ACPI: EC: Fix MSI DMI detection

Anand Gadiyar (1):
      ARM: 5853/1: ARM: Fix build break on ARM v6 and v7

Anatolij Gustschin (1):
      powerpc/44x: Extend Katmai dts for ADMA and RAID56 support

Andi Kleen (4):
      HWPOISON: Add PROC_FS dependency to hwpoison injector v2
      DRM: Rename clamp variable
      SYSCTL: Print binary sysctl warnings (nearly) only once
      SYSCTL: Add a mutex to the page_alloc zone order sysctl

Andreas Gruenbacher (1):
      Remove obsolete comment in fs.h

Andreas Herrmann (1):
      x86, amd: Get multi-node CPU info from NodeId MSR instead of PCI config space

Andreas Mohr (2):
      USB: ftdi_sio: isolate all device IDs to new ftdi_sio_ids.h header
      USB: ftdi_sio: sort PID/VID entries in new ftdi_sio_ids.h header

Andrei Emeltchenko (1):
      Bluetooth: Fix L2CAP locking scheme regression

Andres Salomon (1):
      watchdog: update geodewdt for new MFGPT API

Andrew Lunn (1):
      Staging: batman-adv: Add Kconfig dependancies on PROC_FS and PACKET.

Andrew Morton (1):
      arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c: avoid cross-CPU interrupts by using smp_call_function_any()

Anisse Astier (3):
      MAINTAINERS: add maintainer for msi-wmi driver
      ALSA: hda - Add STAC9205 PCI_QUIRK for Dell Vostro 1700
      wmi: Free the allocated acpi objects through wmi_get_event_data

Anton Blanchard (3):
      powerpc/defconfigs: Reduce 64bit vmlinux by making acenic and cramfs modules
      powerpc/defconfigs: Disable token ring in powerpc defconfigs
      powerpc/defconfigs: Set HZ=100 on pseries and ppc64 defconfigs

Anton Vorontsov (4):
      powerpc/fsl_pci: Fix P2P bridge handling for MPC83xx PCIe controllers
      powerpc/83xx/suspend: Clear deep_sleeping after devices resume
      powerpc/83xx/suspend: Save and restore SICRL, SICRH and SCCR
      powerpc/83xx: Add power management support for MPC8315E-RDB boards

Arnaldo Carvalho de Melo (1):
      perf session: Make events_stats u64 to avoid overflow on 32-bit arches

Arnaud Mandy (1):
      USB: musb: gadget: set otg tranceiver to idle when registering gadget

Arnd Bergmann (2):
      drm: convert drm_ioctl to unlocked_ioctl
      fs/compat_ioctl.c: fix build error when !BLOCK

Bartlomiej Zolnierkiewicz (1):
      pata_cmd64x: fix overclocking of UDMA0-2 modes

Ben Skeggs (5):
      drm/nv40: implement ctxprog/state generation
      drm/nv50: fix two potential suspend/resume oopses
      drm/nouveau: prevent all channel creation if accel not available
      drm/nv50: fix suspend/resume delays without firmware present
      drm/nouveau: fix bug causing pinned buffers to lose their NO_EVICT flag

Benjamin Herrenschmidt (2):
      powerpc/mm: Fix a WARN_ON() with CONFIG_DEBUG_PAGEALLOC and CONFIG_DEBUG_VM
      powerpc: Fix MSI support on U4 bridge PCIe slot

Bernd Porr (2):
      Staging: comedi: usbdux.c: fix locking up of the driver when the comedi ringbuffer runs empty
      Staging: comedi: removed "depricated" from COMEDI_CB_BLOCK

Bill Gatliff (1):
      USB: Fix double-linking of drivers/usb/otg when ULPI is selected

Blaise Gassend (1):
      USB: serial: Extra device/vendor ID for mos7840 driver

Bob Gleitsmann (1):
      drm/mm: fix logic for selection of best fit block

Borislav Petkov (7):
      x86, msr: msrs_alloc/free for CONFIG_SMP=n
      amd64_edac: fix K8 chip select reporting
      amd64_edac: fix driver instance freeing
      amd64_edac: make driver loading more robust
      amd64_edac: fix forcing module load/unload
      amd64_edac: restrict PCI config space access
      edac, pci: remove pesky debug printk

Breno Leitao (2):
      bnx2: reset_task is crashing the kernel. Fixing it.
      bnx2: fixing a timout error due not refreshing TX timers correctly

Bruce Allan (1):
      e1000e: LED settings in EEPROM ignored on 82571 and 82572

Bryan Wu (1):
      USB: musb: workaround Blackfin FIFO anomalies

Carlos R. Mafra (1):
      ACPI: do not select ACPI_DOCK from ATA_ACPI

Christoph Hellwig (1):
      libata: use the WRITE_SAME_16 define

Clemens Ladisch (2):
      sound: sgio2audio/pdaudiocf/usb-audio: initialize PCM buffer
      USB: emi62: fix crash when trying to load EMI 6|2 firmware

Cliff Cai (4):
      USB: musb: fix compiling warning with min() macro
      USB: musb: correct DMA address for tx
      USB: audio gadget: fix wTotalLength calculation
      USB: audio gadget: free alsa devices when unloading

Coly Li (2):
      ocfs2: explicit declare uninitialized var in user_cluster_connect()
      ocfs2: replace u8 by __u8 in ocfs2_fs.h

Cory Maccarrone (1):
      i2c-omap: Don't write IE state in unidle if 0

Daniel T Chen (1):
      ALSA: hda: Set Front Mic to input vref 50% for Lenovo 3000 Y410

Daniele Calore (1):
      alpha: Wire up missing/new syscalls

Dave Airlie (1):
      drm/radeon: fix build on 64-bit with some compilers.

David Daney (2):
      powerpc: Convert BUG() to use unreachable()
      alpha: Convert BUG() to use unreachable()

David Gibson (1):
      powerpc/mm: Fix stupid bug in subpge protection handling

David Miller (1):
      sched: Fix cpu_clock() in NMIs, on !CONFIG_HAVE_UNSTABLE_SCHED_CLOCK

David Vrabel (1):
      MAINTAINERS: update entries for WUSB, UWB and WLP subsystems

Dmitry Eremin-Solenikov (4):
      powerpc/83xx: mpc8349emitx - add gpio controller declarations
      powerpc/83xx: mpc8349emitx - populate I2C busses in device tree
      powerpc/83xx: mpc8349emitx - add OF descriptions of LocalBus devices
      powerpc/83xx: mpc8349emitx - add leds-gpio binding

Dmitry Monakhov (7):
      ext3: quota macros cleanup [V2]
      Add unlocked version of inode_add_bytes() function
      quota: decouple fs reserved space from quota reservation
      ext4: Convert to generic reserved quota's space management.
      quota: Move duplicated code to separate functions
      ext4: Fix potential quota deadlock
      ext4: fix sleep inside spinlock issue with quota and dealloc (#14739)

Dmitry Torokhov (4):
      tc1100-wmi - switch to using attribute group
      tc1100-wmi - add error handling for device registration
      tc1100-wmi - switch to using dev_pm_ops
      dell-wmi: do not keep driver loaded on unsupported boxes

Dominik Brodowski (1):
      resources: fix call to alignf() in allocate_resource()

Donny Kurnia (1):
      USB: option: support hi speed for modem Haier CE100

Einar Rünkaru (2):
      ALSA: hda - Fixed internal mic initialization for Dell Vostro 1015
      ALSA: hda - Make use of beep device found in Dell Vostro 1015n

Eric Millbrandt (1):
      ASoC: Do not write to invalid registers on the wm9712.

Eric Sandeen (4):
      ext3: Remove outdated comment about lock_super()
      ext3: ext3_mark_recovery_complete() doesn't need to use lock_super
      ext3: Replace lock/unlock_super() with an explicit lock for the orphan list
      ext3: Replace lock/unlock_super() with an explicit lock for resizing

Evgeniy Polyakov (1):
      pohmelfs needs I_LOCK

Felipe Balbi (4):
      USB: musb: move musb_remove to __exit
      USB: musb: MAINTAINERS: Fix my tree's address
      USB: musb: do not work if no gadget driver is loaded
      usb: otg: isp1301_omap: fix compile error

Felix Radensky (1):
      powerpc/85xx: Workaround MPC8572/MPC8536 GPIO 1 errata.

Florian Fainelli (1):
      ALSA: sound/core/pcm_timer.c: use lib/gcd.c

Francisco Jerez (4):
      drm/nv04-nv40: Fix "conflicting memory types" when saving/restoring VGA fonts.
      drm/i2c/ch7006: Fix load detection false positives right after system init.
      drm/nouveau: Fix up buffer eviction, and evict them to GART, if possible.
      drm/nv10: Add the initial graph context and soft methods needed for LMA.

Frederic Weisbecker (4):
      sched: Teach might_sleep() about preemptible RCU
      perf events, x86/stacktrace: Make stack walking optional
      perf events, x86/stacktrace: Fix performance/softlockup by providing a special frame pointer-only stack walker
      hw-breakpoints: Fix hardware breakpoints -> perf events dependency

Gautham R Shenoy (2):
      powerpc/pseries: Don't panic when H_PROD fails during cpu-online.
      powerpc/pseries: Make declarations of cpu_hotplug_driver_lock() ANSI compatible.

George Kadianakis (3):
      Staging: fix rtl8187se compilation errors with mac80211
      staging: fix rtl8192e compilation errors with mac80211
      staging: fix rtl8192su compilation errors with mac80211

Greg Kroah-Hartman (2):
      Staging: batman: fix debug Kconfig option
      Staging: dst: remove from the tree

Guennadi Liakhovetski (3):
      sh: dmaengine support for sh7724.
      ASoC: wm8974: fix a wrong bit definition
      ASoC: add missing parameter to mx27vis_hifi_hw_free()

Gustavo F. Padovan (2):
      Bluetooth: Fix unset of RemoteBusy flag for L2CAP
      Bluetooth: Ack L2CAP I-frames before retransmit missing packet

H Hartley Sweeten (2):
      pata_octeon_cf: use resource_size(), to fix resource sizing bug
      [WATCHDOG] use resource_size()

H. Peter Anvin (3):
      x86, msr/cpuid: Register enough minors for the MSR and CPUID drivers
      Makefile: set LC_CTYPE, LC_COLLATE, LC_NUMERIC to C
      Makefile: Unexport LC_ALL instead of clearing it

Hector Martin (3):
      ALSA: HDA: simplify Aspire 8930G verb array
      ALSA: HDA: remove useless mixers on Aspire 8930G
      ALSA: HDA: add powersaving hook for Realtek

Heiko Carstens (2):
      [S390] wire up sys_recvmmsg
      [S390] Use strim instead of strstrip to avoid false warnings.

Ian Abbott (1):
      Staging: comedi: jr3_pci: Don't ioremap too much space. Check result.

Imre Kaloz (1):
      [WATCHDOG] iTCO_wdt: add PCI ID for the Intel EP80579 (Tolapai) SoC

Ingo Molnar (1):
      sched: Make warning less noisy

J. Bruce Fields (1):
      nfsd: fix "insecure" export option

Jan Beulich (1):
      USB: fix section mismatch in early ehci dbgp

Jan Glauber (2):
      [S390] qdio: remove superfluous log entries and WARN_ONs.
      [S390] qdio: add counter for input queue full condition

Jan Kara (5):
      ocfs2: Always include ACL support
      ocfs2: Make acl use the default
      ocfs2: Set MS_POSIXACL on remount
      quota: Fix 64-bit limits setting on 32-bit archs
      quota: Improve checking of quota file header

Jaroslav Kysela (1):
      ALSA: hda/realtek: Remove extra .capsrc_nids initialization for ALC889_INTEL

Jean PIHET (1):
      ARM: 5849/1: ARMv7: fix Oprofile events count

Jeff Garzik (2):
      sata_mv: remove pointless NULL test
      Revert "pata_cmd64x: implement serialization as per notes"

Jeff Liu (1):
      ocfs2-devel: remove redundant OCFS2_MOUNT_POSIX_ACL check in ocfs2_get_acl_nolock()

Jerome Glisse (2):
      drm/radeon/kms: Avoid crash when trying to cleanup uninitialized structure
      drm/radeon/kms: Check module arguments to be valid V2

Joe Perches (1):
      sched: Use pr_fmt() and pr_<level>()

Jon Smirl (1):
      ASoC: Fix disable of SPDIF on STAC9766 codec

Jonathan Woithe (1):
      fujitu-laptop: fix tests of acpi_evaluate_integer() return value

Julia Lawall (6):
      [S390] drivers: Correct size given to memset
      ALSA: Use kzalloc for allocating only one thing
      drivers/gpu: Use kzalloc for allocating only one thing
      Staging: wlan-ng: fix Correct size given to memset
      Staging: batman-adv: introduce missing kfree
      USB: gadget: Use ERR_PTR/IS_ERR

Kailang Yang (1):
      ALSA: hda - More ALC663 fixes and support of compatible chips

Kay Sievers (2):
      vfs: get_sb_single() - do not pass options twice
      devtmpfs: unlock mutex in case of string allocation error

Krzysztof Helt (2):
      ALSA: fix incorrect rounding direction in snd_interval_ratnum()
      ALSA: sbawe: fix memory detection

Kuninori Morimoto (2):
      ASoC: ak4642: Add default return value in ak4642_modinit
      sh: mach-ecovec24: setup.c detailed correction

Linus Torvalds (3):
      Revert "time: Remove xtime_cache"
      Revert "x86, ucode-amd: Ensure ucode update on suspend/resume after CPU off/online cycle"
      Linux 2.6.33-rc2

Maarten Maathuis (1):
      drm/nouveau: use drm debug levels

Magnus Damm (1):
      serial: sh-sci: earlyprintk zero uartclk fix

Manjunatha GK (1):
      i2c-omap: OMAP3: Fix I2C lockup during timeout/error cases

Marcin Ko¶cielnicki (4):
      drm/nouveau: Kill global state in NvShadowBIOS
      drm/nouveau: Kill global state in BIOS script interpreter
      drm/nv04: Fix NV04 set_operation software method.
      drm/nouveau: Add proper error handling to nouveau_card_init

Marek Ol¹ák (2):
      drm/radeon/kms: allow rendering while no colorbuffer is set on r300
      drm/radeon/kms: add 3DC compression support

Marin Mitov (1):
      drm/kms: silencing a false positive warning.

Mark Ware (1):
      powerpc/cpm2_pic: Allow correct flow_types for port C interrupts

Markus Pietrek (1):
      sh: Ensure all PG_dcache_dirty pages are written back.

Martin Schwidefsky (1):
      [S390] rename NT_PRXSTATUS to NT_S390_HIGHREGS

Masami Hiramatsu (4):
      perf probe: Fix libdwarf include path for Debian
      perf probe: Check whether debugfs path is correct
      kprobe-tracer: Check new event/group name
      perf probe: Check new event name

Mattia Dongili (3):
      sony-laptop: add AVMode key mapping
      sony-laptop: rfkill support for newer models
      sony-laptop: enumerate rfkill devices using SN06

Maulik Mankad (2):
      USB: musb: Fix null pointer dereference issue
      USB: musb: Fix array index out of bounds issue

Mel Gorman (1):
      powerpc/pseries: Select XICS and PCI_MSI PSERIES

Michael Chan (1):
      bnx2: Fix bnx2_netif_stop() merge error.

Michael Cree (1):
      alpha: Add minimal support for software performance events

Michael Hennerich (1):
      Driver core: export platform_device_register_data as a GPL symbol

Michael Holzheu (1):
      [S390] tape: Add pr_fmt() macro to all tape source files

Mike Rapoport (1):
      ARM: 5857/1: ARM: dmabounce: fix build

Nageswari Srinivasan (1):
      TI DaVinci EMAC: Fix MDIO bus frequency configuration

Neil Campbell (1):
      powerpc: Handle VSX alignment faults correctly in little-endian mode

Nitin Gupta (1):
      Staging: ramzswap: remove ARM specific d-cache hack

Nobuhiro Iwamatsu (1):
      sh: dmaengine support for SH7785

Oleg Nesterov (1):
      [S390] ptrace: dont abuse PT_PTRACED

Oliver Neukum (1):
      Bluetooth: Prevent ill-timed autosuspend in USB driver

Pallipadi, Venkatesh (1):
      x86: Reenable TSC sync check at boot, even with NONSTOP_TSC

Paul Mundt (4):
      sh: Fix up MAX_DMA_CHANNELS definition when DMA is disabled.
      sh: Restore bl bit toggling in idle loop.
      sh: Only use bl bit toggling for sleeping idle.
      serial: sh-sci: Convert tremaining ctrl_xxx I/O routines to __raw_xxx.

Peter Feuerer (2):
      acerhdf: add new BIOS versions
      drivers/platform/x86/acerhdf.c: check BIOS information whether it begins with string of table

Peter Huewe (2):
      Staging: panel: Fix compilation error with custom lcd charset
      Staging: panel: Adjust range for PANEL_KEYPAD in Kconfig

Peter Korsgaard (1):
      powerpc/gpio: support gpio_to_irq()

Peter Oberparleiter (1):
      [S390] cio: fix channel path vary

Peter Zijlstra (20):
      sched: Mark boot-cpu active before smp_init()
      sched: Fix task_hot() test order
      sched: Select_task_rq_fair() must honour SD_LOAD_BALANCE
      sched: Use TASK_WAKING for fork wakups
      sched: Ensure set_task_cpu() is never called on blocked tasks
      sched: Fix sched_exec() balancing
      sched: Fix select_task_rq() vs hotplug issues
      sched: Move kthread_bind() back to kthread.c
      sched: Add pre and post wakeup hooks
      sched: Remove the cfs_rq dependency from set_task_cpu()
      sched: Simplify set_task_cpu()
      perf events: Dont report side-band events on each cpu for per-task-per-cpu events
      sched: Move TASK_STATE_TO_CHAR_STR near the TASK_state bits
      sched: Add missing state chars to TASK_STATE_TO_CHAR_STR
      sched: Update task_state_arraypwith new states
      sched: Assert task state bits at build time
      sched: Fix broken assertion
      sched: Restore printk sanity
      sched: Fix hotplug hang
      sched: Revert 738d2be, simplify set_task_cpu()

Phil Carmody (4):
      Driver core: device_attribute parameters can often be const*
      Driver core: bin_attribute parameters can often be const*
      Driver core: driver_attribute parameters can often be const*
      driver core: Prevent reference to freed memory on error path

Phillip Lougher (3):
      bzip2/lzma/gzip: pre-boot malloc doesn't return NULL on failure
      bzip2: Add missing checks for malloc returning NULL
      initramfs: add missing decompressor error check

Rafael Avila de Espindola (1):
      ALSA: hda - Add support for the new 27 inch IMacs

Rafael J. Wysocki (4):
      sched: Make wakeup side and atomic variants of completion API irq safe
      PM: Make the initcall_debug style timing for suspend/resume complete
      PM: Measure device suspend and resume times
      PM / Runtime: Use device type and device class callbacks

Rafa³ Mi³ecki (2):
      drm/radeon/kms: prevent parallel AtomBIOS calls
      drm/radeon/kms: enable memory clock reading on legacy (V2)

Randy Dunlap (6):
      lib/string.c: fix kernel-doc warnings
      mm tracing: cleanup Documentation/trace/events-kmem.txt
      kfifo: fix Error/broken kernel-doc notation
      Staging: rtl8192x: fix printk formats
      Staging/vt66*: kconfig, depends on WLAN
      USB core: fix recent kernel-doc warnings

Robert Hancock (1):
      libata: fix reporting of drained bytes when clearing DRQ

Robert Jennings (2):
      mm: Add notifier in pageblock isolation for balloon drivers
      powerpc: Make the CMM memory hotplug aware

Robert P. J. Day (1):
      perf events: Remove unused perf_counter.h header file

Roel Kluin (8):
      sound/oss/pss: Fix test of unsigned in pss_reset_dsp() and pss_download_boot()
      Bluetooth: Fix PTR_ERR return of wrong pointer in hidp_setup_hid()
      powerpc/85xx: Wrong variable returned on error
      [S390] dasd: PTR_ERR return of wrong pointer in
      [S390] s390: PTR_ERR return of wrong pointer in fallback_init_cip()
      [S390] tty: PTR_ERR return of wrong pointer in fs3270_open()
      broadcom: bcm54xx_shadow_read() errors ignored in bcm54xx_adjust_rxrefclk()
      Staging: rtl8192su: fix test for negative error in rtl8192_rx_isr()

Roger Oksanen (1):
      e100: Fix broken cbs accounting due to missing memset.

Roland Dreier (3):
      x86: Don't use POSIX character classes in gen-insn-attr-x86.awk
      alloc_file(): simplify handling of mnt_clone_write() errors
      anonfd: Allow making anon files read-only

Russell King (13):
      ARM: Convert VFP/Crunch/XscaleCP thread_release() to exit_thread()
      ARM: Kill CONFIG_CPU_32
      ALSA: AACI: simplify codec rate information
      ALSA: AACI: cleanup aaci_pcm_hw_params
      ALSA: AACI: factor common hw_params logic into aaci_pcm_hw_params
      ALSA: AACI: add double-rate support
      ALSA: AACI: switch to per-pcm locking
      ARM: add missing include to nwflash.c
      ARM: Fix wrong shared bit for CPU write buffer bug test
      ARM: fix PAGE_KERNEL
      ARM: footbridge: trim down old ISA rtc setup
      ARM: dma-isa: request cascade channel after registering it
      VIDEO: cyberpro: pci_request_regions needs a persistent name

Sachin P. Sant (1):
      powerpc/mm: Fix hash_utils_64.c compile errors with DEBUG enabled.

Saeed Bishara (6):
      sata_mv: increase PIO IORDY timeout
      sata_mv: support clkdev framework
      sata_mv: add power management support for the platform driver
      sata_mv: move the PCI bar description initialization code
      sata_mv: store the board_idx into the host private data
      sata_mv: add power management support for the PCI controllers.

Sandeep Gopalpet (3):
      gianfar: Fix a filer bug
      gianfar: Fix stats support
      gianfar: Fix bit definitions of IMASK_GRSC and IMASK_GTSC

Sean MacLennan (1):
      powerpc/44x: Increase warp SD buffer

Sebastian Andrzej Siewior (2):
      powerpc/fsl: try to explain why the interrupt numbers are off by 16
      Doc/stable rules: add new cherry-pick logic

Sebastian Ott (1):
      [S390] cio: fix drvdata usage for the console subchannel

Sergei Shtylyov (3):
      pata_hpt3x2n: fix clock turnaround
      USB: musb_gadget: fix kernel oops in txstate()
      USB: musb: gadget_ep0: avoid SetupEnd interrupt

Shaohua Li (1):
      ACPI: fix OSC regression that caused aer and pciehp not to load

Sheng Yang (1):
      x86: Add IA32_TSC_AUX MSR and use it

Simon Horman (1):
      timers: Remove duplicate setting of new_base in __mod_timer()

Sonic Zhang (2):
      pata_bf54x: handle portmuxing of pins through GPIO PORTs
      i2c-bfin-twi: fix CLKDIV calculation

Stefan Bader (1):
      acerhdf: limit modalias matching to supported

Stefan Haberland (1):
      [S390] dasd: move dasd-diag kmsg to dasd

Stefani Seibold (10):
      kfifo: move struct kfifo in place
      kfifo: move out spinlock
      kfifo: cleanup namespace
      kfifo: rename kfifo_put... into kfifo_in... and kfifo_get... into kfifo_out...
      kfifo: fix warn_unused_result
      kfifo: add DEFINE_KFIFO and friends, add very tiny functions
      kfifo: add kfifo_skip, kfifo_from_user and kfifo_to_user
      kfifo: add record handling functions
      media video cx23888 driver: ported to new kfifo API
      Fix usb_serial_probe() problem introduced by the recent kfifo changes

Stephane Glondu (1):
      staging: rtl8192su: add USB VID/PID for HWNUm-300

Stephen Hemminger (1):
      netxen: use module parameter correctly

Sunil Mushran (3):
      ocfs2/cluster: Make fence method configurable - v2
      fiemap: Add new extent flag FIEMAP_EXTENT_SHARED
      ocfs2: Use FIEMAP_EXTENT_SHARED

Suresh Siddha (2):
      x86, cpuid: Add "volatile" to asm in native_cpuid()
      x86, irq: Allow 0xff for /proc/irq/[n]/smp_affinity on an 8-cpu system

Swaminathan S (2):
      USB: musb: Populate the VBUS GPIO with the correct GPIO number
      USB: musb: fix for crash in DM646x USB when (CPPI)DMA is enabled

Takashi Iwai (6):
      ALSA: hda - Fix missing capsrc_nids for ALC88x
      ALSA: hda - Fix quirk for Maxdata obook4-1
      ALSA: aaci - Fix a typo
      ALSA: hda - Fix NULL dereference with enable_beep=0 option
      ALSA: hda - Add MSI blacklist
      ALSA: hda - Set mixer name after codec patch

Tao Ma (6):
      ocfs2: Find proper end cpos for a leaf refcount block.
      ocfs2: refcounttree.c cleanup.
      ocfs2: Add reflinked file's inode to inode hash eariler.
      ocfs2: Set i_nlink properly during reflink.
      ocfs2/trivial: Use proper mask for 2 places in hearbeat.c
      ocfs2/trivial: Use le16_to_cpu for a disk value in xattr.c

Thadeu Lima de Souza Cascardo (1):
      classmate-laptop: add support for Classmate PC ACPI devices

Thomas Gleixner (9):
      signal: Fix racy access to __task_cred in kill_pid_info_as_uid()
      signals: Fix more rcu assumptions
      sys: Fix missing rcu protection for __task_cred() access
      clockevents: Prevent clockevent_devices list corruption on cpu hotplug
      sched: Use rcu in sys_sched_getscheduler/sys_sched_getparam()
      sched: Use rcu in sched_get/set_affinity()
      sched: Use rcu in sched_get_rr_param()
      devtmpfs: Convert dirlock to a mutex
      Driver-core: Fix bogus 0 error return in device_add()

Thomas Hellstrom (3):
      drm/vmwgfx: Fix unlocked ioctl and add proper access control
      drm/vmwgfx: Return -ERESTARTSYS when interrupted by a signal.
      drm/vmwgfx: Use TTM handles instead of SIDs as user-space surface handles.

Thomas Renninger (2):
      acer-wmi, msi-wmi: Remove needless DMI MODULE_ALIAS
      hp-wmi: Fix two memleaks

Tiger Yang (1):
      ocfs2: return -EAGAIN instead of EAGAIN in dlm

Tristan Ye (2):
      Ocfs2: Should ocfs2 support fiemap for S_IFDIR inode?
      Ocfs2: Let ocfs2 support fiemap for symlink and fast symlink.

Uwe Kleine-König (2):
      can/at91: don't check platform_get_irq's return value against zero
      ASoC: sh: FSI:: don't check platform_get_irq's return value against zero

Wu Zhangjin (1):
      Staging: sm7xx: add a new framebuffer driver

Xiaotian Feng (1):
      sched: Fix set_cpu_active() in cpu_down()

Yang Hongyang (1):
      ipv6: fix an oops when force unload ipv6 module

Yang Li (2):
      powerpc/mm: Fix typo of cpumask_clear_cpu()
      powerpc/mpic: Fix problem that affinity is not updated

Yin Kangkai (1):
      jbd: jbd-debug and jbd2-debug should be writable

Yinghai Lu (2):
      x86: Fix checking of SRAT when node 0 ram is not from 0
      x86: Increase MAX_EARLY_RES; insufficient on 32-bit NUMA

Yong Zhang (2):
      powerpc/iseries: use DECLARE_COMPLETION_ONSTACK for non-constant completion
      mISDN: use DECLARE_COMPLETION_ONSTACK for non-constant completion

Zhang Rui (1):
      ACPI: disable _OSI(Windows 2009) on Asus K50IJ

akpm@linux-foundation.org (1):
      x86: Fix objdump version check in arch/x86/tools/chkobjdump.awk

pancho horrillo (2):
      USB: add device ID for Apple Cinema Display 23in 2007
      USB: Fix a bug on appledisplay.c regarding signedness

wanzongshun (3):
      ARM: 5854/1: fix compiling error for NUC900
      ARM: 5855/1: putc support for nuc900
      ARM: 5856/1: Fix bug of uart0 platfrom data for nuc900
