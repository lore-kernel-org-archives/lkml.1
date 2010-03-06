Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab0CFCtB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 21:49:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205Ab0CFCs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 21:48:59 -0500
Date: Sat, 6 Mar 2010 02:48:52 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: [git pull] device-mapper patches for 2.6.34
Message-ID: <20100306024852.GP6208@agk-dp.fab.redhat.com>
Mail-Followup-To: dm-devel@redhat.com, linux-kernel@vger.kernel.org
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

Lost the mailing lists there somehow - forwarding!

Alasdair

----- Forwarded message from Alasdair G Kergon <agk@redhat.com> -----

Date: Sat, 6 Mar 2010 02:45:07 +0000
From: Alasdair G Kergon <agk@redhat.com>
Subject: [git pull] device-mapper patches for 2.6.34
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jonathan Brassow <jbrassow@redhat.com>,
	Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
	Mike Snitzer <snitzer@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Nikanth Karthikesan <knikanth@suse.de>,
	Takahiro Yasui <tyasui@redhat.com>,
	Jun'ichi Nomura <j-nomura@ce.jp.nec.com>,
	Milan Broz <mbroz@redhat.com>, Babu Moger <babu.moger@lsi.com>,
	Chandra Seetharaman <chandra.seetharaman@us.ibm.com>,
	Dave Wysochanski <dwysocha@redhat.com>,
	Josef Bacik <josef@redhat.com>,
	Mike Anderson <andmike@linux.vnet.ibm.com>,
	Nikanth Karthikesan <knikanth@novell.com>,
	Peter Rajnoha <prajnoha@redhat.com>

Please pull from:

  master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git master

to get the following device-mapper fixes and minor updates for inclusion in 2.6.34:
 
Kiyoshi Ueda (5):
      dm table: remove dm_get from dm_table_get_md
      dm mpath: avoid storing private suspended state
      dm mpath: hold io until all pg_inits completed
      dm mpath: wait for pg_init completion when suspending
      dm mpath: refactor pg_init

Mike Snitzer (3):
      dm: document when snapshot has finished merging
      dm ioctl: only issue uevent on resume if state changed
      dm: eliminate some holes data structures

Mikulas Patocka (2):
      dm raid1: always return error if all legs fail
      dm: free dm_io before bio_endio not after

Moger, Babu (2):
      dm mpath: pass struct pgpath to pg init done
      dm mpath: skip activate_path for failed paths

Nikanth Karthikesan (1):
      dm table: remove unused dm_get_device range parameters

Peter Rajnoha (1):
      dm ioctl: introduce flag indicating uevent was generated

Takahiro Yasui (1):
      dm raid1: fix deadlock when suspending failed device

 Documentation/device-mapper/snapshot.txt |   44 ++++++++++++
 drivers/md/dm-crypt.c                    |    3 +-
 drivers/md/dm-delay.c                    |    8 +-
 drivers/md/dm-ioctl.c                    |   24 ++++---
 drivers/md/dm-linear.c                   |    3 +-
 drivers/md/dm-log.c                      |    3 +-
 drivers/md/dm-mpath.c                    |  111 +++++++++++++++++++-----------
 drivers/md/dm-raid1.c                    |   53 ++++++++------
 drivers/md/dm-snap.c                     |   34 ++++-----
 drivers/md/dm-stripe.c                   |    3 +-
 drivers/md/dm-table.c                    |   12 +--
 drivers/md/dm-uevent.c                   |    7 +--
 drivers/md/dm.c                          |   25 ++-----
 drivers/md/dm.h                          |    4 +-
 include/linux/device-mapper.h            |    5 +-
 include/linux/dm-io.h                    |    4 +-
 include/linux/dm-ioctl.h                 |    9 ++-
 17 files changed, 212 insertions(+), 140 deletions(-)

Thanks,
Alasdair.

----- End forwarded message -----
