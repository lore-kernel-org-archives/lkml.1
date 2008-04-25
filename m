Return-Path: <linux-kernel-owner+w=401wt.eu-S1759340AbYDYOQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759340AbYDYOQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 10:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756147AbYDYOQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 10:16:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754997AbYDYOQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 10:16:17 -0400
Date: Fri, 25 Apr 2008 15:15:00 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jonathan Brassow <jbrassow@redhat.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       Adrian Bunk <bunk@kernel.org>,
       Frederik Deweerdt <frederik.deweerdt@gmail.com>,
       Heinz Mauelshagen <hjm@redhat.com>,
       Mikulas Patocka <mpatocka@redhat.com>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Milan Broz <mbroz@redhat.com>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [git pull] device-mapper update for 2.6.26
Message-ID: <20080425141500.GV24157@agk.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Jonathan Brassow <jbrassow@redhat.com>,
	Jun'ichi Nomura <j-nomura@ce.jp.nec.com>,
	Adrian Bunk <bunk@kernel.org>,
	Frederik Deweerdt <frederik.deweerdt@gmail.com>,
	Heinz Mauelshagen <hjm@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	"Robert P. J. Day" <rpjday@crashcourse.ca>,
	Milan Broz <mbroz@redhat.com>, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org
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

to get the following device-mapper update for 2.6.26:
 
Adrian Bunk (2):
      dm table: drop void suspend_targets return
      dm table: remove unused dm_create_error_table

Alasdair G Kergon (5):
      dm io: rename error to error_bits
      dm log: move register functions
      dm: expose macros
      dm kcopyd: rename
      dm: move include files

Frederik Deweerdt (1):
      dm: remove md argument from specific_minor

Heinz Mauelshagen (5):
      dm log: generalise name in messages
      dm log: move dirty region log code into separate module
      dm io: clean interface
      dm kcopyd: clean interface
      dm log: clean interface

Jonathan Brassow (1):
      dm log: make module use tracking internal

Mikulas Patocka (7):
      dm snapshot: fix chunksize sector conversion
      dm snapshot: store pointer to target instance
      dm kcopyd: per device
      dm kcopyd: private mempool
      dm kcopyd: remove redundant client counting
      dm raid1: use timer
      dm: unplug queues in threads

Milan Broz (2):
      dm snapshot: reduce default memory allocation
      dm crypt: add documentation

Robert P. J. Day (1):
      dm raid1: use list_split_init

 Documentation/device-mapper/dm-crypt.txt           |   52 ++++
 drivers/md/Makefile                                |    6 +-
 drivers/md/dm-exception-store.c                    |   10 +-
 drivers/md/dm-io.c                                 |   38 ++-
 drivers/md/{kcopyd.c => dm-kcopyd.c}               |  298 ++++++++------------
 drivers/md/dm-log.c                                |  254 +++++++++++------
 drivers/md/dm-raid1.c                              |  132 +++++-----
 drivers/md/dm-snap.c                               |   22 +-
 drivers/md/dm-snap.h                               |    4 +-
 drivers/md/dm-table.c                              |   42 +---
 drivers/md/dm.c                                    |   16 +-
 drivers/md/dm.h                                    |   98 +------
 drivers/md/kcopyd.h                                |   42 ---
 include/linux/device-mapper.h                      |   96 ++++++-
 .../md/dm-log.h => include/linux/dm-dirty-log.h    |   84 +++---
 {drivers/md => include/linux}/dm-io.h              |   18 +-
 include/linux/dm-kcopyd.h                          |   47 +++
 17 files changed, 659 insertions(+), 600 deletions(-)
 create mode 100644 Documentation/device-mapper/dm-crypt.txt
 rename drivers/md/{kcopyd.c => dm-kcopyd.c} (71%)
 delete mode 100644 drivers/md/kcopyd.h
 rename drivers/md/dm-log.h => include/linux/dm-dirty-log.h (54%)
 rename {drivers/md => include/linux}/dm-io.h (84%)
 create mode 100644 include/linux/dm-kcopyd.h

Alasdair
-- 
agk@redhat.com
