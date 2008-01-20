Return-Path: <linux-kernel-owner+w=401wt.eu-S1753708AbYATMmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbYATMmU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 07:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbYATMmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 07:42:11 -0500
Received: from smtp113.plus.mail.re1.yahoo.com ([69.147.102.76]:24035 "HELO
	smtp113.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752587AbYATMmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 07:42:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:Mail-Followup-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=JGV/lAQok0s68vDWAXo4X7aVR5dYuVnyVb5EAGR51hvqwZBBJdR31M3zq0XipZeeNziQbp6MfsMGx9zFdYo9/wPvMzw8E5tG6GKeLuifZwZASrdyWlThPVJ5PaiH/k2fG/sQGM6I+5GwE0i5jYNelBZGOKGzWYbiIpcFDQAI2Ew=  ;
X-YMail-OSG: 5VMX8RsVM1mvOsL6sTWPj2PjbNLHqUxEJQmpQ9zBtHGoCG1o9Q36BPmNcaiYTCvJMTvw1D074g--
X-Yahoo-Newman-Property: ymail-3
Date: Sun, 20 Jan 2008 13:38:15 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 0/12] ide-floppy redux v2.5
Message-ID: <20080120123815.GA20082@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
Mail-Followup-To: bbpetkov@yahoo.de,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1200255505-31418-1-git-send-email-bbpetkov@yahoo.de> <200801142238.17282.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200801142238.17282.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 10:38:17PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > By the way, I have an Iomega ZIP 100 drive somewhere in my hardware pile and
> > will do some testing with the "new" :) driver just in case.
> 
> This would be great. :)
Hi Bart,

i just whipped rc8 along with your pata-2.6 tree on top and had several test
runs of the ide-floppy driver (raw reads, software floppy disk eject, etc) and
everything seems to work fine. I will keep this hardware setup here so that we
could at least test ide-floppy occasionally. We should probably acknowledge this
major driver cleanup with a new driver version?

---
>From 6f948b93839cdf397cb38ca75c3c6cc9a21e6070 Mon Sep 17 00:00:00 2001
From: Borislav Petkov <bbpetkov@yahoo.de>
Date: Sun, 20 Jan 2008 13:32:24 +0100
Subject: [PATCH] ide-floppy: bump driver version number

Acknowledge major ide-floppy code refactoring and cleanup by bumping the driver
version number. Also, remove a wrong comment.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-floppy.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 0bf6596..b455cf1 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -5,9 +5,6 @@
  * Copyright (C) 2000-2002  Paul Bristow <paul@paulbristow.net>
  * Copyright (C) 2005       Bartlomiej Zolnierkiewicz
  *
- * The driver currently doesn't have any fancy features, just the bare
- * minimum read/write support.
- *
  * This driver supports the following IDE floppy drives:
  *
  * LS-120/240 SuperDisk
@@ -18,7 +15,7 @@
  * Documentation/ide/ChangeLog.ide-floppy.1996-2002
  */

-#define IDEFLOPPY_VERSION "0.99.newide"
+#define IDEFLOPPY_VERSION "1.00"

 #include <linux/module.h>
 #include <linux/types.h>
--
1.5.3.7


-- 
Regards/Gruﬂ,
    Boris.
