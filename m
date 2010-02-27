Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030362Ab0B0Qyl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:54:41 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968581Ab0B0Qyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:54:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=h0PQiH8+iB4XSCs9tmOkgC6gQ6oGUDWfLEkYhWf4m6WtGU8RFCTHo+Cs6fPjouD6iH
         NFldkNI1Q8sEWRHZ64fRQiCs3jXbJiFRDmT+P+kxvw7G0iaL/BfhmnqmhEwhQz+W527b
         ihnq/O+3HCMSJg6wIMkGN367c7svVUG/ULc4Q=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: [PATCH 27/66] include/linux/raw.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:08 +0100
Message-Id: <1267289508-31031-28-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/linux/raw.h:6: ERROR: space prohibited after that open parenthesis '('
include/linux/raw.h:6: ERROR: space prohibited before that close parenthesis ')'
include/linux/raw.h:7: ERROR: space prohibited after that open parenthesis '('
include/linux/raw.h:7: ERROR: space prohibited before that close parenthesis ')'
include/linux/raw.h:9: ERROR: trailing whitespace
include/linux/raw.h:10: ERROR: open brace '{' following struct go on the same line

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 include/linux/raw.h |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/linux/raw.h b/include/linux/raw.h
index 62d543e..01d635b 100644
--- a/include/linux/raw.h
+++ b/include/linux/raw.h
@@ -3,11 +3,10 @@
 
 #include <linux/types.h>
 
-#define RAW_SETBIND	_IO( 0xac, 0 )
-#define RAW_GETBIND	_IO( 0xac, 1 )
+#define RAW_SETBIND	_IO(0xac, 0)
+#define RAW_GETBIND	_IO(0xac, 1)
 
-struct raw_config_request 
-{
+struct raw_config_request {
 	int	raw_minor;
 	__u64	block_major;
 	__u64	block_minor;
-- 
1.7.0.90.g251a4

