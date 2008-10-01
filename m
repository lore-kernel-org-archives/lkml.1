Return-Path: <linux-kernel-owner+w=401wt.eu-S1753861AbYJAQ17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbYJAQ17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 12:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbYJAQ1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 12:27:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbYJAQ1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 12:27:51 -0400
Date: Wed, 1 Oct 2008 17:24:18 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <mbroz@redhat.com>,
       dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [git pull] device-mapper regression fixes for 2.6.27
Message-ID: <20081001162417.GE5098@agk.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Milan Broz <mbroz@redhat.com>, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org,
	Chandra Seetharaman <sekharan@us.ibm.com>
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

to get the following device-mapper fixes for 2.6.27:

Chandra Seetharaman (1):
      dm mpath: add missing path switching locking

Mikulas Patocka (2):
      dm: always allow one page in dm_merge_bvec
      dm: cope with access beyond end of device in dm_merge_bvec

 drivers/md/dm-mpath.c |   16 +++++++++++++++-
 drivers/md/dm.c       |   12 ++++++++----
 2 files changed, 23 insertions(+), 5 deletions(-)

Alasdair
-- 
agk@redhat.com
