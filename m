Return-Path: <linux-kernel-owner+w=401wt.eu-S1759529AbYJJNOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759529AbYJJNOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 09:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756787AbYJJNN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 09:13:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756754AbYJJNNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 09:13:55 -0400
Date: Fri, 10 Oct 2008 13:51:59 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org, Stefan Raspl <raspl@linux.vnet.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Benjamin Marzinski <bmarzins@redhat.com>,
       Jonathan Brassow <jbrassow@redhat.com>,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
       Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <mbroz@redhat.com>
Subject: [git pull] device-mapper patches for 2.6.28
Message-ID: <20081010125159.GK5098@agk.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org,
	Stefan Raspl <raspl@linux.vnet.ibm.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Jonathan Brassow <jbrassow@redhat.com>,
	Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Milan Broz <mbroz@redhat.com>
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

to get the following device-mapper patches for 2.6.28:
 
Alasdair G Kergon (2):
      dm crypt: remove inc_pending from write_io_submit
      dm: detect lost queue

Benjamin Marzinski (1):
      dm mpath: use more error codes

Jonathan Brassow (1):
      dm raid1: kcopyd should stop on error if errors handled

Kiyoshi Ueda (1):
      dm mpath: remove is_active from struct dm_path

Mikulas Patocka (6):
      dm exception store: introduce area_location function
      dm exception store: use chunk_t for_areas
      dm: export struct dm_dev
      dm: publish dm_get_mapinfo
      dm: publish dm_table_unplug_all
      dm: publish dm_vcalloc

Milan Broz (7):
      dm crypt: tidy inc pending
      dm crypt: tidy crypt alloc
      dm crypt: tidy write loop pending
      dm crypt: move dec_pending on error into write_io_submit
      dm crypt: fix async inc_pending
      dm crypt: tidy ctx pending
      dm crypt: avoid unnecessary wait when splitting bio

 drivers/md/dm-crypt.c           |  109 +++++++++++++++++++++++---------------
 drivers/md/dm-exception-store.c |   29 +++++++----
 drivers/md/dm-ioctl.c           |    4 +-
 drivers/md/dm-mpath.c           |   35 +++++++------
 drivers/md/dm-mpath.h           |    2 -
 drivers/md/dm-raid1.c           |    4 +-
 drivers/md/dm-table.c           |   97 ++++++++++++++++++++++------------
 drivers/md/dm.h                 |   10 +---
 include/linux/device-mapper.h   |   18 ++++++-
 9 files changed, 190 insertions(+), 118 deletions(-)

Alasdair
-- 
agk@redhat.com
