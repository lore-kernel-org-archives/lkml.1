Return-Path: <linux-kernel-owner+w=401wt.eu-S1752305AbZJPWWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305AbZJPWWd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 18:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750938AbZJPWWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 18:22:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbZJPWWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 18:22:32 -0400
Date: Fri, 16 Oct 2009 23:22:24 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Jonathan Brassow <jbrassow@redhat.com>,
       Mike Snitzer <snitzer@redhat.com>, Milan Broz <mbroz@redhat.com>,
       Andrew Morton <akpm@osdl.org>, Zdenek Kabelac <zkabelac@redhat.com>,
       Mikulas Patocka <mpatocka@redhat.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [git pull] device-mapper fixes for 2.6.32-rc6
Message-ID: <20091016222224.GF6208@agk-dp.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Jonathan Brassow <jbrassow@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>, Milan Broz <mbroz@redhat.com>,
	Andrew Morton <akpm@osdl.org>, Zdenek Kabelac <zkabelac@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Jun'ichi Nomura <j-nomura@ce.jp.nec.com>,
	Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
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

Please pull from:

  master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git master

to get the following device-mapper fixes for inclusion in 2.6.32-rc6:

Andrew Morton (1):
      dm log: userspace fix incorrect luid cast in userspace_ctr

Jonathan Brassow (1):
      dm snapshot: free exception store on init failure

Kiyoshi Ueda (1):
      dm: dec_pending needs locking to save error value

Mikulas Patocka (6):
      dm snapshot: sort by chunk size to fix race
      dm snapshot: require non zero chunk size by end of ctr
      dm exception store: fix failed set_chunk_size error path
      dm snapshot: lock snapshot while supplying status
      dm snapshot: use unsigned integer chunk size
      dm snapshot: allow chunk size to be less than page size

Zdenek Kabelac (1):
      dm: add missing del_gendisk to alloc_dev error path

 drivers/md/dm-exception-store.c    |   38 +++++++++++------------------------
 drivers/md/dm-exception-store.h    |    8 +++---
 drivers/md/dm-log-userspace-base.c |    2 +-
 drivers/md/dm-snap-persistent.c    |   16 +++++++-------
 drivers/md/dm-snap.c               |   25 +++++++++++++++++++---
 drivers/md/dm.c                    |   11 ++++++++-
 6 files changed, 55 insertions(+), 45 deletions(-)

Alasdair
-- 
agk@redhat.com
