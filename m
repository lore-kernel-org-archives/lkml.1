Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197AbYLaOqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbYLaOqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 09:46:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755157AbYLaOqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 09:46:37 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45624 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177AbYLaOqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 09:46:36 -0500
Date: Wed, 31 Dec 2008 23:45:46 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>,
       Dmitry Torokhov <dtor@mail.ru>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH for mmotm1230] input: fix incomplete prototype of input_init_abs_bypass()
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <200812310006.mBV060iV029753@imap1.linux-foundation.org>
References: <200812310006.mBV060iV029753@imap1.linux-foundation.org>
Message-Id: <20081231234238.129C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch against: mmotm 1230
Applied after: input-allow-certain-ev_abs-events-to-bypass-all-filtering.patch
==
Impact: warning fixes

fix incomplete prototype of input_init_abs_bypass().


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dtor@mail.ru>

---
 drivers/input/input.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/input/input.c
===================================================================
--- a/drivers/input/input.c	2008-12-31 14:22:38.000000000 +0900
+++ b/drivers/input/input.c	2008-12-31 14:53:49.000000000 +0900
@@ -1657,7 +1657,7 @@ static const struct file_operations inpu
 	.open = input_open_file,
 };
 
-static void __init input_init_abs_bypass()
+static void __init input_init_abs_bypass(void)
 {
 	const unsigned int *p;
 	for (p = input_abs_bypass_init_data; *p; p++)


