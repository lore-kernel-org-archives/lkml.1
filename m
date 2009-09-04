Return-Path: <linux-kernel-owner+w=401wt.eu-S1757319AbZIDTwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319AbZIDTwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 15:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757277AbZIDTwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 15:52:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757266AbZIDTwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 15:52:06 -0400
Date: Fri, 4 Sep 2009 20:52:01 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Mike Snitzer <snitzer@redhat.com>, Milan Broz <mbroz@redhat.com>,
       Mikulas Patocka <mpatocka@redhat.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
       Jonathan Brassow <jbrassow@redhat.com>
Subject: [git pull] device-mapper fixes for 2.6.31
Message-ID: <20090904195201.GP31998@agk-dp.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Mike Snitzer <snitzer@redhat.com>, Milan Broz <mbroz@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Jun'ichi Nomura <j-nomura@ce.jp.nec.com>,
	Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
	Jonathan Brassow <jbrassow@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Very late in the release cycle I know (due to holidays), sorry, but please
would you pull the following device-mapper fixes from

  master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git master

into 2.6.31 if you get this in time?

Jonathan Brassow (4):
      dm log: fix userspace status output
      dm log: remove incorrect field from userspace table output
      dm raid1: do not allow log_failure variable to unset after being set
      dm log: userspace add luid to distinguish between concurrent log instances

Kiyoshi Ueda (1):
      dm multipath: fix oops when request based io fails when no paths

Mike Snitzer (3):
      dm snapshot: implement iterate devices
      dm table: add more context to terse warning messages
      dm stripe: expose correct io hints

Mikulas Patocka (5):
      dm table: fix queue_limit checking device iterator
      dm snapshot: refactor zero_disk_area to use chunk_io
      dm snapshot: fix header corruption race on invalidation
      dm exception store: split set_chunk_size
      dm snapshot: fix on disk chunk size validation

 drivers/md/dm-exception-store.c        |   13 +++++
 drivers/md/dm-exception-store.h        |    4 ++
 drivers/md/dm-log-userspace-base.c     |   39 +++++++++-----
 drivers/md/dm-log-userspace-transfer.c |    6 ++-
 drivers/md/dm-log-userspace-transfer.h |    2 +-
 drivers/md/dm-raid1.c                  |    8 +++-
 drivers/md/dm-snap-persistent.c        |   88 +++++++++++++++++++-------------
 drivers/md/dm-snap.c                   |   23 ++++++++-
 drivers/md/dm-stripe.c                 |   13 ++++-
 drivers/md/dm-table.c                  |   51 ++++++++++++-------
 drivers/md/dm.c                        |   15 ++++--
 include/linux/device-mapper.h          |    4 ++
 include/linux/dm-log-userspace.h       |   13 ++++-
 13 files changed, 198 insertions(+), 81 deletions(-)

Thanks,
Alasdair
-- 
agk@redhat.com
