Return-Path: <linux-kernel-owner+w=401wt.eu-S1760792AbYAKNXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760792AbYAKNXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 08:23:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759162AbYAKNWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 08:22:52 -0500
Received: from smtp104.plus.mail.re1.yahoo.com ([69.147.102.67]:45609 "HELO
	smtp104.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759091AbYAKNWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 08:22:51 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=HaNee2bYv1cwqupBIgRqHIjBXju+4WjQ4pN3VCKvgIcicUCwTPZrwtGIbIIi2F0lkNY/fYn2BHSC/3KXGUXp9Avr4sSYUrjrN6AapDyy/BRO1FLCfSX+2T24fi6BjjMmU3y/fg3voiWpLQ1HVFF2NcsUTqSu/9kAYmfmp4ksFrw=  ;
X-YMail-OSG: DYjgojUVM1mcHazjei2d2eX3hw.JbQNv0hFO1NdPp2qt_1RvPJqLpF4_dCq7bRWtpVfPg9ScDw--
X-Yahoo-Newman-Property: ymail-3
From: Borislav Petkov <bbpetkov@yahoo.de>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 17/21] ide-floppy: include the proper headers
Date: Fri, 11 Jan 2008 14:19:32 +0100
Message-Id: <1200057572-29230-1-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: 1200052699-28420-1-git-send-email-bbpetkov@yahoo.de
References: 1200052699-28420-1-git-send-email-bbpetkov@yahoo.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-floppy.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index c889c16..89b26ea 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -37,9 +37,9 @@
 #include <scsi/scsi_ioctl.h>
 
 #include <asm/byteorder.h>
-#include <asm/irq.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/irq.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 #include <asm/unaligned.h>
 
 /* The following are used to debug the driver. */
-- 
1.5.3.7

