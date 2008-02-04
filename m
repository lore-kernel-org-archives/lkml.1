Return-Path: <linux-kernel-owner+w=401wt.eu-S1757292AbYBDNuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbYBDNuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 08:50:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758432AbYBDNs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 08:48:58 -0500
Received: from ik-out-1112.google.com ([66.249.90.176]:24969 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758411AbYBDNs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 08:48:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=U0lqhtz6HlaOBTFZhsIuPcv1jepzr/Gyg/3Ph9OYimff7Xe03Kz9ctGPt/Ihd36RBbiuL8BvJXny94B/aiYeX7v/oLI+M3cSt9LvuVIOINbezodvIj8huLTbLJIVUA6HYBc1rcRWwS2nkg1l+jr4TIzgF6lPmCv+azY+kk/9ltM=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 19/22] ide-tape: fix syntax error in idetape_identify_device()
Date: Mon,  4 Feb 2008 14:40:37 +0100
Message-Id: <1202132440-26648-20-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
References: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Spotted by Sergei Shtylyov.

CC: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 4a12c0b..7e998c4 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -3273,8 +3273,8 @@ static int idetape_identify_device(ide_drive_t *drive)
 	else if (!removable)
 		printk(KERN_ERR "ide-tape: The removable flag is not set\n");
 	else if (packet_size != 0) {
-		printk(KERN_ERR "ide-tape: Packet size (0x%02x) is not 12 "
-				"bytes long\n", packet_size);
+		printk(KERN_ERR "ide-tape: Packet size (0x%02x) is not 12"
+				" bytes\n", packet_size);
 	} else
 		return 1;
 	return 0;
-- 
1.5.3.7

