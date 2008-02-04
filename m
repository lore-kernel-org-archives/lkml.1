Return-Path: <linux-kernel-owner+w=401wt.eu-S1758487AbYBDNtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487AbYBDNtH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 08:49:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754736AbYBDNnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 08:43:16 -0500
Received: from wx-out-0506.google.com ([66.249.82.237]:38714 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756220AbYBDNnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 08:43:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=S0bg0u70xs1XjwX9V3n5PGgqHzUYE5bSKb56R2FtxfiawpKVY8ZexSdwbbM+SmTSSqwxkzhK8ysPbVRf5TirdpX5f4S0gyyutjovSxqhiTd+XNttvtJz5tduhKmkRCkEaRYUksqi+MXmpSjlQbdl/YtmN6pQqmfOqm+qvBZ4q+8=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 18/22] ide-tape: remove leftover OnStream support warning
Date: Mon,  4 Feb 2008 14:40:36 +0100
Message-Id: <1202132440-26648-19-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
References: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index cfcf5b0..4a12c0b 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -3629,10 +3629,6 @@ static int ide_tape_probe(ide_drive_t *drive)
 		printk("ide-tape: passing drive %s to ide-scsi emulation.\n", drive->name);
 		goto failed;
 	}
-	if (strstr(drive->id->model, "OnStream DI-")) {
-		printk(KERN_WARNING "ide-tape: Use drive %s with ide-scsi emulation and osst.\n", drive->name);
-		printk(KERN_WARNING "ide-tape: OnStream support will be removed soon from ide-tape!\n");
-	}
 	tape = kzalloc(sizeof (idetape_tape_t), GFP_KERNEL);
 	if (tape == NULL) {
 		printk(KERN_ERR "ide-tape: %s: Can't allocate a tape structure\n", drive->name);
-- 
1.5.3.7

