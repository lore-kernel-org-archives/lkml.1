Return-Path: <linux-kernel-owner+w=401wt.eu-S1763364AbXGRMkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763364AbXGRMkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 08:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760958AbXGRMkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 08:40:13 -0400
Received: from smtp.nokia.com ([131.228.20.172]:18850 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760259AbXGRMkK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 08:40:10 -0400
Subject: [GIT-PULL] pull from UBI git
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Wed, 18 Jul 2007 15:39:49 +0300
Message-Id: <1184762389.3531.168.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 18 Jul 2007 12:39:49.0888 (UTC) FILETIME=[BB2B5800:01C7C938]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from upstream branch of
git://git.infradead.org/~dedekind/ubi-2.6.git to receive the following
updates:

 MAINTAINERS              |    2
 drivers/mtd/ubi/build.c  |   25 ++-------
 drivers/mtd/ubi/cdev.c   |   49 +++++-------------
 drivers/mtd/ubi/debug.c  |   44 ++++++++--------
 drivers/mtd/ubi/debug.h  |    2
 drivers/mtd/ubi/eba.c    |   98 ++++++++++++++++++------------------
 drivers/mtd/ubi/gluebi.c |   27 +++++++++
 drivers/mtd/ubi/io.c     |   65 ++++++++++++------------
 drivers/mtd/ubi/kapi.c   |   19 +++----
 drivers/mtd/ubi/misc.c   |    4 -
 drivers/mtd/ubi/scan.c   |  127
+++++++++++++++++++++++++----------------------
 drivers/mtd/ubi/scan.h   |    2
 drivers/mtd/ubi/ubi.h    |    3 +
 drivers/mtd/ubi/upd.c    |    4 -
 drivers/mtd/ubi/vmt.c    |   53 ++++++++++++-------
 drivers/mtd/ubi/vtbl.c   |   85 ++++++++++++++++---------------
 drivers/mtd/ubi/wl.c     |   93 ++++++++++++++++++----------------
 include/mtd/ubi-header.h |  101 +++++++++++++------------------------
 18 files changed, 403 insertions(+), 400 deletions(-)

Artem Bityutskiy (17):
      UBI: fix memory leak in checking code
      UBI: fix error path in create_vtbl()
      UBI: do not let to read too much
      UBI: set correct gluebi device size
      UBI: add few more comments
      UBI: use vmalloc for large buffers
      UBI: minor comma fix
      UBI: error path bugfix
      UBI: bugfix in ubi_leb_change()
      UBI: fix MAINTAINERS
      UBI: bugfix in error path
      UBI: fix debugging stuff
      UBI: fix bug in atomic_leb_change()
      UBI: bugfix in max_sqnum calculation
      UBI: remove unneeded error checks
      UBI: fix comments
      UBI: fix error handling in erase worker

Brijesh Singh (2):
      UBI: fix signed-unsigned multiplication
      UBI: bugfix in sqnum calculation

Christoph Hellwig (2):
      UBI: cleanup ioctl handling
      UBI: kill homegrown endian macros

Fernando Luis Vázquez Cao (1):
      UBI: cleanup usage of try_module_get

Florin Malita (1):
      UBI: fix dereference after kfree

Paul Mundt (1):
      UBI: fix compile warning

Vignesh Babu (1):
      UBI: use is_power_of_2()

Vinit Agnihotri (3):
      UBI: fix freeing ubi->vtbl while unloading
      UBI: fix message
      UBI: fix overflow bug

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

