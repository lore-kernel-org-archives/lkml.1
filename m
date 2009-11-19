Return-Path: <linux-kernel-owner+w=401wt.eu-S1757778AbZKSW4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757778AbZKSW4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 17:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757509AbZKSW4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 17:56:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56075 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756741AbZKSW4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 17:56:14 -0500
Date: Thu, 19 Nov 2009 14:56:18 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.32-rc8
Message-ID: <alpine.LFD.2.00.0911191440511.2793@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ok, 
 the way things are going, this will likely be the last -rc. I wish we had 
more people looking at the regression list, but at some point I'm just 
going to have to say "ok, enough is enough".

I'm also going to be away for the Thanksgiving week (which is next week, 
for all you who live outside the US, or for those of you who are otherwise 
oblivious about these things), so I didn't want to open the merge window 
any earlier either - thus one last -rc is pretty natural.

I'll also see how quiet things will be during the week I'm off-line, it 
may obviously turn out that we'll need an -rc9. That said, I think we're 
in pretty reasonable shape here.

In fact, there hasn't been a whole lot of excitement since -rc7.  The 
biggest patches are literally a couple of reverts (in isdn code and libipw 
respectively), and a couple of updates to shipped lex/yacc files (where 
the real change was just a couple of lines, but the generated files 
changed more, partly due to different versions of lex/yacc to generate 
them).

The rest is pretty much fairly trivial one-liners (or 'few-liners').

So give it a good testing,

				Linus

---
Abner Holsinger (1):
      Input: lifebook - fix settings for CF-72

Alan Cox (3):
      tty_port: If we are opened non blocking we still need to raise the carrier
      tty: cp210x: Fix carrier handling
      vt: Fix use of "new" in a struct field

Alan Stern (1):
      USB: usbmon: fix bug in mon_buff_area_shrink

Alex Williamson (1):
      intel-iommu: Obey coherent_dma_mask for alloc_coherent on passthrough

Andi Kleen (1):
      mm: allow memory hotplug and hibernation in the same kernel

Andrei Emeltchenko (1):
      Bluetooth: Set general bonding security for ACL by default

Anil Ravindranath (1):
      [SCSI] pmcraid: Fix ppc64 driver build for using cpu_to_le32 on U8 data type

Anuj Aggarwal (1):
      ASoC: Modifying the license string GPLv2 for OMAP3 EVM

Atsushi Nemoto (2):
      MIPS: Make local arrays with CL_SIZE static __initdata
      MIPS: TXx9: Update rbtx49xx_defconfig

Ben Dooks (1):
      hwmon: (s3c-hwmon) Ignore invalid divider settings

Ben Hutchings (1):
      [SCSI] bfa: declare MODULE_FIRMWARE

Ben McKeegan (1):
      ppp: fix BUG on non-linear SKB (multilink receive)

Bing Zhao (2):
      Libertas: coding style cleanup in ethtool.c
      Libertas: fix issues while configuring host sleep using ethtool wol

Bob Copeland (3):
      ath5k: don't reset mcast filter when configuring the mode
      ath5k: add LED support for HP Compaq CQ60
      ath5k: add LED definition for BenQ Joybook R55v

Breno Leitao (2):
      s2io: fixing a ethtool test that is broken
      ixgbe: Fixing EEH handler to handle more than one error

Brian King (1):
      [SCSI] scsi_transport_fc: Fix WARN message for FC passthru failure paths

Christian Borntraeger (1):
      [S390] s390: fix single stepping on svc0

Chuck Lever (1):
      SUNRPC: Address buffer overrun in rpc_uaddr2sockaddr()

Dan Carpenter (3):
      ipmr: missing dev_put() on error path in vif_add()
      ALSA: ice1724 - make some bitfields unsigned
      dereferencing freed memory regulator_fixed_voltage_remove()

Daniel J Blueman (1):
      ALSA: hda - Dell Studio 1557 hd-audio quirk

Daniel T Chen (1):
      ALSA: hda: Use model=mb5 for MacBookPro 5,2

Dave Jones (1):
      [SCSI] gdth: Prevent negative offsets in ioctl CVE-2009-3080

Dave Mitchell (1):
      ibm_newemac: Fix EMACx_TRTR[TRT] bit shifts

David Daney (1):
      MIPS: Fix emulation of 64-bit FPU on FPU-less 64-bit CPUs.

David S. Miller (2):
      Revert "isdn: isdn_ppp: Use SKB list facilities instead of home-grown implementation."
      sungem: Fix Serdes detection.

David Woodhouse (3):
      intel-iommu: Check for 'DMAR at zero' BIOS error earlier.
      agp/intel-agp: Set dma_mask for capable chipsets before agp_add_bridge()
      Fix handling of the HP/Acer 'DMAR at zero' BIOS error for machines with <4GiB RAM.

Divy Le Ray (1):
      cxgb3: fix premature page unmap

Dmitry Eremin-Solenikov (1):
      leds-gpio: fix possible crash on OF device unbinding

Dmitry Monakhov (1):
      [CPUFREQ] Fix use after free on governor restore

Dmitry Torokhov (3):
      Input: fix locking in memoryless force-feedback devices
      Input: force LED reset on resume
      Input: atkbd - restore LED state at reconnect

Eric Dumazet (2):
      net: Fix the rollback test in dev_change_name()
      vlan: Fix register_vlan_dev() error path

Eric Miao (1):
      [ARM] pxa: fix incorrect mfp_to_gpio() conversion

Felix Fietkau (1):
      b43: work around a locking issue in ->set_tim()

Fenghua Yu (1):
      intel-iommu: Support PCIe hot-plug

Florian Fainelli (1):
      r6040: fix version printing

Francesco Lavra (1):
      USB: cdc_acm: Fix memory leak after hangup

Gerald Schaefer (1):
      [S390] monreader: fix use after free bug with suspend/resume

Gertjan van Wingerde (1):
      rt2x00: Update MAINTAINERS

Grazvydas Ignotas (1):
      ASoC: OMAP3 Pandora: update for TWL4030 codec changes

Gustavo F. Padovan (2):
      Bluetooth: Select Basic Mode as default for SOCK_SEQPACKET
      Bluetooth: Fix regression with L2CAP configuration in Basic Mode

Henry Gebhardt (1):
      USB: cdc_acm: Fix race condition when opening tty

Herbert Xu (1):
      gro: Fix illegal merging of trailer trash

Hidetoshi Seto (1):
      mm/memory_hotplug: fix section mismatch

Ilpo Järvinen (1):
      tcp: provide more information on the tcp receive_queue bugs

Ivo van Doorn (1):
      rt2x00: update MAINTAINERS

Jan Rekorajski (1):
      XFS bug in log recover with quota (bugzilla id 855)

Javier Kohen (1):
      ALSA: usb - Quirk to disable master volume control in PCM2702

Jean Delvare (4):
      hwmon: (adt7475) Fix temperature fault flags
      hwmon: (adt7475) Cache limits for 60 seconds
      hwmon: (adt7475) Fix sysfs file names
      backlight: lcd - Fix wrong sizeof

Jiri Kosina (1):
      Input: psmouse - fix breakage introduced by b7802c5c1ea

Jiro SEKIBA (2):
      nilfs2: deleted struct nilfs_dat_group_desc
      nilfs2: deleted inconsistent comment in nilfs_load_inode_block()

Joe Perches (2):
      MAINTAINERS: RFKILL - Fix pattern entry missing colon
      MAINTAINERS: KMEMCHECK: add file patterns, use M: for Pekka's name and address

John Villalovos (1):
      [CPUFREQ] acpi-cpufreq: blacklist Intel 0f68: Fix HT detection and put in notification message

John W. Linville (1):
      Revert "libipw: initiate cfg80211 API conversion"

Josh Triplett (12):
      kconfig: Make zconf.y work with current bison
      kconfig: Mark various internal functions static
      genksyms: Mark is_reserved_word static
      Documentation/vm/page-types.c: Declare checked_open static
      arch/alpha/boot/tools/objstrip.c: Mark "usage" static
      arch/powerpc/boot/addRamDisk.c: Mark several internal functions static
      arch/sparc/boot/*.c: Mark various internal functions static
      drm: radeon: Mark several functions static in mkregtable
      dtc: Set "noinput" in the lexer to avoid an unused function
      dtc: Mark various internal functions static
      oss: Mark loadhex static in hex2hex.c
      Makefile: Add -Wmising-prototypes to HOSTCFLAGS

Kevin D. Kissell (1):
      MIPS: SMTC: Fix lockup in smtc_distribute_timer

Krzysztof Helt (1):
      [CPUFREQ] longhaul: select Longhaul version 2 for capable CPUs

Kuninori Morimoto (1):
      uio: pm_runtime_disable is needed if failed

Larry Finger (2):
      rtl8187: Fix sparse warnings
      p54usb: Remove DMA buffer from stack

Lennert Buytenhek (1):
      [ARM] Kirkwood: disable propagation of mbus error to the CPU local bus

Libin Yang (1):
      USB: ohci: quirk AMD prefetch for USB 1.1 ISO transfer

Linus Torvalds (2):
      strcmp: fix overflow and possibly signedness error
      Linux 2.6.32-rc8

Linus Walleij (1):
      ARM: 5787/1: U300 COH 901 331 fixes

Marc Zyngier (1):
      [ARM] pxa: fix interrupts number calculation when CONFIG_PXA_HAVE_ISA_IRQS=y

Marek Vasut (1):
      [ARM] pxa/colibri: fix AC97 ifdefs and add missing include

Mark Brown (1):
      regulator: Handle missing constraints in _regulator_disable()

Martin Fuzzey (1):
      ssb-pcmcia: Fix 32bit register access in early bus scanning

Martin K. Petersen (1):
      [SCSI] Fix incorrect reporting of host protection capabilities

Martin Schwidefsky (2):
      [S390] reset cputime accounting after IPL from NSS
      [S390] sclp: undo quiesce handler override on resume

Mimi Zohar (1):
      ima: replace GFP_KERNEL with GFP_NOFS

Nathaniel W. Turner (1):
      xfs: copy li_lsn before dropping AIL lock

NeilBrown (4):
      md: factor out updating of 'recovery_offset'.
      md: allow v0.91 metadata to record devices as being active but not in-sync.
      Don't unconditionally set in_sync on newly added device in raid5_reshape
      md/raid5: Allow dirty-degraded arrays to be assembled when only party is degraded.

Nicolas Ferre (1):
      at91: at91sam9g20ek modify dual slot evaluation kit

Oliver Hartkopp (1):
      can: Fix driver Kconfig structure

Oliver Neukum (1):
      fix memory leak in fixed btusb_close

Pallipadi, Venkatesh (1):
      [CPUFREQ] Resolve time unit thinko in ondemand/conservative govs

Paul Parsons (1):
      [ARM] pxa/hx4700: fix hx4700 touchscreen pressure values

Pavel Machek (1):
      backlight: Fix backlight limiting on spitz/corgi devices

Peter Zijlstra (1):
      fcntl: rename F_OWNER_GID to F_OWNER_PGRP

Petr Vandrovec (1):
      Fix memory corruption caused by nfsd readdir+

Prarit Bhargava (1):
      [CPUFREQ] Fix stale cpufreq_cpu_governor pointer

Raimonds Cicans (1):
      r8169: Fix receive buffer length when MTU is between 1515 and 1536

Rajendra Nayak (1):
      omap3: clock: Fix the DPLL freqsel computations

Roel Kluin (10):
      [SCSI] bfa: fix test in bfad_os_fc_host_init()
      [ARM] pxa: fix missing underscores in mfp-pxa910.h
      mISDN: fix error return in HFCmulti_init()
      regulator: Fix check of unsigned return value and transmit errors in wm831x_gp_ldo_get_mode()
      [ARM] pxa: ensure mfp is in correct range in mfp_{read,write}
      spi: error status should be negative
      drivers/video/da8xx-fb.c: fix error return
      [CPUFREQ] powernow-k8: Fix test in get_transition_latency()
      omap: fix unlikely(x) < y
      OMAP: cs should be positive in gpmc_cs_free()

Russell King (1):
      ARM: Fix warning in sa1100-flash.c

Rusty Russell (1):
      [CPUFREQ] speedstep-ich: fix error caused by 394122ab144dae4b276d74644a2f11c44a60ac5c

Ryusuke Konishi (1):
      nilfs2: fix lock order reversal in chcp operation

Sarah Sharp (3):
      USB: xhci: Fix bug memory free after failed initialization.
      USB: xhci: Fix TRB physical to virtual address translation.
      USB: xhci: Fix scratchpad deallocation.

Sriram (2):
      smsc911x: Fix Console Hang when bringing the interface down.
      TI Davinci EMAC : Fix Console Hang when bringing the interface down

Stanislav O. Bezzubtsev (1):
      forcedeth: mac address fix

Stefani Seibold (1):
      procfs: fix /proc/<pid>/stat stack pointer for kernel threads

Stephen Rothwell (2):
      net: fix mdio section mismatch warning
      fcntl: Use consistent values for F_[GS]ETOWN_EX

Suresh Jayaraman (1):
      cifs: clear server inode number flag while autodisabling

Takashi Iwai (4):
      ALSA: hda - Add another Nvidia HDMI codec id (10de:0005)
      Input: psmouse - remove unneeded '\n' from psmouse.proto parameter
      ALSA: ice1724 - Fix section mismatch in prodigy_hd2_resume()
      ALSA: hda - Fix quirk for VAIO type G

Tejun Heo (2):
      percpu: restructure pcpu_extend_area_map() to fix bugs and improve readability
      workqueue: fix race condition in schedule_on_each_cpu()

Tero Kristo (1):
      omap3: clock: Fixed dpll3_m2x2 rate calculation

Thomas Gleixner (1):
      sh: Fixup last users of irq_chip->typename

Trond Myklebust (1):
      NFSv4: Fix a cache validation bug which causes getcwd() to return ENOENT

Troy Kisky (1):
      ASoC: tlv320aic23 fix rate selection

Vimal Singh (1):
      omap: Fix keymap for zoom2 according to matrix keypad framwork

Vlad Yasevich (3):
      sctp: Set source addresses on the association before adding transports
      sctp: Fix regression introduced by new sctp_connectx api
      sctp: Set socket source address when additing first transport

Wayne Boyer (1):
      [SCSI] ipr: add workaround for MSI interrupts on P7

Wey-Yi Guy (2):
      iwlwifi: Use RTS/CTS as the preferred protection mechanism for 6000 series
      iwlwifi: Fix issue on file transfer stalled in HT mode

Wolfgang Grandegger (1):
      can: add the missing netlink get_xstats_size callback

Yoichi Yuasa (1):
      MIPS: Add DMA declare coherent memory support

Zhang Le (1):
      USB: option.c: add support for D-Link DWM-162-U5

jack wang (1):
      [SCSI] libsas: do not set res = 0 in sas_ex_discover_dev()
