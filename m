Return-Path: <linux-kernel-owner+w=401wt.eu-S1751869AbYLXXxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbYLXXxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 18:53:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbYLXXww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 18:52:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46548 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751273AbYLXXwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 18:52:51 -0500
Date: Wed, 24 Dec 2008 15:52:49 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Happy v2.6.28
Message-ID: <alpine.LFD.2.00.0812241540170.3535@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It doesn't really matter what day it is, or what holiday (if any) you're 
celebrating, because even if you sit at home, alone in your dank basement, 
without any holidays or friends, I bring you a tiding of great cheer: you 
can now download Linux-2.6.28, and compile it to your hearts content!

Listen to the cheerful grinding of your harddisk as you reboot into an 
all-new kernel - and I'm sure that if your computer could smile, it would 
have a big silly grin on its non-existent face. So as you sit there in 
your basement, give your computer the holiday cheer too.

In fact, even _if_ you have friends or family, leave them to their endless 
toil over that christmas ham or turkey, and during the night, when they're 
asleep, you can give them that magical present of a newly updated 
computer. When they wake up tomorrow morning, tell them how you saw Santa 
crawl down the chimney with his USB stick in hand, updating the OS of all 
good boys and girls.

Ho, ho, ho,

		Linus "almost Santa" Torvalds

---
Not a whole lot has changed since -rc9: some DVB updates, some AMD IOMMU 
stuff, a few scsi driver updates, and some PCI hotplug regression fixes.

The dirstat looks complicated:

  11.3% arch/x86/kernel/
  11.3% arch/x86/
  12.9% arch/
   4.9% drivers/acpi/
   5.3% drivers/md/
  19.0% drivers/media/dvb/dvb-usb/
  23.2% drivers/media/dvb/
   5.8% drivers/media/video/
  29.1% drivers/media/
   5.1% drivers/net/
  12.6% drivers/pci/hotplug/
  13.2% drivers/pci/
   7.5% drivers/scsi/
  70.0% drivers/
   7.4% fs/9p/

but in fact it all boils down to just a couple hundred changed lines, in 
just 70 commits (average size: 5 lines each).

Andi Kleen (1):
      x86: re-enable MCE on secondary CPUS after suspend/resume

Antti Seppälä (1):
      V4L/DVB (9781): [PATCH] Cablestar 2 I2C retries (fix CableStar2 support)

Bjorn Helgaas (2):
      x86 gart: don't complain if no AMD GART found
      ACPI: fix 2.6.28 acpi.debug_level regression

Brian King (1):
      [SCSI] ibmvstgt: move crq_queue_create to the end of initialization

Chris Elston (1):
      rtc: rtc-isl1208: reject invalid dates

Dave Airlie (2):
      drm/i915: GEM on PAE has problems - disable it for now.
      drm/radeon: fix correctness of irq_enabled check for radeon.

David Daney (2):
      MIPS: Fix preprocessor warnings flaged by GCC 4.4
      MIPS: MIPS64R2: Fix buggy __arch_swab64

Devin Heitmueller (2):
      V4L/DVB (9780): dib0700: Stop repeating after user stops pushing button
      V4L/DVB (9920): em28xx: fix NULL pointer dereference in call to VIDIOC_INT_RESET command

Dmitry Adamushko (1):
      x86: fix resume (S2R) broken by Intel microcode module, on A110L

Duane Griffin (1):
      9p: Remove potentially bad parameter from function entry debug print.

Eric Anholt (1):
      drm/i915: Don't return busy for buffers left on the flushing list.

Evgeniy Polyakov (1):
      w1: fix slave selection on big-endian systems

Hans Verkuil (1):
      V4L/DVB (9906): v4l2-compat: test for unlocked_ioctl as well.

Harry Ciao (1):
      edac: fix edac core deadlock when removing a device

Herton Ronaldo Krzesinski (1):
      ALSA: hda - Add missing terminators in patch_sigmatel.c

Hidetoshi Seto (1):
      PCI: fix aer resume sanity check

Hillier, Gernot (1):
      [SCSI] aacraid: disable Dell Percraid quirk on Adaptec 2200S and 2120S

Ingo Molnar (1):
      x86: disable X86_PTRACE_BTS

James Bottomley (2):
      [SCSI] scsi_lib: only call scsi_unprep_request() under queue lock
      [SCSI] mpt fusion: clear list of outstanding commands on host reset

James Chapman (1):
      ppp: fix segfaults introduced by netdev_priv changes

Jim Paris (1):
      V4L/DVB (9875): gspca - main: Fix vidioc_s_jpegcomp locking.

Jiri Slaby (1):
      V4L/DVB (9908a): MAINTAINERS: mark linux-uvc-devel as subscribers only

Joerg Roedel (3):
      AMD IOMMU: allocate rlookup_table with __GFP_ZERO
      AMD IOMMU: set cmd buffer pointers to zero manually
      AMD IOMMU: panic if completion wait loop fails

Joerg Schirottke (1):
      ALSA: hda - Add quirk for Dell Studio 17

Julia Lawall (2):
      fs/9p: change simple_strtol to simple_strtoul
      drivers/ide/{cs5530.c,sc1200.c}: Move a dereference below a NULL test

Justin Chen (1):
      PCI hotplug: acpiphp wants a 64-bit _SUN

Kenji Kaneshige (1):
      PCI: pciehp: fix unexpected power off with pciehp_force

Kyle McMartin (1):
      parisc: disable UP-optimized flush_tlb_mm

Li Zefan (1):
      cgroups: avoid accessing uninitialized data in failure path

Linus Torvalds (1):
      Linux 2.6.28

Mauro Carvalho Chehab (1):
      V4L/DVB (9885): drivers/media Kconfig's: fix bugzilla #12204

Mike Christie (1):
      [SCSI] libiscsi REGRESSION: fix passthrough support with older iscsi tools

Neil Horman (1):
      PCI hotplug: ibmphp: Fix module ref count underflow

NeilBrown (1):
      md: Don't read past end of bitmap when reading bitmap.

Sharyathi Nagesh (1):
      cgroups: suppress bogus warning messages

Stanley Miao (1):
      ALSA: Fix a Oops bug in omap soc driver.

Stephen M. Cameron (1):
      cciss: fix problem that deleting multiple logical drives could cause a panic

Takashi Iwai (4):
      ALSA: hda - Fix silent HP output on D975
      ALSA: Revert "ALSA: hda: removed unneeded hp_nid references"
      ALSA: hda - Add no-jd model for IDT 92HD73xx
      ALSA: hda - Remove non-working headphone control for Dell laptops

Thomas Gleixner (1):
      Null pointer deref with hrtimer_try_to_cancel()

Wei Yongjun (1):
      net: Fix module refcount leak in kernel_accept()

Wu Fengguang (2):
      ACPI: don't cond_resched() when irqs_disabled()
      9p: convert d_iname references to d_name.name
