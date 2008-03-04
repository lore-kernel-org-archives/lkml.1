Return-Path: <linux-kernel-owner+w=401wt.eu-S1758831AbYCDFId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831AbYCDFId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 00:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbYCDFIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 00:08:24 -0500
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:37519 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbYCDFIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 00:08:23 -0500
Date: Tue, 4 Mar 2008 16:05:06 +1100
To: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [PATCH] Build fix for drivers/s390/char/defkeymap.c
Message-ID: <20080304050506.GC6887@bakeyournoodle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 5ce2087ed0eb424e0889bdc9102727f65d2ecdde (Fix default compose
table initialization) left a trailing quote.

  CC      drivers/s390/char/defkeymap.o
drivers/s390/char/defkeymap.c:155: error: missing terminating ' character
drivers/s390/char/defkeymap.c:156: error: syntax error before ';' token
make[3]: *** [drivers/s390/char/defkeymap.o] Error 1

Fix that.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
---
 drivers/s390/char/defkeymap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/s390/char/defkeymap.c b/drivers/s390/char/defkeymap.c
index 9692d6a..07c7f31 100644
--- a/drivers/s390/char/defkeymap.c
+++ b/drivers/s390/char/defkeymap.c
@@ -152,7 +152,7 @@ char *func_table[MAX_NR_FUNC] = {
 
 struct kbdiacruc accent_table[MAX_DIACR] = {
 	{'^', 'c', 0003},	{'^', 'd', 0004},
-	{'^', 'z', 0032},	{'^', 0012', 0000},
+	{'^', 'z', 0032},	{'^', 0012, 0000},
 };
 
 unsigned int accent_table_size = 4;
-- 
1.5.4.2

Yours Tony

  linux.conf.au    http://www.marchsouth.org/
  Jan 19 - 24 2009 The Australian Linux Technical Conference!

