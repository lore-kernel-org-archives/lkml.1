Return-Path: <linux-kernel-owner+w=401wt.eu-S1756514AbZGADUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514AbZGADUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 23:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbZGADUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 23:20:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33082 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455AbZGADUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 23:20:06 -0400
From: Neil Brown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 1 Jul 2009 13:20:47 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19018.54799.551738.530964@notabene.brown>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mike Snitzer <snitzer@redhat.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PULL REQUEST] md updates for 2.6.31-rc
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,
 please pull these md updates:  They add the appropriate call for the
 new 'topology' numbers, and fix a small assortment of bugs.

Thanks,
NeilBrown


The following changes since commit 5a4f13fad1ab5bd08dea78fc55321e429d83cddf:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/ide-2.6

are available in the git repository at:

  git://neil.brown.name/md for-linus

Martin K. Petersen (1):
      md: Use new topology calls to indicate alignment and I/O sizes

NeilBrown (5):
      md: avoid dereferencing NULL pointer when accessing suspend_* sysfs attributes.
      md: fix error path when duplicate name is found on md device creation.
      md: tidy up error paths in md_alloc
      md/raid5: suspend shouldn't affect read requests.
      md: use interruptible wait when duration is controlled by userspace.

 drivers/md/linear.c    |    4 +-
 drivers/md/md.c        |   56 +++++++++++++++++++++++++++--------------------
 drivers/md/multipath.c |    7 +++--
 drivers/md/raid0.c     |    9 ++++++-
 drivers/md/raid1.c     |    9 +++----
 drivers/md/raid10.c    |   19 +++++++++++-----
 drivers/md/raid5.c     |   28 ++++++++++++++++++-----
 7 files changed, 84 insertions(+), 48 deletions(-)
