Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab0BVM1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 07:27:21 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:63317 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab0BVM1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 07:27:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wxpHanGN0BbPWSX/ANkgsZUsKjOKnMWwZ6Zog8ZnN0HDpZTN8k8OmuVHooUn6DvIdH
         pA02avJ3wF3HWJw8aqD+LAF/MzlzeYp/IWTx/6rDReD8dvbToCsuCFW+0873JpZPyJ+M
         qonu5hJm9wTJoHPklX8WzWx9W0A1ZeqNOHuo0=
From: Stefan Melmuk <stefan.melmuk@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Stefan Melmuk <stefan.melmuk@gmail.com>
Subject: [PATCH 3/8] cdrom: fixed braces coding style issues
Date: Mon, 22 Feb 2010 13:26:33 +0100
Message-Id: <1266841598-19662-3-git-send-email-stefan.melmuk@gmail.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1266841598-19662-1-git-send-email-stefan.melmuk@gmail.com>
References: <1266841598-19662-1-git-send-email-stefan.melmuk@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed two coding style issues.

Signed-off-by: Stefan Melmuk <stefan.melmuk@gmail.com>
---
 drivers/cdrom/cdrom.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 2088868..fdd251e 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -1088,8 +1088,7 @@ int open_for_data(struct cdrom_device_info *cdi)
 					(unsigned int)task_pid_nr(current));
 		    ret=-EMEDIUMTYPE;
 		    goto clean_up_and_return;
-		}
-		else {
+		} else {
 		    cdinfo(CD_OPEN, "wrong media type, but CDO_CHECK_TYPE not set.\n");
 		}
 	}
@@ -1363,11 +1362,10 @@ static int cdrom_select_disc(struct cdrom_device_info *cdi, int slot)
 	kfree(info);
 
 	if (cdi->use_count > 1 || keeplocked) {
-		if (slot == CDSL_CURRENT) {
+		if (slot == CDSL_CURRENT)
 	    		return curslot;
-		} else {
+		else
 			return -EBUSY;
-		}
 	}
 
 	/* Specifying CDSL_CURRENT will attempt to load the currnet slot,
-- 
1.7.0

