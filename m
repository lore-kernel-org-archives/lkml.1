Return-Path: <linux-kernel-owner+w=401wt.eu-S1758986AbYGULQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758986AbYGULQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 07:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbYGULQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 07:16:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286AbYGULQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 07:16:34 -0400
Date: Mon, 21 Jul 2008 12:09:58 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
       Milan Broz <mbroz@redhat.com>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org, Benjamin Marzinski <bmarzins@redhat.com>,
       Richard Kennedy <richard@rsk.demon.co.uk>, Julia Lawall <julia@diku.dk>
Subject: [git pull] device-mapper update for 2.6.27
Message-ID: <20080721110958.GF24157@agk.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Adrian Bunk <bunk@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Milan Broz <mbroz@redhat.com>, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Richard Kennedy <richard@rsk.demon.co.uk>,
	Julia Lawall <julia@diku.dk>
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

to get the following device-mapper update for 2.6.27:

Adrian Bunk (1):
      dm log: make dm_dirty_log init and exit static

Alasdair G Kergon (1):
      dm mpath: fix test for reinstate_path

Mikulas Patocka (5):
      dm mpath: free path selector on invalid args
      dm mpath: return parameter error
      dm snapshot: track snapshot reads
      dm snapshot: fix race during exception creation
      dm snapshot: use per device mempools

Milan Broz (4):
      dm: introduce merge_bvec_fn
      dm: linear add merge
      dm table: remove merge_bvec sector restriction
      dm crypt: add merge

Richard Kennedy (1):
      dm io: remove struct padding

 drivers/md/dm-crypt.c         |   18 ++++-
 drivers/md/dm-linear.c        |   38 ++++++++-
 drivers/md/dm-log.c           |    4 +-
 drivers/md/dm-mpath.c         |   10 ++-
 drivers/md/dm-snap.c          |  163 +++++++++++++++++++++++++++++++++++------
 drivers/md/dm-snap.h          |   11 +++
 drivers/md/dm-table.c         |   13 ++--
 drivers/md/dm.c               |   46 +++++++++++-
 drivers/md/dm.h               |    6 --
 include/linux/device-mapper.h |    6 ++
 include/linux/dm-ioctl.h      |    4 +-
 11 files changed, 270 insertions(+), 49 deletions(-)
  
Alasdair
-- 
agk@redhat.com
