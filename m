Return-Path: <linux-kernel-owner+w=401wt.eu-S1757903AbYBDNrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903AbYBDNrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 08:47:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756199AbYBDNm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 08:42:59 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:4171 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756180AbYBDNm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 08:42:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=CrBK58Adom8F3BZk4uo6/gokS5/sqOWIglllizMTqZirz0DaPSeiFEjdK5XINtjP6Qm1q3lSAgBuc0tuumjJIM06cEZMAG/jbbMatC6TaENUqvhgkT7VKfUBcj3HqDNH4d2lTIbqABdFi9VRFVsaD5jOH8kg00fM/xi1fYgrHpc=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 16/22] ide-tape: include proper headers
Date: Mon,  4 Feb 2008 14:40:34 +0100
Message-Id: <1202132440-26648-17-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
References: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 342ec50..24f048f 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -39,9 +39,9 @@
 #include <scsi/scsi.h>
 
 #include <asm/byteorder.h>
-#include <asm/irq.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/irq.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 #include <asm/unaligned.h>
 #include <linux/mtio.h>
 
-- 
1.5.3.7

