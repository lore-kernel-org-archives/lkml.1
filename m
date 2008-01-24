Return-Path: <linux-kernel-owner+w=401wt.eu-S1759051AbYAXXRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759051AbYAXXRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 18:17:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbYAXXR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 18:17:26 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44325 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757971AbYAXXRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 18:17:23 -0500
Date: Thu, 24 Jan 2008 15:17:19 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.24
Message-ID: <alpine.LFD.1.00.0801241506500.15329@hp.linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The release is out there (both git trees and as tarballs/patches), and for 
the next week many kernel developers will be at (or flying into/out of) 
LCA in Melbourne, so let's hope it's a good one.

Nothing earth-shattering happened since -rc8, although the new set of ACPI 
blacklist entries and some network driver updates makes the diffstat show 
that there was more than the random sprinkling of one-liners all over the 
tree.

But most of it really is one-liners, and mostly not very exciting ones at 
that.

The appended shortlog is obviously just the changes from -rc8, if you want 
the full ChangeLog (all 5.8MB of it) from 2.6.23 it's available in the 
usual places.

			Linus

---
Adrian Bunk (2):
      [ATM] atm/idt77105.c: Fix section mismatch.
      [ATM] atm/suni.c: Fix section mismatch.

Al Viro (9):
      dscc4 endian fixes
      wan/lmc bitfields fixes
      sbni endian fixes
      3c574, 3c515 bitfields abuse
      dl2k: BMCR_t fixes
      dl2k: ANAR, ANLPAR fixes
      dl2k: BMSR fixes
      dl2k: MSCR, MSSR, ESR, PHY_SCR fixes
      dl2k: the rest

Alan Cox (2):
      pata_pdc202xx_old: Fix crashes with ATAPI
      keyspan: fix oops

Alex (1):
      fix radeonfb regression with Xpress 200m 5955

Alexey Starikovskiy (2):
      ACPI: processor: Fix null pointer dereference in throttling
      ACPI: EC: fix dmesg spam regression

Andres Salomon (2):
      Input: psmouse - fix potential memory leak in psmouse_connect()
      Input: psmouse - fix input_dev leak in lifebook driver

Andrew Dyer (1):
      [WATCHDOG] clarify watchdog operation in documentation

Andrew G. Morgan (1):
      Fix filesystem capability support

Anton Salikhmetov (1):
      Update ctime and mtime for memory-mapped files

Arjan van de Ven (2):
      x86: add support for the latest Intel processors to Oprofile
      lockdep: fix kernel crash on module unload

Atsushi Nemoto (1):
      tc35815: Use irq number for tc35815-mac platform device id

Bjorn Helgaas (1):
      hwmon: (it87) request only Environment Controller ports

Carlos Martín (2):
      agp/intel: add support for E7221 chipset
      drm/i915: add support for E7221 chipset

Carsten Otte (1):
      #ifdef very expensive debug check in page fault path

Cyrill Gorcunov (1):
      CRIS: add missed local_irq_restore call

Dan Williams (1):
      [ARM] 4748/1: dca: source drivers/dca/Kconfig in arch/arm/Kconfig to fix warning

Daniel Ritz (1):
      Input: usbtouchscreen - fix buffer overflow, make more egalax work

Daniel Walker (2):
      fix wrong sized spinlock flags argument
      ARM: OMAP1: Fix compile for board-nokia770

Dave Young (1):
      [BLUETOOTH]: Move children of connection device to NULL before connection down.

David Fries (2):
      W1: w1_therm.c ds18b20 decode freezing temperatures correctly
      W1: w1_therm.c is flagging 0C etc as invalid

David S. Miller (8):
      [NET]: Fix TX timeout regression in Intel drivers.
      [NIU]: Fix 1G PHY link state handling.
      [SPARC64]: Fix hypervisor TLB operation error reporting.
      [NET]: Fix interrupt semaphore corruption in Intel drivers.
      [NEIGH]: Revert 'Fix race between neigh_parms_release and neightbl_fill_parms'
      [TULIP] DMFE: Fix SROM parsing regression.
      [IPV4]: Add missing skb->truesize increment in ip_append_page().
      [SPARC64]: Partially revert "Constify function pointer tables."

Denis V. Lunev (1):
      [NETNS]: Re-export init_net via EXPORT_SYMBOL.

Dmitri Vorobiev (1):
      [MIPS] Malta: Fix reading the PCI clock frequency on big-endian

Dmitry Torokhov (1):
      Input: ALPS - fix sync loss on Acer Aspire 5720ZG

Eric Dumazet (1):
      [IPV4] FIB_HASH : Avoid unecessary loop in fn_hash_dump_zone()

Eric Paris (1):
      rfkill: call rfkill_led_trigger_unregister() on error

Eric Sandeen (1):
      hfs: fix coverity-found null deref

Eric W. Biederman (1):
      sysctl: kill binary sysctl KERN_PPC_L2CR

Francois Romieu (8):
      ipg: balance locking in irq handler
      ipg: plug Tx completion leak
      ipg: fix queue stop condition in the xmit handler
      ipg: fix Tx completion irq request
      sis190: add cmos ram access code for the SiS19x/968 chipset pair
      sis190: remove duplicate INIT_WORK
      sis190: mdio operation failure is not correctly detected
      sis190: scheduling while atomic error

Frank Rowand (1):
      [MIPS] SMTC: Fix build error.

Herbert Xu (1):
      [INET]: Fix truesize setting in ip_append_data

Ingo Molnar (1):
      sched: group scheduler, set uid share fix

Ivan Kokshaysky (1):
      alpha: fix conversion from denormal float to double

Ivo van Doorn (1):
      rt2x00: Fix ieee80211 payload alignment

Jan Engelhardt (1):
      [SPARC]: Constify function pointer tables.

Jason Uhlenkott (1):
      e1000e Kconfig: remove ref to nonexistant docs

Jay Cliburn (1):
      atl1: fix frame length bug

Jay Vosburgh (7):
      bonding: fix locking in sysfs primary/active selection
      bonding: fix ASSERT_RTNL that produces spurious warnings
      bonding: fix locking during alb failover and slave removal
      bonding: release slaves when master removed via sysfs
      bonding: Fix up parameter parsing
      bonding: fix lock ordering for rtnl and bonding_rwsem
      bonding: Don't hold lock when calling rtnl_unlock

Jeremy Fitzhardinge (1):
      xen: disable vcpu_info placement for now

Jesper Juhl (1):
      [IrDA]: af_irda memory leak fixes

Jesper Nilsson (1):
      CRIS v10: vmlinux.lds.S: ix kernel oops on boot and use common defines

Johann Felix Soden (1):
      Fix file references in documentation and Kconfig

Johannes Berg (1):
      lockdep: fix workqueue creation API lockdep interaction

Johannes Weiner (1):
      cpufreq: Initialise default governor before use

Jonas Bonn (1):
      jbd: do not try lock_acquire after handle made invalid

Joonwoo Park (2):
      [IPV4] fib_hash: fix duplicated route issue
      [IPV4] fib_trie: fix duplicated route issue

Jordan Crouse (1):
      x86: GEODE fix a race condition in the MFGPT timer tick

Josef 'Jeff' Sipek (1):
      arch: Ignore arch/i386 and arch/x86_64

Kalle Valo (1):
      spi: omap2_mcspi PIO RX fix

Larry Woodman (1):
      fix hugepages leak due to pagetable page sharing

Len Brown (10):
      pnpacpi: print resource shortage message only once (more)
      DMI: move dmi_available declaration to linux/dmi.h
      DMI: create dmi_get_slot()
      ACPI: create acpi_dmi_dump()
      ACPI: on OSI(Linux), print needed DMI rather than requesting dmidecode output
      ACPI: Delete Intel Customer Reference Board (CRB) from OSI(Linux) DMI list
      ACPI: make _OSI(Linux) console messages smarter
      ACPI: Add ThinkPad R61, ThinkPad T61 to OSI(Linux) white-list
      ACPI: DMI blacklist to reduce console warnings on OSI(Linux) systems.
      Revert "ACPI: Fan: Drop force_power_state acpi_device option"

Li Zefan (1):
      Revert "local_t Documentation update"

Linus Nilsson (1):
      Makefile: Change typoed 'behavour' to 'behaviour'

Linus Torvalds (2):
      Revert "mac80211: warn when receiving frames with unaligned data"

Marc Pignat (1):
      wireless/libertas support for 88w8385 sdio older revision

Matteo Croce (1):
      Replace cpmac fix

Matti Linnanvuori (1):
      Documentation: add a guideline for hard_start_xmit method

Mel Gorman (1):
      slab: partially revert list3 changes

Micah Parrish (1):
      Input: mousedev - handle mice that use absolute coordinates

Márton Németh (2):
      ACPI: EC: add leading zeros to debug messages
      ACPI: EC: "DEBUG" needs to be defined earlier

Nick Piggin (1):
      lockdep: fix internal double unlock during self-test

Nigel Cunningham (1):
      Fix unbalanced helper_lock in kernel/kmod.c

Patrick McHardy (3):
      [NETFILTER]: bridge-netfilter: fix net_device refcnt leaks
      [AF_KEY]: Fix skb leak on pfkey_send_migrate() error
      [NET]: rtnl_link: fix use-after-free

Paul Moore (1):
      selinux: fix memory leak in netlabel code

Pavel Emelyanov (1):
      [IPV6]: Mischecked tw match in __inet6_check_established.

Peter Zijlstra (1):
      lockdep: more hardirq annotations for notify_die()

Ralph Campbell (1):
      IB/ipath: Fix receiving UD messages with immediate data

Randy Dunlap (4):
      hostap: section mismatch warning
      hrtimer: fix section mismatch
      timer: fix section mismatch
      rcu: fix section mismatch

Reinette Chatre (1):
      iwlwifi: fix possible read attempt on ucode that is not available

Russell King (1):
      [ARM] pxa: don't rely on r2 being preserved over a function call

Rusty Russell (2):
      Selecting LGUEST should turn on Guest support, as in 2.6.23.
      Remove bogus duplicate CONFIG_LGUEST_GUEST entry.

Sam Ravnborg (3):
      mm: fix section mismatch warning in page_alloc.c
      [SPARC64]: Fix of section mismatch warnings.
      [SPARC64]: Fix section error in sparcspkr

Sreenivasa Honnur (1):
      S2io: Fixed synchronization between scheduling of napi with card reset and close

Stefan Schmidt (1):
      s3c2410_fb: fix line length calculation

Stefano Brivio (2):
      ipw2200: fix typo in kerneldoc
      b43: fix use-after-free rfkill bug

Stephen Hemminger (1):
      Revert "sky2: remove check for PCI wakeup setting from BIOS"

Stuart Swales (1):
      [SCSI] initio: fix module hangs on loading

Tejun Heo (2):
      sysfs: make sysfs_lookup() return ERR_PTR(-ENOENT) on failed lookup
      sysfs: fix bugs in sysfs_rename/move_dir()

Thomas Gleixner (1):
      Revert "x86: fix NMI watchdog & 'stopped time' problem"

Vivek Kutal (1):
      ARM: OMAP1: Keymap fix for f-sample and p2-sample

Wang Chen (3):
      [IPV6]: ICMP6_MIB_OUTMSGS increment duplicated
      [IPV6]: RFC 2011 compatibility broken
      [ICMP]: ICMP_MIB_OUTMSGS increment duplicated

Wim Van Sebroeck (1):
      [WATCHDOG] Revert "Stop looking for device as soon as one is found"

YOSHIFUJI Hideaki (1):
      [IPV6] ROUTE: Make sending algorithm more friendly with RFC 4861.

