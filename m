Return-Path: <linux-kernel-owner+w=401wt.eu-S1755264AbYJ3Nr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbYJ3Nr5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 09:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754531AbYJ3Nrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 09:47:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528AbYJ3Nrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 09:47:47 -0400
Date: Thu, 30 Oct 2008 13:47:29 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Heinz Mauelshagen <mauelshagen@redhat.com>,
       Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <mbroz@redhat.com>,
       Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>
Subject: [git pull] 2.6.28-rc2 device-mapper fixes
Message-ID: <20081030134729.GQ5098@agk.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Heinz Mauelshagen <mauelshagen@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Milan Broz <mbroz@redhat.com>,
	Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>
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
  
Ilpo Jarvinen (1):
      dm raid1: fix do_failures

Mikulas Patocka (2):
      dm snapshot: fix register_snapshot deadlock
      dm snapshot: wait for chunks in destructor

 drivers/md/dm-raid1.c |    3 ++-
 drivers/md/dm-snap.c  |   32 ++++++++++++++++++++++++--------
 drivers/md/dm-snap.h  |    2 ++
 3 files changed, 28 insertions(+), 9 deletions(-)

Thanks,
Alasdair
-- 
agk@redhat.com
