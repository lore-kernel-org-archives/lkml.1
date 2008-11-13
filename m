Return-Path: <linux-kernel-owner+w=401wt.eu-S1756148AbYKMXuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbYKMXuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 18:50:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754691AbYKMXtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 18:49:41 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53788 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590AbYKMXtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 18:49:39 -0500
Date: Thu, 13 Nov 2008 23:49:33 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Heinz Mauelshagen <mauelshagen@redhat.com>,
       Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <mbroz@redhat.com>,
       Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [git pull] 2.6.28-rc5 device-mapper fixes
Message-ID: <20081113234933.GW5098@agk.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Heinz Mauelshagen <mauelshagen@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Milan Broz <mbroz@redhat.com>,
	Chandra Seetharaman <sekharan@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull the following device-mapper fixes from:

  master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git

Chandra Seetharaman (3):
      dm mpath: avoid attempting to activate null path
      dm mpath: warn if args ignored
      dm: avoid destroying table in dm_any_congested

Heinz Mauelshagen (1):
      dm stripe: fix init failure

Mikulas Patocka (2):
      dm raid1: flush workqueue before destruction
      dm: move pending queue wake_up end_io_acct

 drivers/md/dm-mpath.c  |    8 ++++++--
 drivers/md/dm-raid1.c  |    1 +
 drivers/md/dm-stripe.c |    4 +++-
 drivers/md/dm.c        |   34 +++++++++++++++++++++-------------
 4 files changed, 31 insertions(+), 16 deletions(-)

Thanks,
Alasdair
-- 
agk@redhat.com
