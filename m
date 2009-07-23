Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbZGWVYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbZGWVYB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 17:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbZGWVYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 17:24:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39242 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862AbZGWVXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 17:23:52 -0400
Date: Thu, 23 Jul 2009 22:23:10 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Mike Snitzer <snitzer@redhat.com>, Milan Broz <mbroz@redhat.com>,
       Mikulas Patocka <mpatocka@redhat.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>, Neil Brown <neilb@suse.de>,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
       Christian =?iso-8859-1?Q?Borntr=E4ger?= <borntraeger@de.ibm.com>
Subject: [git pull] device-mapper fixes for 2.6.31-rc5
Message-ID: <20090723212310.GA31998@agk-dp.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Mike Snitzer <snitzer@redhat.com>, Milan Broz <mbroz@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Jun'ichi Nomura <j-nomura@ce.jp.nec.com>,
	Neil Brown <neilb@suse.de>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
	Christian =?iso-8859-1?Q?Borntr=E4ger?= <borntraeger@de.ibm.com>
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

to get the following device-mapper fixes for 2.6.31-rc5:

Mike Snitzer (2):
      dm: remove queue next_ordered workaround for barriers
      dm table: pass correct dev area size to device_area_is_valid

Mikulas Patocka (1):
      dm raid1: wake kmirrord when requeueing delayed bios after remote recovery

 drivers/md/dm-crypt.c         |    2 +-
 drivers/md/dm-delay.c         |    4 ++--
 drivers/md/dm-linear.c        |    2 +-
 drivers/md/dm-mpath.c         |    2 +-
 drivers/md/dm-raid1.c         |    3 ++-
 drivers/md/dm-stripe.c        |    7 ++++---
 drivers/md/dm-table.c         |   15 +++++----------
 drivers/md/dm.c               |   10 ----------
 drivers/md/dm.h               |    1 -
 include/linux/device-mapper.h |    4 ++--
 10 files changed, 18 insertions(+), 32 deletions(-)

Alasdair
-- 
agk@redhat.com

