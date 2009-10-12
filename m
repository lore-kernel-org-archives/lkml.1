Return-Path: <linux-kernel-owner+w=401wt.eu-S1753515AbZJLDBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbZJLDBZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 23:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbZJLDBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 23:01:24 -0400
Received: from mail-pz0-f201.google.com ([209.85.222.201]:46245 "EHLO
	mail-pz0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbZJLDBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 23:01:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ghLYQ2XrnDxFOfemRC5RP2PxDC6KpPcEPgL/8GN0CIOuxNjiIG5aPAZRh2BaFT103D
         9BHQw5r70+0ysAXSj5eKtZ9EEvmDnekpua1acH3EXryktlL6NHkHvRUmENsKRfoa2Y2O
         kkayKnFm/MB7cvvz75CzMQ/GJd+AP5tKZm1Nw=
From: Xiaotian Feng <xtfeng@gmail.com>
To: clem@clem.clem-digital.net, akpm@linux-foundation.org,
       dbrownell@users.sourceforge.net, a.zummo@towertech.it,
       viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>
Subject: [PATCH] rtc: fix compile failure in drivers/char/rtc.c
Date: Mon, 12 Oct 2009 11:00:54 +0800
Message-Id: <1255316454-26447-1-git-send-email-xtfeng@gmail.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiaotian Feng <dfeng@redhat.com>

commit d43c36d removed sched.h from interrupt.h, this causes compile
failure in drivers/char/rtc.c.

Reported-by: Pete Clements <clem@clem.clem-digital.net>
Signed-of-by: Xiaotian Feng <xtfeng@gmail.com>
---
 drivers/char/rtc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/rtc.c b/drivers/char/rtc.c
index e0d0f8b..1bce8fc 100644
--- a/drivers/char/rtc.c
+++ b/drivers/char/rtc.c
@@ -62,6 +62,7 @@
  */
 
 #include <linux/interrupt.h>
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
-- 
1.6.2.5

