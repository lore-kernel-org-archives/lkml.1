Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbYFLGnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbYFLGnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 02:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755397AbYFLGlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 02:41:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:9582 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbYFLGlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 02:41:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=Yk5dwothF67NMRfwRyq0fwAEAZP9uqYlygrdGsKGd5oEOvvjRAcsB7qePTp0dHHh6M
         oM0fy8EtSvBJVNsac8gXK29iMiO/inq1nByC+6X1GCWJbdQZ+ly07xqf/fs9Ngsf9zLu
         bBVAdUakcre9Lk1Zh+FcZTNAtplT6T9iCjdK8=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 07/18] ide-cd: mv ide_do_rw_cdrom ide_cd_do_request
Date: Thu, 12 Jun 2008 08:40:59 +0200
Message-Id: <1213252870-20474-8-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1213252870-20474-1-git-send-email-petkovbb@gmail.com>
References: <1213252870-20474-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 40dab2b..e9d9363 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1211,7 +1211,7 @@ static ide_startstop_t cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 /*
  * cdrom driver request routine.
  */
-static ide_startstop_t ide_do_rw_cdrom(ide_drive_t *drive, struct request *rq,
+static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 					sector_t block)
 {
 	ide_startstop_t action;
@@ -1949,7 +1949,7 @@ static ide_driver_t ide_cdrom_driver = {
 	.version		= IDECD_VERSION,
 	.media			= ide_cdrom,
 	.supports_dsc_overlap	= 1,
-	.do_request		= ide_do_rw_cdrom,
+	.do_request		= ide_cd_do_request,
 	.end_request		= ide_end_request,
 	.error			= __ide_error,
 	.abort			= __ide_abort,
-- 
1.5.5.1

