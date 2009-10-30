Return-Path: <linux-kernel-owner+w=401wt.eu-S1755482AbZJ3AFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbZJ3AFM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 20:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbZJ3AFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 20:05:12 -0400
Received: from mail-qy0-f174.google.com ([209.85.221.174]:53273 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbZJ3AFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 20:05:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=tj+w4xcn30g5ohescKU9LMI0jEjdOLoZbWR0OxjWdN1rT4cY5s2ECK5ANUBQUTZFKb
         hLKVF22TznsPPoaDAXlW62LSbHZ8wZZf1xz5NDq1T7nixhMkzibGWoOaBUsqUSqr9URp
         bfIjJz2tDcMhXF+z4jzQVBzf5egg2PzhjF8zc=
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, otus-devel@venema.h4ckr.net, Luis.Rodriguez@Atheros.com,
       Thiago Farina <tfransosi@gmail.com>
Subject: [PATCH] staging/otus: trivial, fix sparse warnig.
Date: Thu, 29 Oct 2009 20:04:26 -0400
Message-Id: <1256861066-21954-1-git-send-email-tfransosi@gmail.com>
X-Mailer: git-send-email 1.6.5.1.61.ge79999
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*apdbg.c: use NULL pointer instead of 0 integer.

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 drivers/staging/otus/apdbg.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/otus/apdbg.c b/drivers/staging/otus/apdbg.c
index d3e2f62..70a40b8 100644
--- a/drivers/staging/otus/apdbg.c
+++ b/drivers/staging/otus/apdbg.c
@@ -109,7 +109,7 @@ int set_ioctl(int sock, struct ifreq *req)
 
 int read_reg(int sock, struct ifreq *req)
 {
-    struct zdap_ioctl *zdreq = 0;
+    struct zdap_ioctl *zdreq = NULL;
 
     if (!set_ioctl(sock, req))
         return -1;
@@ -123,7 +123,7 @@ int read_reg(int sock, struct ifreq *req)
 
 int read_mem(int sock, struct ifreq *req)
 {
-    struct zdap_ioctl *zdreq = 0;
+    struct zdap_ioctl *zdreq = NULL;
     int i;
 
     if (!set_ioctl(sock, req))
-- 
1.6.5.1.61.ge79999

