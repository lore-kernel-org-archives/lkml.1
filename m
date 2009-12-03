Return-Path: <linux-kernel-owner+w=401wt.eu-S1754365AbZLCWZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbZLCWZV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 17:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754271AbZLCWZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 17:25:14 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56404 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258AbZLCWZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 17:25:13 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] tip-tags: use git-tag -l instead of git-tag | grep
Date: Thu,  3 Dec 2009 23:24:44 +0100
Message-Id: <1259879084-20147-9-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1259879084-20147-8-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20091203221438.GC13459@pengutronix.de>
 <1259879084-20147-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259879084-20147-2-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259879084-20147-3-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259879084-20147-4-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259879084-20147-5-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259879084-20147-6-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259879084-20147-7-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259879084-20147-8-git-send-email-u.kleine-koenig@pengutronix.de>
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
 .tip/bin/tip-tags |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/.tip/bin/tip-tags b/.tip/bin/tip-tags
index 4bbcac3..08d119f 100755
--- a/.tip/bin/tip-tags
+++ b/.tip/bin/tip-tags
@@ -1,4 +1,3 @@
 #!/bin/bash
 
-git tag | grep ^tip-history
-
+git tag -l tip-history*
-- 
1.6.5.2

