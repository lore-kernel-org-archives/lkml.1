Return-Path: <linux-kernel-owner+w=401wt.eu-S1754911AbZIND7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbZIND7a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 23:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbZIND73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 23:59:29 -0400
Received: from mail-pz0-f184.google.com ([209.85.222.184]:34489 "EHLO
	mail-pz0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbZIND72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 23:59:28 -0400
MIME-Version: 1.0
Date: Mon, 14 Sep 2009 09:29:30 +0530
Message-ID: <d760cf2d0909132059j9852955s429be24aea1722ee@mail.gmail.com>
Subject: [PATCH] [mmotm] change "getline" to "get_line" to avoid C library 
	confusion
From: Nitin Gupta <ngupta@vflare.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: justinmattock@gmail.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reintroduce this change to fix compilation error on mmotm.
(Original change by Justin P. Mattock)

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---
 scripts/unifdef.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/unifdef.c b/scripts/unifdef.c
index 552025e..05a31a6 100644
--- a/scripts/unifdef.c
+++ b/scripts/unifdef.c
@@ -206,7 +206,7 @@ static void             done(void);
 static void             error(const char *);
 static int              findsym(const char *);
 static void             flushline(bool);
-static Linetype         getline(void);
+static Linetype         get_line(void);
 static Linetype         ifeval(const char **);
 static void             ignoreoff(void);
 static void             ignoreon(void);
@@ -512,7 +512,7 @@ process(void)

 	for (;;) {
 		linenum++;
-		lineval = getline();
+		lineval = get_line();
 		trans_table[ifstate[depth]][lineval]();
 		debug("process %s -> %s depth %d",
 		    linetype_name[lineval],
@@ -526,7 +526,7 @@ process(void)
  * help from skipcomment().
  */
 static Linetype
-getline(void)
+get_line(void)
 {
 	const char *cp;
 	int cursym;
