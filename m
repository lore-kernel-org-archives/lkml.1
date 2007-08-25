Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbXHYPi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbXHYPi0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 11:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbXHYPiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 11:38:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:57768 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbXHYPiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 11:38:16 -0400
Date: Sat, 25 Aug 2007 15:38:10 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Linux 2.6.20.17
Message-ID: <20070825153810.GA32619@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I've just released Linux 2.6.20.17.

As a reminder, it fixes these 3 security issues :
  CVE-2007-3105
  CVE-2007-3848
  CVE-2007-3851

I'll also be replying to this message with a copy of the patch between
2.6.20.16 and 2.6.20.17.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/patch-2.6.20.17.bz2
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.20.17

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.20.y.git
  http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.20.y.git

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.20.y.git

Willy

-------

 Makefile                                       |    2 
 arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c    |   13 +--
 arch/sparc/kernel/entry.S                      |   14 ++-
 arch/sparc/lib/memset.S                        |    2 
 arch/sparc64/kernel/head.S                     |    1 
 arch/um/os-Linux/user_syms.c                   |   20 +---
 drivers/ata/ata_piix.c                         |    2 
 drivers/ata/pata_atiixp.c                      |    1 
 drivers/base/cpu.c                             |    2 
 drivers/char/drm/i915_dma.c                    |   14 ++-
 drivers/char/drm/i915_drv.h                    |    1 
 drivers/char/random.c                          |    9 +-
 drivers/char/sx.c                              |    4 
 drivers/cpufreq/cpufreq_ondemand.c             |   30 ++++--
 drivers/kvm/svm.c                              |    6 +
 drivers/kvm/svm.h                              |    3 
 drivers/md/dm-crypt.c                          |    5 -
 drivers/md/dm-exception-store.c                |   11 +-
 drivers/md/dm-mpath.c                          |    3 
 drivers/md/dm-snap.c                           |   11 --
 drivers/md/dm.c                                |    9 ++
 drivers/md/raid10.c                            |   10 ++
 drivers/media/video/v4l2-common.c              |   19 +++-
 drivers/media/video/wm8739.c                   |    2 
 drivers/media/video/wm8775.c                   |    2 
 drivers/net/forcedeth.c                        |  108 ++++++++++++++++++++++---
 drivers/pcmcia/cs.c                            |    3 
 drivers/scsi/aacraid/linit.c                   |    4 
 drivers/usb/core/hub.c                         |   10 +-
 drivers/video/macmodes.c                       |    5 -
 drivers/video/macmodes.h                       |    8 -
 drivers/video/stifb.c                          |   19 ++--
 fs/9p/conv.c                                   |    1 
 fs/direct-io.c                                 |    1 
 fs/exec.c                                      |   13 ++-
 fs/ext4/extents.c                              |    2 
 fs/jbd/commit.c                                |    3 
 fs/jbd2/commit.c                               |    3 
 fs/nfsd/vfs.c                                  |    2 
 fs/splice.c                                    |    5 -
 include/linux/Kbuild                           |    1 
 include/linux/netfilter_ipv4/ipt_iprange.h     |    2 
 include/net/bluetooth/rfcomm.h                 |    1 
 include/net/xfrm.h                             |    1 
 ipc/shm.c                                      |    2 
 kernel/lockdep_proc.c                          |    2 
 mm/hugetlb.c                                   |   15 ++-
 mm/mlock.c                                     |    5 -
 mm/readahead.c                                 |   12 ++
 net/bluetooth/rfcomm/tty.c                     |   34 ++++++-
 net/core/gen_estimator.c                       |   82 +++++++++++-------
 net/core/netpoll.c                             |    2 
 net/ieee80211/softmac/ieee80211softmac_assoc.c |    5 -
 net/ieee80211/softmac/ieee80211softmac_wx.c    |   11 +-
 net/ipv6/addrconf.c                            |    1 
 net/ipv6/anycast.c                             |    1 
 net/ipv6/icmp.c                                |    2 
 net/ipv6/tcp_ipv6.c                            |    1 
 net/sctp/ipv6.c                                |    4 
 net/sunrpc/auth_gss/svcauth_gss.c              |    9 +-
 net/xfrm/xfrm_policy.c                         |    2 
 61 files changed, 410 insertions(+), 168 deletions(-)

Summary of changes from 2.6.20.16 to 2.6.20.17
============================================

Adrian Bunk (2):
      Missing header include in ipt_iprange.h
      drivers/video/macmodes.c:mac_find_mode() mustn't be __devinit

Alan Cox (1):
      aacraid: fix security hole

Alan Stern (1):
      USB: fix warning caused by autosuspend counter going negative

Alexander Shmelev (1):
      Fix sparc32 memset()

Alexey Dobriyan (1):
      Fix leak on /proc/lockdep_stats

Arne Redlich (1):
      md: handle writes to broken raid10 arrays gracefully

Ayaz Abdulla (2):
      forcedeth bug fix: cicada phy
      forcedeth bug fix: vitesse phy

Badari Pulavarty (1):
      direct-io: fix error-path crashes

Daniel Ritz (1):
      pcmcia: give socket time to power down

Dave Airlie (1):
      drm/i915: Fix i965 secured batchbuffer usage (CVE-2007-3851)

David S. Miller (1):
      Sparc64 bootup assembler bug

David Stevens (1):
      IPV6: /proc/net/anycast6 unbalanced inet6_dev refcnt

Dmitry Butskoy (1):
      Fix error queue socket lookup in ipv6

Fengguang Wu (1):
      readahead: MIN_RA_PAGES/MAX_RA_PAGES macros

Hans Verkuil (2):
      V4L: Add check for valid control ID to v4l2_ctrl_next
      V4L: wm8775/wm8739: Fix memory leak when unloading module

Helge Deller (1):
      stifb: detect cards in double buffer mode more reliably

Herbert van den Bergh (1):
      do not limit locked memory when RLIMIT_MEMLOCK is RLIM_INFINITY

Herton Ronaldo Krzesinski (1):
      Include serial_reg.h with userspace headers

J. Bruce Fields (2):
      nfsd: fix possible read-ahead cache and export table corruption
      nfsd: fix possible oops on re-insertion of rpcsec_gss modules

Jan Kara (2):
      jbd commit: fix transaction dropping
      jbd2 commit: fix transaction dropping

Jean Tourrilhes (1):
      softmac: Fix ESSID problem

Jeff Dike (1):
      UML: exports for hostfs

Jeff Garzik (1):
      pata_atiixp: add SB700 PCI ID

Jens Axboe (1):
      splice: fix double page unlock

Jiri Slaby (1):
      sx: switch subven and subid values

Joe Jin (1):
      hugetlb: fix race in alloc_fresh_huge_page()

Joerg Roedel (1):
      KVM: SVM: Reliably detect if SVM was disabled by BIOS

Maik Hampel (1):
      md: raid10: fix use-after-free of bio

Marcel Holtmann (1):
      Reset current->pdeath_signal on SUID binary execution (CVE-2007-3848)

Mariusz Kozlowski (1):
      fs: 9p/conv.c error path fix

Mark Fortescue (1):
      Fix sparc32 udelay() rounding errors.

Matt Mackall (1):
      random: fix bound check ordering (CVE-2007-3105)

Michael Buesch (1):
      softmac: Fix deadlock of wx_set_essid with assoc work

Mikko Rapeli (1):
      Hangup TTY before releasing rfcomm_dev

Milan Broz (2):
      dm io: fix panic on large request
      dm snapshot: permit invalid activation

Mingming Cao (1):
      "ext4_ext_put_in_cache" uses __u32 to receive physical block number

Patrick McHardy (2):
      Fix IPCOMP crashes.
      gen estimator timer unload race

Pavel Emelianov (1):
      Fix user struct leakage with locked IPC shem segment

Ranko Zivojnovic (1):
      gen estimator deadlock fix

Satyam Sharma (1):
      Netpoll leak

Stefan Bader (1):
      dm: disable barriers

Tejun Heo (1):
      ata_piix: update map 10b for ich8m

Ulrich Drepper (1):
      CPU online file permission

Venki Pallipadi (3):
      acpi-cpufreq: Proper ReadModifyWrite of PERF_CTL MSR
      CPUFREQ: ondemand: fix tickless accounting and software coordination bug
      CPUFREQ: ondemand: add a check to avoid negative load calculation

Ville Tervo (1):
      Keep rfcomm_dev on the list until it is freed

Vlad Yasevich (2):
      SCTP scope_id handling fix
      Fix ipv6 link down handling.

Willy Tarreau (1):
      Linux 2.6.20.17

YOSHIFUJI Hideaki (1):
      Fix TCP IPV6 MD5 bug.

