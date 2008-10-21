Return-Path: <linux-kernel-owner+w=401wt.eu-S1753516AbYJURAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbYJURAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 13:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754278AbYJURAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 13:00:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171AbYJURAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 13:00:12 -0400
Date: Tue, 21 Oct 2008 17:59:01 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Heinz Mauelshagen <mauelshagen@redhat.com>,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
       Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <mbroz@redhat.com>,
       Kazuo Ito <ito.kazuo@oss.ntt.co.jp>,
       "Martin K. Petersen" <martin.petersen@oracle.com>, stable@kernel.org
Subject: [git pull] Additional device-mapper patches for 2.6.28
Message-ID: <20081021165901.GO5098@agk.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Heinz Mauelshagen <mauelshagen@redhat.com>,
	Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Milan Broz <mbroz@redhat.com>, Kazuo Ito <ito.kazuo@oss.ntt.co.jp>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	stable@kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

  master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git
 
to get the following additional device-mapper patches for 2.6.28:
  
Alasdair G Kergon (1):
      dm exception store: refactor zero_area

Heinz Mauelshagen (1):
      dm raid1: separate region_hash interface part1

Kazuo Ito (1):
      dm kcopyd: avoid queue shuffle

Kiyoshi Ueda (2):
      dm: remove unused flush_all
      dm: tidy local_init

Martin K. Petersen (1):
      dm: mark split bio as cloned

Mikulas Patocka (5):
      dm snapshot: fix primary_pe race
      dm snapshot: drop unused last_percent
      dm exception store: fix misordered writes
      dm: publish array_too_big
      dm: remove dm header from targets

Milan Broz (3):
      dm crypt: tidy sector
      dm crypt: fix async split
      dm crypt: remove waitqueue

 drivers/md/Makefile             |    2 +-
 drivers/md/dm-crypt.c           |   56 +++-
 drivers/md/dm-delay.c           |    3 +-
 drivers/md/dm-exception-store.c |  108 ++++--
 drivers/md/dm-io.c              |    2 +-
 drivers/md/dm-kcopyd.c          |   14 +-
 drivers/md/dm-linear.c          |    2 +-
 drivers/md/dm-log.c             |    2 +-
 drivers/md/dm-mpath.c           |    3 +-
 drivers/md/dm-path-selector.c   |    3 +-
 drivers/md/dm-raid1.c           |  791 +++++----------------------------------
 drivers/md/dm-region-hash.c     |  704 ++++++++++++++++++++++++++++++++++
 drivers/md/dm-round-robin.c     |    3 +-
 drivers/md/dm-snap.c            |   11 +-
 drivers/md/dm-snap.h            |    5 +-
 drivers/md/dm-stripe.c          |    6 +-
 drivers/md/dm-zero.c            |    2 +-
 drivers/md/dm.c                 |   49 +--
 drivers/md/dm.h                 |    9 -
 include/linux/device-mapper.h   |    3 +
 include/linux/dm-region-hash.h  |  104 +++++
 21 files changed, 1084 insertions(+), 798 deletions(-)
 create mode 100644 drivers/md/dm-region-hash.c
 create mode 100644 include/linux/dm-region-hash.h

Thanks,
Alasdair
-- 
agk@redhat.com
