Return-Path: <linux-kernel-owner+w=401wt.eu-S1754753AbXJGQfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbXJGQfB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 12:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656AbXJGQex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 12:34:53 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:45767 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751495AbXJGQex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 12:34:53 -0400
Date: Sun, 7 Oct 2007 18:35:20 +0200
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.6.16.55-rc1
Message-ID: <20071007163520.GG16424@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Security fixes since 2.6.16.54:
- CVE-2005-0504: fix buffer overflow in the moxa driver
- CVE-2007-2453: random fixes
- CVE-2007-3104: store sysfs inode nrs in s_ino to avoid readdir oopses
- CVE-2007-3105: random: fix bound check ordering
- CVE-2007-3848: Reset current->pdeath_signal on SUID binary execution
- CVE-2007-4571: Convert snd-page-alloc proc file to use seq_file
- CVE-2007-4573: x86_64: Zero extend all registers after ptrace in 32bit entry path


Location:
ftp://ftp.kernel.org/pub/linux/kernel/people/bunk/linux-2.6.16.y/testing/

git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.16.y.git

RSS feed of the git tree:
http://www.kernel.org/git/?p=linux/kernel/git/stable/linux-2.6.16.y.git;a=rss


Changes since 2.6.16.54:

Adrian Bunk (8):
      unexport ktime_get_real
      unexport neigh_update_hhs
      unexport cpufreq_parse_governor
      unexport csr1212_release_keyval
      sound/core/pcm_lib.c: don't export static functions
      unexport ip_conntrack_{,un}register_notifier
      snd_mem_proc_read(): convert to list_for_each_entry*
      Linux 2.6.16.55-rc1

Andi Kleen (1):
      x86_64: Zero extend all registers after ptrace in 32bit entry path (CVE-2007-4573)

Dann Frazier (1):
      fix buffer overflow in the moxa driver (CVE-2005-0504)

Eric Sandeen (1):
      sysfs: store sysfs inode nrs in s_ino to avoid readdir oopses (CVE-2007-3104)

Kumar Gala (1):
      [POWERPC] Flush registers to proper task context

Marcel Holtmann (1):
      Reset current->pdeath_signal on SUID binary execution (CVE-2007-3848)

Matt Mackall (3):
      random: fix error in entropy extraction (CVE-2007-2453 1 of 2)
      random: fix seeding with zero entropy (CVE-2007-2453 2 of 2)
      random: fix bound check ordering (CVE-2007-3105)

Mikael Pettersson (1):
      [SPARC]: fix sparc64 gcc 4.2 compile failure

Nick Bowler (1):
      [IPSEC] AH4: Update IPv4 options handling to conform to RFC 4302.

Takashi Iwai (1):
      Convert snd-page-alloc proc file to use seq_file (CVE-2007-4571)


 Makefile                                     |    2 
 arch/powerpc/kernel/process.c                |    6 -
 arch/x86_64/ia32/ia32entry.S                 |   18 +++-
 arch/x86_64/kernel/ptrace.c                  |    4 -
 drivers/char/moxa.c                          |    8 +-
 drivers/char/random.c                        |   76 +++++++++++--------
 drivers/cpufreq/cpufreq.c                    |    1 
 drivers/ieee1394/ieee1394_core.c             |    1 
 fs/exec.c                                    |   13 ++-
 fs/sysfs/dir.c                               |   16 ++--
 fs/sysfs/inode.c                             |    1 
 fs/sysfs/mount.c                             |    1 
 include/asm-sparc/mostek.h                   |    2 
 include/asm-sparc64/mostek.h                 |    2 
 include/linux/sysfs.h                        |    1 
 kernel/hrtimer.c                             |    2 
 net/core/neighbour.c                         |    1 
 net/ipv4/ah4.c                               |    2 
 net/ipv4/netfilter/ip_conntrack_standalone.c |    2 
 sound/core/memalloc.c                        |   72 ++++++++++--------
 sound/core/pcm_lib.c                         |    4 -
 21 files changed, 136 insertions(+), 99 deletions(-)

