Return-Path: <linux-kernel-owner+w=401wt.eu-S1752506AbXBDTKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbXBDTKk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 14:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbXBDTKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 14:10:40 -0500
Received: from smtp.osdl.org ([65.172.181.24]:47218 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506AbXBDTKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 14:10:39 -0500
Date: Sun, 4 Feb 2007 11:10:36 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Super Kernel Sunday!
Message-ID: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463790079-1864330079-1170616236=:8424"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463790079-1864330079-1170616236=:8424
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT


In a widely anticipated move, Linux "headcase" Torvalds today announced
the immediate availability of the most advanced Linux kernel to date,
version 2.6.20.

Before downloading the actual new kernel, most avid kernel hackers have
been involved in a 2-hour pre-kernel-compilation count-down, with some
even spending the preceding week doing typing exercises and reciting PI
to a thousand decimal places.

The half-time entertainment is provided by randomly inserted trivial
syntax errors that nerds are expected to fix at home before completing
the compile, but most people actually seem to mostly enjoy watching the
compile warnings, sponsored by Anheuser-Busch, scroll past. 

As ICD head analyst Walter Dickweed put it: "Releasing a new kernel on
Superbowl Sunday means that the important 'pasty white nerd'
constituency finally has something to do while the rest of the country
sits comatose in front of their 65" plasma screens". 

Walter was immediately attacked for his racist and insensitive remarks
by Geeks without Borders representative Marilyn vos Savant, who pointed
out that not all of their members are either pasty nor white.  "Some of
them even shower!" she added, claiming that the constant stereotyping
hurts nerds' standing in society. 

Geeks outside the US were just confused about the whole issue, and were
heard wondering what the big hoopla was all about. Some of the more
culturally aware of them were heard snickering about balls that weren't
even round.

                      Linus

---

Shortlog since 2.6.20-rc7. Fixes, fixes.

There's a full ChangeLog together with the tar-ball and patches, but let 
me just summarize it as: "A lot of stuff. All over. And KVM."

I tried rather hard to make 2.6.20 largely a "stabilization release". 
Unlike a lot of kernels lately, there aren't really any big fundamental 
changes to some core infrastructure area, and while we always have bugs, I 
really am hoping that we fixed many more than we introduced. 

Have fun. And remember: the thousandth decimal is, of course, 9. There 
*will* be a test on this afterwards.


Adrian Bunk (1):
      [NETFILTER]: nf_conntrack_h323: fix compile error with CONFIG_IPV6=m, CONFIG_NF_CONNTRACK_H323=y

Al Viro (12):
      netxen patches
      fix frv headers_check
      mca_nmi_hook() can be called at any point
      ide section fixes
      endianness bug: ntohl() misspelled as >> 24 in fh_verify().
      fork_idle() should be __cpuinit, not __devinit
      __crc_... is intended to be absolute
      efi_set_rtc_mmss() is not __init
      sanitize sections for sparc32 smp
      radio modems sitting on serial port are not for s390
      uml-i386: fix build breakage with CONFIG_HIGHMEM
      fix rtl8150

Alan (3):
      pata_atiixp: propogate cable detection hack from drivers/ide to the new driver
      pata_via: Correct missing comments
      libata: Fix ata_busy_wait() kernel docs

Andrew Morton (2):
      pci: remove warning messages
      revert blockdev direct io back to 2.6.19 version

Auke Kok (1):
      e100: fix napi ifdefs removing needed code

Avi Kivity (1):
      KVM: fix lockup on 32-bit intel hosts with nx disabled in the bios

Bartlomiej Zolnierkiewicz (1):
      via82cxxx: fix typo ("cx7000" should be corrected to "cx700")

Bob Breuer (1):
      [SPARC32]: Fix over-optimization by GCC near ip_fast_csum.

Brian King (1):
      libata: Initialize nbytes for internal sg commands

David C Somayajulu (1):
      [SCSI] qla4xxx: bug fixes

Evgeniy Dushistov (1):
      MAINTAINERS: ufs entry

Frédéric Riss (1):
      EFI x86: pass firmware call parameters on the stack

Guillaume Chazarain (1):
      procfs: Fix listing of /proc/NOT_A_TGID/task

Haavard Skinnemoen (1):
      Remove avr32@atmel.com from MAINTAINERS

Jean Delvare (1):
      via quirk update

Jeff Garzik (1):
      x86-64: define dma noncoherent API functions

Jens Osterkamp (1):
      spidernet : fix memory leak in spider_net_stop

John Keller (1):
      Altix: more ACPI PRT support

Kai Makisara (1):
      [SCSI] st: A MTIOCTOP/MTWEOF within the early warning will cause the file number to be incorrect

Ken Chen (1):
      aio: fix buggy put_ioctx call in aio_complete - v2

Lars Immisch (1):
      [NETFILTER]: SIP conntrack: fix skipping over user info in SIP headers

Li Yewang (1):
      [IPV6]: fix BUG of ndisc_send_redirect()

Linus Torvalds (3):
      Revert "[PATCH] mm: micro optimise zone_watermark_ok"
      Revert "[PATCH] fix typo in geode_configre()@cyrix.c"
      Linux 2.6.20

Magnus Damm (1):
      kexec: Avoid migration of already disabled irqs (ia64)

Matthew Wilcox (1):
      [SCSI] Fix scsi_add_device() for async scanning

Michael Chan (1):
      [BNX2]: PHY workaround for 5709 A0.

Mike Frysinger (1):
      alpha: fix epoll syscall enumerations

Nagendra Singh Tomar (1):
      [SCSI] sd: udev accessing an uninitialized scsi_disk field results in a crash

Neil Horman (1):
      [IPV6]: Fix up some CONFIG typos

Patrick McHardy (5):
      [NETFILTER]: xt_connbytes: fix division by zero
      [NETFILTER]: SIP conntrack: fix out of bounds memory access
      [NETFILTER]: xt_hashlimit: fix ip6tables dependency
      [NET_SCHED]: act_ipt: fix regression in ipt action
      [NETFILTER]: ctnetlink: fix compile failure with NF_CONNTRACK_MARK=n

Peter Korsgaard (1):
      net/smc911x: match up spin lock/unlock

Randy Dunlap (2):
      [MAINTAINERS]: netfilter@ is subscribers-only
      sysrq: showBlockedTasks is sysrq-W

Tejun Heo (1):
      ahci/pata_jmicron: fix JMicron quirk

Vlad Yasevich (1):
      [SCTP]: Force update of the rto when processing HB-ACK

---1463790079-1864330079-1170616236=:8424--
