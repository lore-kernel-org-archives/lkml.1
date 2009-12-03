Return-Path: <linux-kernel-owner+w=401wt.eu-S1753890AbZLCWY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbZLCWY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 17:24:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbZLCWY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 17:24:58 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56385 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbZLCWY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 17:24:57 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/9] tipbin/git-log-line: add comment about alternative
Date: Thu,  3 Dec 2009 23:24:38 +0100
Message-Id: <1259879084-20147-3-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1259879084-20147-2-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20091203221438.GC13459@pengutronix.de>
 <1259879084-20147-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259879084-20147-2-git-send-email-u.kleine-koenig@pengutronix.de>
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
 .tip/bin/git-log-line |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/.tip/bin/git-log-line b/.tip/bin/git-log-line
index d92fd63..d16e998 100755
--- a/.tip/bin/git-log-line
+++ b/.tip/bin/git-log-line
@@ -1,4 +1,6 @@
 #! /bin/sh
+# the same can be accomplish by executing once:
+# 	$ git config --global alias.log-line 'log --pretty=format:"%h: %s"'
 
 git log --pretty=format:"%h: %s" $@
 
-- 
1.6.5.2

