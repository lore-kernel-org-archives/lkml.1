Return-Path: <linux-kernel-owner+w=401wt.eu-S1753244AbYLBIfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbYLBIfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 03:35:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbYLBIfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 03:35:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:54791 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbYLBIfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 03:35:10 -0500
Date: Tue, 2 Dec 2008 08:35:07 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.37 released
Message-ID: <20081202083507.GA17731@hera.kernel.org>
Reply-To: w@1wt.eu
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 02 Dec 2008 08:35:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've just released Linux 2.4.37.

It brings a few driver updates to 2.4.36, with all the fixes present
in 2.4.36.9. More specifically, a lot of recent revisions of common
SATA controllers have been added. USB storage is now more convenient
to use (no more buggy renumbering of the devices). Several Geode LX
drivers have been added (watchdog, i2c, rng).

Quite a bunch of machines have been running -rc1 and -rc2 since they
were released, so I assume they're pretty solid now.

2.4.36 will still be maintained for one or two versions for those who
have not had the time to qualify 2.4.37-rc. You should start migration
tests now if you haven't yet.

Special note for those who force module loading from earlier versions.
A recent security fix has enlarged struct task, so binary modules from
older versions will probably not load/work on this new kernel. It's a
bad practice anyway to do that, but now you've been warned ;-)

Several people have requested inclusion of a few network drivers. I
will study the opportunity depending on whether it makes sense or not
to merge them for everyone in a future release.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/patch-2.4.37.bz2
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/ChangeLog-2.4.37

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/wtarreau/linux-2.4.git
  http://www.kernel.org/pub/scm/linux/kernel/git/wtarreau/linux-2.4.git/

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/wtarreau/linux-2.4.git


Have fun, and please report issues, as usual.
Willy

---

Full changelog since 2.4.36 :

final:
 - v2.4.37-rc2 was released as 2.4.37 with no changes.

Summary of changes from v2.4.37-rc1 to v2.4.37-rc2
============================================

Andy Gospodarek (1):
      bonding: fix panic when taking bond interface down before removing module

Arjan van de Ven (1):
      security: avoid calling a NULL function pointer in drivers/video/tvaudio.c

Ayaz Abdulla (1):
      forcedeth: fix checksum flag

David Miller (1):
      net: Fix recursive descent in __scm_destroy().

Eric Sandeen (1):
      ext: Avoid printk floods in the face of directory

Eric Sesterhenn (1):
      hfsplus: fix Buffer overflow with a corrupted image

Erik Inge Bolsø (1):
      doc: mention chain-compiling for really old gccs

Eugene Teo (2):
      CVE-2008-3275 Linux kernel local filesystem DoS
      Remove suid/sgid bits on truncate() (CVE-2008-4210)

Gilles Espinasse (1):
      tcp: Clear probes_out more aggressively in tcp_ack().

Ilpo Järvinen (1):
      netfilter: snmp nat leaks memory in case of failure

Jean Delvare (2):
      i2c: The i2c mailing list is moving
      i2c: Update comment of I2C_FUNC_SMBUS_*_I2C_BLOCK

Jouke Witteveen (1):
      sanitise mii.h for userspace

Marcel Sebek (1):
      backport vlan device unregister fix

Willy Tarreau (8):
      doc: fix examples and add suggestions about depmod
      ata_piix: get more PCI IDs in sync with 2.6 (ICH9/ICH10)
      i386: add configuration option for AMD Geode GX/LX
      i2c: add support for Geode Companion CS5535/5536 to scx200_acb
      i386: add support for AMD Geode MFGPT timers
      wdt: add support for AMD Geode GX/LX watchdog
      char: add support for AMD Geode LX hardware RNG
      Change VERSION to 2.4.37-rc2

Yasuyuki KOZAKAI (1):
      netfilter: ip6t_{hbh,dst}: Rejects not-strict mode on rule insertion

Summary of changes from v2.4.36 to v2.4.37-rc1
============================================

Al Viro (1):
      Fix SMP ordering hole in fcntl_setlk() (CVE-2008-1669)

Axel Reinhold (1):
      add ICH9x support to ahci driver

Carsten (1):
      usb: add support for ADM8515 to pegasus.h

Chris Wright (1):
      asn1: additional sanity checking during BER decoding (CVE-2008-1673)

David Newall (1):
      usb-serial: back-port of pl2303.c from 2.6.24.1

David S. Miller (3):
      sit: Add missing kfree_skb() on pskb_may_pull() failure (CVE-2008-2136)
      sparc: Fix mmap VA span checking (CVE-2008-2137)
      sctp: Make sure N * sizeof(union sctp_addr) does not overflow (CVE-2008-2826)

Emeric Brun (1):
      x86 SMP: don't report error on uniprocessor machines

Erik Andersen (1):
      2.4.x USB and 1394 hotplug

Eugene Teo (1):
      wan: Missing capability checks in sbni_ioctl() (CVE-2008-3525)

Florin Malita (1):
      [PPPOE]: Missing result check in __pppoe_xmit().

Gilbert Ashley (1):
      Kernel patch to add rootdelay feature

Gilbert Ashley Gilbert (1):
      udf: fix uid/gid permissions

Gilles Espinasse (2):
      PCI ID updates for amd74xx
      ahci driver update

Glen Nakamura (3):
      ext2_readdir() filp->f_pos fix (try #2)
      Duplicate id in videodev.h
      Fix typo in acpi_boot_init

Gunnar Larisch (1):
      3c980-TX needs EXTRA_PREAMBLE

Herbert Xu (1):
      net pppoe: Check packet length on all receive paths

Ivaylo Josifov (1):
      ide-generic: Marvell IDE 88SE6101 2.4.XX support

Jesse Brandeburg (1):
      ip-pnp-dhcp: wait lazily when doing dhcp for diskless systems

Li Zefan (1):
      ACPI: check a return value correctly in acpi_power_get_context()

Patrick McHardy (1):
      [TCP]: Fix shrinking windows with window scaling

Roel Kluin (1):
      wireless, airo: waitbusy() won't delay

Solar Designer (1):
      IDE: fix panic during probe with negative IRQ

Stephen Hemminger (1):
      ipv6: use timer pending

Steve Rosenbluth (3):
      signal.h: use an explicit cast to silent compiler warnings
      fix build error with some flavours of gcc 2.95.3
      ata_piix: add PCI ID for intel ICH8 controller

Unknown (1):
      linux-2.4 CLASSIFY patch.

Vlad Yasevich (2):
      sctp: Do not leak memory on multiple listen() calls
      sctp: Allow only 1 listening socket with SO_REUSEADDR

Willy Tarreau (15):
      Do not complain about gcc 4.2 for user-space
      i386: fix setCx86/getCx86 race in macros
      security: insufficient range checks in certain fault handlers
      intermezzo: fix uninitialized use of pointer in error path
      Fix dnotify/close race (CVE-2008-1375)
      ide-generic: add support for JMicron 368
      ide-generic: add support for Marvell 6145 PATA port
      ata_piix: add support for ICH9 in IDE mode
      doc: explain how to build a suitable gcc in Documentation/using-newer-gcc.txt
      sound: fix warning due to incorrect error code checking in ad1889
      sky2: fix uninitialized "mss" variable in sky2_xmit_frame()
      x86 would not build without CONFIG_VT
      via-rhine: fix mii duplex detection during link monitoring
      pc_keyb: fix breakage on ia64/mips/mips64
      Change VERSION to 2.4.37-rc1

Xiong Wu (1):
      Correct the upto value during list conntrack information

dann frazier (8):
      avoid semi-infinite loop when mounting bad ext2
      ext2: skip pages past number of blocks in ext2_find_entry
      memory leak when socket is release()d before PPPIOCGCHAN has been called on it
      2.4: fix memory corruption from misinterpreted bad_inode_ops return values
      2.4: [SCSI] aacraid: Fix security hole
      2.4: USB: fix DoS in pwc USB video driver
      2.4: [POWERPC] CHRP: Fix possible NULL pointer dereference
      old buffer overflow in moxa driver (CVE-2005-0504)

Regards,
Willy

