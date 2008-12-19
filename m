Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279AbYLSBeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbYLSBeO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 20:34:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbYLSBd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 20:33:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60579 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750789AbYLSBd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 20:33:56 -0500
Date: Thu, 18 Dec 2008 17:33:47 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.28-rc9
Message-ID: <alpine.LFD.2.00.0812181724000.14014@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There really is _nothing_ interesting here. There's just small changes 
mostly to random drivers, with some networking updates. Oh, and some MIPS 
defconfig updates.

The shortlog really tells the whole boring story - if you can get even 
half-way through without falling asleep, you've just proven yourself to be 
sufficiently caffeinated.

In fact, that may be the most exciting part of -rc9: the medical 
revolution it harbors as a caffeine deficiency test.

But please do test it.

And btw, I do think that I'll make 2.6.28 be a Christmas release (or 
Hanukkah, Kwanzaa, Solstice, Insert-Favorite-Holiday, whatever). Because 
quite frankly, this kind of boredom won't help anything and I'll go stir 
crazy if I have to do this for another two weeks.

And I'll make the merge window longer for people who prefer getting drunk 
on glögg to being a useful kernel developer. Although you could do both: 
just prepare your tree to be pulled before christmas, and then you can be 
in a mulled-wine-induced stupor while _also_ feeling like a productive 
member of society during the holidays.

			Linus

---
Alan Cox (1):
      USB: tty: SprogII DCC controller identifiers

Alan D. Brunelle (1):
      Commands needing to be retried require a complete re-initialization.

Alan Stern (2):
      usb-storage: update unusual_devs entry for Nokia 5310
      USB: skip Set-Interface(0) if already in altsetting 0

Alexander Beregalov (1):
      IA64: HP_SIMETH needs to depend upon NET

Anders Blomdell (1):
      avr32: Enable pullup on USART TX lines

Andrew Ewert (1):
      USB: ftdi_sio: Adding Ewert Energy System's CANdapter PID

Arnd Bergmann (1):
      powerpc/cell/axon-msi: Fix MSI after kexec

Baruch Siach (1):
      enc28j60: use netif_rx_ni() to deliver RX packets

Ben Dooks (1):
      i2c-s3c2410: fix check for being in suspend.

Brian King (1):
      powerpc: Check for valid hugepage size in hugetlb_get_unmapped_area

CSÉCSY László (1):
      USB: storage: unusual_devs.h: Nokia 3109c addition

Catalin Marinas (1):
      slob: do not pass the SLAB flags as GFP in kmem_cache_create()

Dan Williams (3):
      ioat: wait for self-test completion
      dmaengine: protect 'id' from concurrent registrations
      async_xor: dma_map destination DMA_BIDIRECTIONAL

Dave Hansen (1):
      powerpc: Fix bootmem reservation on uninitialized node

Dave Liu (1):
      powerpc/fsl-booke: Fix the miss interrupt restore

David Brownell (1):
      USB: gadget: fix rndis working at high speed

David Daney (3):
      MIPS: Use EI/DI for MIPS R2.
      MIPS: Add missing calls to plat_unmap_dma_mem.
      MIPS: IP32: Update defconfig

David S. Miller (2):
      sungem: Make PCS PHY support partially work again.
      sparc: We need to implement arch_ptrace_stop().

Dmitri Vorobiev (1):
      MIPS: Kconfig: Fix the arch-specific header path

Dmitry Baryshkov (1):
      STAGING: Move staging drivers back to staging-specific menu

Doug Leith (1):
      tcp: tcp_vegas cong avoid fix

Frederik Deweerdt (1):
      ACPI toshiba: only register rfkill if bt is enabled

Greg Kroah-Hartman (2):
      USB: fix problem with usbtmc driver not loading properly
      xilinx_hwicap: remove improper wording in license statement

Guillaume Knispel (1):
      powerpc: Fix corruption error in rh_alloc_fixed()

Haavard Skinnemoen (2):
      ATSTK1006: Fix boot from NAND flash
      avr32: favr-32 build fix

Hans-Christian Egtvedt (1):
      avr32: remove .note.gnu.build-id section when making vmlinux.bin

Harvey Harrison (2):
      i2c-pmcmsp: Fix endianness misannotation
      i2c-highlander: Trivial endian casting fixes

Hermann Lauer (1):
      sungem: improve ethtool output with internal pcs and serdes

Ingo Brueckl (2):
      unicode table for cp437
      console ASCII glyph 1:1 mapping

Jan Sembera (1):
      ipv6: silence log messages for locally generated multicast

Jarek Poplawski (1):
      drivers/net: starfire: Fix napi ->poll() weight handling

Jeff Kirsher (1):
      e1000e: fix double release of mutex

Jeff Layton (1):
      cifs: fix buffer overrun in parse_DFS_referrals

Jesper Dangaard Brouer (1):
      SCHED: netem: Correct documentation comment in code.

Joel Becker (1):
      ocfs2: Add JBD2 compat feature bit.

Johann Felix Soden (1):
      driver core: fix using 'ret' variable in unregister_dynamic_debug_module

John McCutchan (1):
      Maintainer email fixes for inotify

Josh Boyer (1):
      powerpc/40x: Add proper BOOTCFLAGS for cuboot-acadia

Julia Lawall (1):
      [ARM] arch/arm/common/sa1111.c: Correct error handling code

KOSAKI Motohiro (1):
      mm: Don't touch uninitialized variable in do_pages_stat_array()

Krzysztof Halasa (1):
      net: kernel BUG at drivers/net/phy/mdio_bus.c:165!

Kumar Gala (1):
      powerpc/fsl-booke: Fix problem with _tlbil_va being interrupted

Linus Torvalds (3):
      Revert "radeonfb: accelerate imageblit and other improvements"
      Revert "sched_clock: prevent scd->clock from moving backwards"
      Linux 2.6.28-rc9

Marcel Holtmann (1):
      driver core: add newlines to debugging enabled/disabled messages

Matt Fleming (1):
      sh: maple: Do not pass SLAB_POISON to kmem_cache_create()

Matthew Arnold (1):
      USB: add 5372:2303 to pl2303

Michael Chan (1):
      bnx2: Fix bug in bnx2_free_rx_mem().

Michael Halcrow (1):
      eCryptfs: Update maintainers

Mike Ditto (1):
      i2c-cpm: Detect and report NAK right away instead of timing out

Mike Frysinger (1):
      pcmcia: blackfin: fix bug - add missing ; to MODULE macro

Mike Provencher (1):
      USB: pl2303: add id for Hewlett-Packard LD220-HP POS pole display

Neil Horman (1):
      netpoll: fix race on poll_list resulting in garbage entry

Nicolas Pitre (2):
      [ARM] 5341/2: there is no copy_page on nommu ARM
      [ARM] 5348/1: fix documentation wrt location of the alignment trap interface

Oliver Neukum (1):
      USB: set correct configuration in probe of ti_usb_3410_5052

Ozan Sener (1):
      USB: Unusual devs patch for Nokia 3500c

Pablo Neira Ayuso (1):
      netfilter: ctnetlink: fix missing CTA_NAT_SEQ_UNSPEC

Paul Menage (1):
      cgroups: fix a race between rmdir and remount

Paul Moore (1):
      netlabel: Compiler warning and NULL pointer dereference fix

Paul Mundt (1):
      sh: Disable GENERIC_HARDIRQS_NO__DO_IRQ for unconverted platforms.

Pete Zaitcev (1):
      usbmon: drop bogus 0t from usbmon.txt

Peter Korsgaard (1):
      USB: Documentation/usb/gadget_serial.txt: update to match driver use_acm behaviour

Phil Endecott (1):
      USB: fix comment about endianness of descriptors

Randy Dunlap (1):
      [ARM] fix kernel-doc syntax

Russell King (1):
      [ARM] Ensure linux/hardirqs.h is included where required

Rusty Russell (1):
      Define smp_call_function_many for UP

Rémi Denis-Courmont (1):
      Phonet: keep TX queue disabled when the device is off

Sakari Ailus (2):
      tlan: Fix small (< 64 bytes) datagram transmissions
      tlan: Fix pci memory unmapping

Samuel Ortiz (1):
      irda: Add irda_skb_cb qdisc related padding

Stefan Richter (1):
      ieee1394: add quirk fix for Freecom HDD

Steven Rostedt (1):
      netfilter: update rwlock initialization for nat_table

Tao Ma (1):
      ocfs2: Always update xattr search when creating bucket.

Tejun Heo (3):
      libata: fix Seagate NCQ+FLUSH blacklist
      pata_hpt366: fix cable detection,
      pata_hpt366: no ATAPI DMA

Zachary Amsden (1):
      x86 Fix VMI crash on boot in 2.6.28-rc8

cwm97m (1):
      jme: Fixed a typo
