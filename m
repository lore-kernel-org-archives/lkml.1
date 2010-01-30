Return-Path: <linux-kernel-owner+w=401wt.eu-S1754338Ab0A3UrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab0A3UrP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 15:47:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228Ab0A3UrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 15:47:12 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43913 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab0A3UrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 15:47:10 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <greg@kroah.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Sean MacLennan <smaclennan@pikatech.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5/7] modpost: remove now unused NO_MISMATCH constant
Date: Sat, 30 Jan 2010 21:46:50 +0100
Message-Id: <1264884412-6173-5-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100130204425.GA16345@pengutronix.de>
References: <20100130204425.GA16345@pengutronix.de>
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
 scripts/mod/modpost.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 3f0380b..a94bd10 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -835,7 +835,6 @@ static const char *linker_symbols[] =
 	{ "__init_begin", "_sinittext", "_einittext", NULL };
 
 enum mismatch {
-	NO_MISMATCH,
 	TEXT_TO_ANY_INIT,
 	DATA_TO_ANY_INIT,
 	TEXT_TO_ANY_EXIT,
@@ -1280,8 +1279,6 @@ static void report_sec_mismatch(const char *modname,
 		"Fix this by removing the %sannotation of %s "
 		"or drop the export.\n",
 		tosym, sec2annotation(tosec), sec2annotation(tosec), tosym);
-	case NO_MISMATCH:
-		/* To get warnings on missing members */
 		break;
 	}
 	fprintf(stderr, "\n");
-- 
1.6.6

