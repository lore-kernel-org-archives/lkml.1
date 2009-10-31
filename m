Return-Path: <linux-kernel-owner+w=401wt.eu-S932855AbZJaJmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855AbZJaJmM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 05:42:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932479AbZJaJmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 05:42:07 -0400
Received: from mail-vw0-f192.google.com ([209.85.212.192]:33643 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932787AbZJaJmE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 05:42:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=bv4KzcsPocL5SLSlU8MVkqHNntShXiSE8AWSom4hE7B/VwixL59ddcJn818pUEeKTk
         yGixqsBtzoqdg10KUcdIktrOwsC5IIxwUu25PdqpF6L95sP0sUgQxnqSewSFHe990m6s
         uHf5BjfJm+USPTQsGZDqGBeaEwnwKS4nQyq18=
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Sat, 31 Oct 2009 07:41:50 -0200
Message-ID: <b8bf37780910310241p1a199a69g259f0d1f5734dfbf@mail.gmail.com>
Subject: [PATCH 13/16] trivial: fix assorted "application" typos
To: trivial@kernel.org, linux list <linux-kernel@vger.kernel.org>
Cc: me <andre.goddard@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9f7c0f8e9071e05881ece88df45f5d4a0f8ce001 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Date: Fri, 30 Oct 2009 07:11:06 -0200
Subject: [PATCH 13/16] trivial: fix assorted "application" typos
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>

diff --git a/Documentation/DocBook/v4l/videodev2.h.xml
b/Documentation/DocBook/v4l/videodev2.h.xml
index 9700206..26303e5 100644
--- a/Documentation/DocBook/v4l/videodev2.h.xml
+++ b/Documentation/DocBook/v4l/videodev2.h.xml
@@ -492,7 +492,7 @@ struct <link
linkend="v4l2-jpegcompression">v4l2_jpegcompression</link> {
                                  * you do, leave them untouched.
                                  * Inluding less markers will make the
                                  * resulting code smaller, but there will
-                                 * be fewer aplications which can read it.
+                                 * be fewer applications which can read it.
                                  * The presence of the APP and COM marker
                                  * is influenced by APP_len and COM_len
                                  * ONLY, not by this property! */
diff --git a/drivers/isdn/hardware/eicon/di.c b/drivers/isdn/hardware/eicon/di.c
index b029d13..cb14ae3 100644
--- a/drivers/isdn/hardware/eicon/di.c
+++ b/drivers/isdn/hardware/eicon/di.c
@@ -806,7 +806,7 @@ static void xdi_xlog_request (byte Adapter, byte Id,
           DELIVERY - indication entered isdn_rc function
           RNR=...  - application had returned RNR=... after the
                      look ahead callback
-          RNum=0   - aplication had not returned any buffer to copy
+          RNum=0   - application had not returned any buffer to copy
                      this indication and will copy it self
           COMPLETE - XDI had copied the data to the buffers provided
                      bu the application and is about to issue the
diff --git a/drivers/media/video/zoran/zoran.h
b/drivers/media/video/zoran/zoran.h
index d439c76..cb1de7e 100644
--- a/drivers/media/video/zoran/zoran.h
+++ b/drivers/media/video/zoran/zoran.h
@@ -106,7 +106,7 @@ struct zoran_params {
 	unsigned long jpeg_markers;	/* Which markers should go into the JPEG output.
 					 * Unless you exactly know what you do, leave them untouched.
 					 * Inluding less markers will make the resulting code
-					 * smaller, but there will be fewer aplications
+					 * smaller, but there will be fewer applications
 					 * which can read it.
 					 * The presence of the APP and COM marker is
 					 * influenced by APP0_len and COM_len ONLY! */
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index b59e78c..dfd4745 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -490,7 +490,7 @@ struct v4l2_jpegcompression {
 				 * you do, leave them untouched.
 				 * Inluding less markers will make the
 				 * resulting code smaller, but there will
-				 * be fewer aplications which can read it.
+				 * be fewer applications which can read it.
 				 * The presence of the APP and COM marker
 				 * is influenced by APP_len and COM_len
 				 * ONLY, not by this property! */
-- 
1.6.5.2.101.gcd0f8
