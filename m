Return-Path: <linux-kernel-owner+w=401wt.eu-S1757048AbZBRVdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048AbZBRVdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 16:33:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbZBRVdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 16:33:42 -0500
Received: from kroah.org ([198.145.64.141]:42364 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752611AbZBRVdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 16:33:41 -0500
Date: Wed, 18 Feb 2009 13:30:21 -0800
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
Subject: [patch 00/39] 2.6.28.7-stable review
Message-ID: <20090218213021.GA19814@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the start of the stable review cycle for the 2.6.28.7 release.
There are 39 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Friday, Febuary 20, 2009, 21:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.28.7-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h


 Makefile                               |    2 +-
 arch/powerpc/kernel/align.c            |    7 +-
 arch/x86/kernel/traps.c                |   10 +-
 arch/x86/mm/pageattr.c                 |   14 +
 drivers/ata/pata_via.c                 |    4 +-
 drivers/ata/sata_nv.c                  |   14 +-
 drivers/bluetooth/btsdio.c             |    1 +
 drivers/net/3c505.c                    |   26 ++-
 drivers/pci/intel-iommu.c              |   14 +-
 drivers/scsi/libiscsi.c                |    1 +
 drivers/watchdog/Kconfig               |    2 +-
 drivers/watchdog/iTCO_vendor_support.c |   32 ++-
 drivers/watchdog/iTCO_wdt.c            |   35 +--
 fs/ext2/super.c                        |    9 +-
 fs/ext4/balloc.c                       |  168 +++++--------
 fs/ext4/ext4.h                         |   41 +++-
 fs/ext4/ext4_sb.h                      |    4 +-
 fs/ext4/hash.c                         |   77 +++++-
 fs/ext4/ialloc.c                       |  166 ++++++++-----
 fs/ext4/inode.c                        |   76 ++++--
 fs/ext4/mballoc.c                      |  433 +++++++++++++++++++++++++-------
 fs/ext4/mballoc.h                      |   26 +--
 fs/ext4/namei.c                        |   28 ++-
 fs/ext4/resize.c                       |   68 +----
 fs/ext4/super.c                        |   46 +++-
 fs/jbd2/commit.c                       |   27 ++-
 include/linux/jbd2.h                   |    4 +-
 include/linux/mod_devicetable.h        |    7 +
 include/linux/pci_ids.h                |    1 +
 include/linux/pid.h                    |   18 ++
 ipc/mqueue.c                           |    3 +-
 kernel/sched_fair.c                    |   30 ++-
 32 files changed, 938 insertions(+), 456 deletions(-)
