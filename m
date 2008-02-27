Return-Path: <linux-kernel-owner+w=401wt.eu-S1758186AbYB0SWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186AbYB0SWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 13:22:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756688AbYB0SVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 13:21:25 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:43351 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977AbYB0SVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 13:21:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=ec2Mt+fqXkN5f63FHjwevKYLLKJ5Y371tIxRSVsSor7gZ9T6NW3dH/WSTws5vrB91kD/SlVkozSPlLrPkTxIw0cniau5ia/ooUQWraUSaBkUCIp2sL+dLZjnaq2NkKeRVjGytILC+ccy0KDAuNcy+GuyGZr2kBRzX0BM2Gl9q1I=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 1/5] ide-cd: include proper headers
Date: Wed, 27 Feb 2008 19:20:45 +0100
Message-Id: <1204136449-9490-2-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204136449-9490-1-git-send-email-petkovbb@gmail.com>
References: <1204136449-9490-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 8877b7b..4d39567 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -41,10 +41,10 @@
 
 #include <scsi/scsi.h>	/* For SCSI -> ATAPI command conversion */
 
-#include <asm/irq.h>
-#include <asm/io.h>
+#include <linux/irq.h>
+#include <linux/io.h>
 #include <asm/byteorder.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <asm/unaligned.h>
 
 #include "ide-cd.h"
-- 
1.5.4.1

