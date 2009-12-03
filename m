Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbZLCW0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbZLCW0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 17:26:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754416AbZLCWZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 17:25:24 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56414 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384AbZLCWZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 17:25:23 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/9] tip-urgent-count: get rid of an unneeded subshell
Date: Thu,  3 Dec 2009 23:24:39 +0100
Message-Id: <1259879084-20147-4-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1259879084-20147-3-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20091203221438.GC13459@pengutronix.de>
 <1259879084-20147-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259879084-20147-2-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259879084-20147-3-git-send-email-u.kleine-koenig@pengutronix.de>
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
 .tip/bin/tip-urgent-count |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/.tip/bin/tip-urgent-count b/.tip/bin/tip-urgent-count
index 7252187..fd46933 100755
--- a/.tip/bin/tip-urgent-count
+++ b/.tip/bin/tip-urgent-count
@@ -11,7 +11,7 @@ for N in $URGENT; do
 done
 
 echo "-------------------------"
-printf "%20s: %3d\n" "TOTAL" $(git log --pretty=oneline --no-merges $(echo $URGENT | sed 's/^/linus../g') | wc -l)
+printf "%20s: %3d\n" "TOTAL" $(git log --pretty=oneline --no-merges $URGENT ^linus | wc -l)
 
 echo
 
-- 
1.6.5.2

