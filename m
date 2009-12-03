Return-Path: <linux-kernel-owner+w=401wt.eu-S1754398AbZLCWZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbZLCWZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 17:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384AbZLCWZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 17:25:26 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56411 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364AbZLCWZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 17:25:21 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] tip-lib: let git-show find the sha1 of the interesting files
Date: Thu,  3 Dec 2009 23:24:41 +0100
Message-Id: <1259879084-20147-6-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1259879084-20147-5-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20091203221438.GC13459@pengutronix.de>
 <1259879084-20147-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259879084-20147-2-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259879084-20147-3-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259879084-20147-4-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259879084-20147-5-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 .tip/bin/tip-lib |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/.tip/bin/tip-lib b/.tip/bin/tip-lib
index 1311d63..5078cee 100644
--- a/.tip/bin/tip-lib
+++ b/.tip/bin/tip-lib
@@ -67,7 +67,6 @@ get_linux_next_branches() {
 get_auto_merged_topics() {
     for B in $@
     do
-	local TB=`git ls-tree tip -- .tip/auto-branches/$B | sed -e "s/.*blob //" -e "s/\ *.tip.*//"`
-	git show $TB | sed -e "s/#.*//" -e "/^ *$/d"
+	git show tip:.tip/auto-branches/$B | sed -e "s/#.*//" -e "/^ *$/d"
     done
 }
-- 
1.6.5.2

