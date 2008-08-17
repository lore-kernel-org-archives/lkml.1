Return-Path: <linux-kernel-owner+w=401wt.eu-S1754419AbYHQRYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbYHQRYY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 13:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbYHQRXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 13:23:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:34000 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbYHQRXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 13:23:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=fowfuzM7nPUkaxrkwyOBTcFJElQFwTmUkhkqlgrDJJ/FP1v9fqmtlQA71F2eHNDe6j
         /RUg+sPGq7E7u+yZYgLXGO8OLcb1CRgA/0L2hI36CkZdCZIgOpvm8ZmgkNunXVk0RKno
         hqsFaREEp/e8FuJH9VbUYQV13/e9jsaxiOz5M=
To: Bartlomiej@gollum.tnic, Zolnierkiewicz@gollum.tnic, <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 2/5] ide: add drive->debug_mask switch
Date: Sun, 17 Aug 2008 19:23:43 +0200
Message-Id: <1218993826-4571-3-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1218993826-4571-1-git-send-email-petkovbb@gmail.com>
References: <1218993826-4571-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a debugging on/off switch for controlling driver debugging
messages dynamically.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 include/linux/ide.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/ide.h b/include/linux/ide.h
index 6b5d425..c161840 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -543,6 +543,9 @@ struct ide_drive_s {
 
 	int		lun;		/* logical unit */
 	int		crc_count;	/* crc counter to reduce drive speed */
+
+	unsigned long	debug_mask;	/* debugging levels switch */
+
 #ifdef CONFIG_BLK_DEV_IDEACPI
 	struct ide_acpi_drive_link *acpidata;
 #endif
-- 
1.5.5.4

