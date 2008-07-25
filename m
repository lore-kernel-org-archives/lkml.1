Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbYGYH3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbYGYH3Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 03:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbYGYH3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 03:29:05 -0400
Received: from smtp.nokia.com ([192.100.105.134]:42098 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbYGYH3F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 03:29:05 -0400
Subject: [GIT PULL] UBI updates for 2.6.27
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Fri, 25 Jul 2008 10:25:04 +0300
Message-Id: <1216970704.24495.102.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 25 Jul 2008 07:28:36.0882 (UTC) FILETIME=[0D457F20:01C8EE28]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from

git://git.infradead.org/~dedekind/ubi-2.6.git linux-next

to receive the following updates:

Artem Bityutskiy (18):
      UBI: add a comment
      UBI: fix memory leak
      UBI: do not forget to free internal volumes
      UBI: fix memory leak on error path
      UBI: fix LEB locking
      UBI: add ubi_sync() interface
      UBI: improve mkvol request validation
      UBI: fix error message
      UBI: amend commentaries
      UBI: fix and re-work debugging stuff
      UBI: implement multiple volumes rename
      UBI: rework scrubbing messages
      UBI: bugfix - do not torture PEB needlessly
      UBI: fix checkpatch.pl errors and warnings
      UBI: fix kernel-doc errors and warnings
      UBI: remove pre-sqnum images support
      UBI: fix gcc warning
      UBI: always start the background thread

Bruce Leonard (1):
      UBI: fix 64-bit calculations

Kyungmin Park (2):
      UBI: fix buffer padding
      UBI: avoid unnecessary division operations

 drivers/mtd/ubi/build.c     |   99 +++++++++++++-----
 drivers/mtd/ubi/cdev.c      |  234 +++++++++++++++++++++++++++++++++++++++----
 drivers/mtd/ubi/debug.c     |  158 +++++++++++++++--------------
 drivers/mtd/ubi/debug.h     |   74 +++++++++-----
 drivers/mtd/ubi/eba.c       |   77 ++++----------
 drivers/mtd/ubi/gluebi.c    |   16 ++--
 drivers/mtd/ubi/io.c        |   48 +++++----
 drivers/mtd/ubi/kapi.c      |   50 +++++++---
 drivers/mtd/ubi/misc.c      |    2 +-
 drivers/mtd/ubi/scan.c      |  136 +++++++++----------------
 drivers/mtd/ubi/scan.h      |   21 ++--
 drivers/mtd/ubi/ubi-media.h |   38 +++----
 drivers/mtd/ubi/ubi.h       |   75 ++++++++++-----
 drivers/mtd/ubi/upd.c       |   32 ++++---
 drivers/mtd/ubi/vmt.c       |  148 +++++++++++++++++----------
 drivers/mtd/ubi/vtbl.c      |   88 +++++++++++++---
 drivers/mtd/ubi/wl.c        |  208 +++++++++++++++++++-------------------
 include/linux/mtd/ubi.h     |    5 +-
 include/mtd/ubi-user.h      |   76 ++++++++++++--
 19 files changed, 987 insertions(+), 598 deletions(-)

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

