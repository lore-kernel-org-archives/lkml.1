Return-Path: <linux-kernel-owner+w=401wt.eu-S1759560AbZCPTKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759560AbZCPTKu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 15:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755398AbZCPTKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 15:10:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56255 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755035AbZCPTKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 15:10:39 -0400
Date: Mon, 16 Mar 2009 19:06:42 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Huang Ying <ying.huang@intel.com>,
       Jonathan Brassow <jbrassow@redhat.com>,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
       Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <mbroz@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] device-mapper fixes for 2.6.29
Message-ID: <20090316190642.GH5098@agk.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Huang Ying <ying.huang@intel.com>,
	Jonathan Brassow <jbrassow@redhat.com>,
	Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Milan Broz <mbroz@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
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

to get the following device-mapper fixes for 2.6.29:

Huang Ying (1):
      dm crypt: fix kcryptd_async_done parameter

Mikulas Patocka (2):
      dm table: rework reference counting fix
      dm io: respect BIO_MAX_PAGES limit

Milan Broz (2):
      dm ioctl: validate name length when renaming
      dm crypt: wait for endio to complete before destruction

 drivers/md/dm-crypt.c |   43 +++++++++++++++++++++++++++++++------------
 drivers/md/dm-io.c    |    2 ++
 drivers/md/dm-ioctl.c |    7 ++++---
 drivers/md/dm.c       |   32 +++++++++++++++++++-------------
 4 files changed, 56 insertions(+), 28 deletions(-)

Thanks,
Alasdair
-- 
agk@redhat.com
