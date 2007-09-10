Return-Path: <linux-kernel-owner+w=401wt.eu-S1756753AbXIJJJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbXIJJJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 05:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbXIJJJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 05:09:49 -0400
Received: from smtp.nokia.com ([131.228.20.172]:33506 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbXIJJJs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 05:09:48 -0400
Subject: What's in ubi-2.6.git
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-mtd@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Date: Mon, 10 Sep 2007 12:09:03 +0300
Message-Id: <1189415343.14370.97.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 10 Sep 2007 09:09:03.0597 (UTC) FILETIME=[3BB2F9D0:01C7F38A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following are UBI changes I'd like to push to 2.6.24. The amount of
changes is small, so no additional comments.

URL: git://git.infradead.org/~dedekind/ubi-2.6.git master
(based on top of -rc2 for now).

Artem Bityutskiy (6):
      UBI: fix sparse warnings
      UBI: add more prints
      UBI: use linux print_hex_dump(), not home-grown one
      UBI: allocate memory with GFP_NOFS
      UBI: do not use vmalloc on I/O path
      UBI: use byte hexdump

Florin Malita (1):
      UBI: fix leak in ubi_scan_erase_peb

Jesper Juhl (1):
      UBI: don't use array index before testing if it is negative

 drivers/mtd/ubi/build.c |   28 +++++++++++++++-
 drivers/mtd/ubi/debug.c |   37 +--------------------
 drivers/mtd/ubi/debug.h |    2 -
 drivers/mtd/ubi/eba.c   |   82 +++++++++++++++++-----------------------------
 drivers/mtd/ubi/io.c    |   75 ++++++++++++++++++++-----------------------
 drivers/mtd/ubi/kapi.c  |    9 ++++-
 drivers/mtd/ubi/scan.c  |   45 ++++++++++++--------------
 drivers/mtd/ubi/scan.h  |    8 ++--
 drivers/mtd/ubi/ubi.h   |   36 +++++++++++++++------
 drivers/mtd/ubi/vmt.c   |   70 +++++++++++++++++++++-------------------
 drivers/mtd/ubi/vtbl.c  |    8 ++--
 drivers/mtd/ubi/wl.c    |   17 +++++----
 12 files changed, 202 insertions(+), 215 deletions(-)

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

