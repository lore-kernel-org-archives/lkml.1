Return-Path: <linux-kernel-owner+w=401wt.eu-S1755250AbYG3Xbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbYG3Xbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 19:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753337AbYG3Xbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 19:31:41 -0400
Received: from ns.suse.de ([195.135.220.2]:35263 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001AbYG3Xbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 19:31:40 -0400
Date: Wed, 30 Jul 2008 16:24:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: [patch 00/29] 2.6.25-stable review
Message-ID: <20080730232451.GA30670@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.25.14 release.
There are 29 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by August 1, 12:00:00 UTC.  Anything received
after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.25.14-rc1.gz
and the diffstat can be found below.


thanks,

the -stable release team


 Makefile                                      |    5 ++-
 arch/powerpc/platforms/cell/cbe_cpufreq_pmi.c |    6 ++++
 arch/sparc64/kernel/irq.c                     |   10 ++++++
 arch/sparc64/kernel/ldc.c                     |   38 +++++++++++++-------------
 arch/sparc64/kernel/time.c                    |   15 ++++++----
 arch/x86/Kconfig.cpu                          |    2 -
 arch/x86/mm/init_64.c                         |    2 -
 drivers/acpi/processor_perflib.c              |   15 ++++++++--
 drivers/ata/ahci.c                            |   15 ++++++++--
 drivers/ata/ata_generic.c                     |    6 ++++
 drivers/ata/pata_acpi.c                       |    6 ++++
 drivers/cpufreq/cpufreq.c                     |    3 ++
 drivers/ide/ide-cd.c                          |   27 +++++++++++++++---
 drivers/net/ixgbe/ixgbe_main.c                |    2 -
 drivers/net/wireless/ath5k/base.c             |    5 ---
 drivers/net/wireless/b43legacy/main.c         |    2 -
 drivers/spi/mpc52xx_psc_spi.c                 |   22 ++++-----------
 fs/dquot.c                                    |   16 ++++++++++
 fs/ecryptfs/crypto.c                          |   30 ++++++++++++--------
 fs/isofs/rock.c                               |   22 +++++++++++++--
 fs/libfs.c                                    |    4 +-
 include/asm-arm/bitops.h                      |    9 +++++-
 include/asm-generic/vmlinux.lds.h             |    4 ++
 include/asm-powerpc/pgtable-ppc64.h           |   11 +++++++
 include/asm-sparc64/io.h                      |    1 
 include/linux/cpufreq.h                       |    1 
 kernel/marker.c                               |   12 ++++++--
 kernel/sys_ni.c                               |    1 
 mm/filemap.c                                  |    2 -
 mm/hugetlb.c                                  |    6 +++-
 mm/shmem.c                                    |    3 +-
 net/ipv4/tcp_input.c                          |    3 --
 net/netfilter/nf_conntrack_proto_tcp.c        |   10 +++++-
 scripts/Makefile.modpost                      |    1 
 scripts/mod/modpost.c                         |    3 +-
 sound/pci/hda/patch_realtek.c                 |    1 
 sound/pci/trident/trident_main.c              |    5 ++-
 37 files changed, 234 insertions(+), 92 deletions(-)
