Return-Path: <linux-kernel-owner+w=401wt.eu-S1756877AbYFXA3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbYFXA3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 20:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755592AbYFXA3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 20:29:06 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:65093 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbYFXA3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 20:29:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=agFoXOCFmhqijMn6Grq1pfLyiFvXSX9ezM7uQUwtttkwHDeVWU6TIlGi9zsB/+g7LN
         TJZMh+4j4cvTTlDFWDAFr06uX8ohmcr2DlEukj2us6/zQXF2934jTKJFhCUoGEChyYmF
         SsnbhVh4usxQnF4TzZLu62LLcuOaB9oBgjWS8=
Subject: [PATCH 1/3] h8300: Use packed struct rather than memmove for
	unaligned access
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 23 Jun 2008 17:28:58 -0700
Message-Id: <1214267338.21092.56.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
There are only 3 arches that use the memmove implementation, do you see
any problems with using the packed struct implementation so the memmove
version could be removed?

 include/asm-h8300/unaligned.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-h8300/unaligned.h b/include/asm-h8300/unaligned.h
index b8d06c7..ab851e7 100644
--- a/include/asm-h8300/unaligned.h
+++ b/include/asm-h8300/unaligned.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_H8300_UNALIGNED_H
 #define _ASM_H8300_UNALIGNED_H
 
-#include <linux/unaligned/be_memmove.h>
+#include <linux/unaligned/be_struct.h>
 #include <linux/unaligned/le_byteshift.h>
 #include <linux/unaligned/generic.h>
 
-- 
1.5.6.290.gc4e15


