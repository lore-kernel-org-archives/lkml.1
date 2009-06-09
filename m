Return-Path: <linux-kernel-owner+w=401wt.eu-S1757534AbZFIGqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534AbZFIGqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 02:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756197AbZFIGq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 02:46:27 -0400
Received: from cantor.suse.de ([195.135.220.2]:49662 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754253AbZFIGq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 02:46:26 -0400
From: Neil Brown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 9 Jun 2009 16:46:57 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18990.1377.176969.705222@notabene.brown>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] md: a few more reshape fixes for 2.6.30
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,
 more testing, more bugs...
 I'm now in a position to easily test more of the various
 possibilities with the enhances raid5/6 reshape code and consequently
 have found a few bugs.

 Hopefully these three can still squeeze in to 2.6.30 ??

Thanks,
NeilBrown


The following changes since commit ccc0d38ec13d4649d4168c1db590137df53ad783:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../jbarnes/pci-2.6

are available in the git repository at:

  git://neil.brown.name/md for-linus

NeilBrown (3):
      md/raid5: use conf->raid_disks in preference to mddev->raid_disk
      md/raid5 - avoid deadlocks in get_active_stripe during reshape
      md/raid5: fix bug in reshape code when chunk_size decreases.

 drivers/md/raid5.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)
