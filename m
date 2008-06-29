Return-Path: <linux-kernel-owner+w=401wt.eu-S1761638AbYF2LDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761638AbYF2LDa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 07:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759780AbYF2K7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 06:59:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:55678 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992AbYF2K7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 06:59:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=otsPQ5rJCUEgsghC96ohnvEfTvsEbr43DqbsetHpMZbUWG15bqk8qq77LTdhulxPEh
         7EpfRtZgIhtE5WihmkRQpUw9rlRaCLmvS0oOFM7CXKs5Iv/C0Lwmx+mKdUAWadnjUYXS
         ceXPSANLSAi2UtvmZZtPhsDPlfr6bjQfvrDTc=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 05/16] ide: remove pc->callback member from ide_atapi_pc
Date: Sun, 29 Jun 2008 12:59:08 +0200
Message-Id: <1214737159-1078-6-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214737159-1078-1-git-send-email-petkovbb@gmail.com>
References: <1214737159-1078-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 include/linux/ide.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/ide.h b/include/linux/ide.h
index be1e5c9..57e99e9 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -632,8 +632,6 @@ struct ide_atapi_pc {
 	 */
 	u8 pc_buf[256];
 
-	void (*callback)(ide_drive_t *);
-
 	/* idetape only */
 	struct idetape_bh *bh;
 	char *b_data;
-- 
1.5.5.4

