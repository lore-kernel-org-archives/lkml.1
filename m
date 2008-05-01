Return-Path: <linux-kernel-owner+w=401wt.eu-S1761941AbYEASMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761941AbYEASMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 14:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbYEASLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 14:11:55 -0400
Received: from mail.anarazel.de ([217.115.131.40]:36245 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbYEASLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 14:11:54 -0400
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 May 2008 14:11:54 EDT
From: Andres Freund <andres@anarazel.de>
To: linux-kernel@vger.kernel.org, apdim@grecian.net,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] v4l/dvb: Add linux/version.h include as KERNEL_VERSION macro is used.
Date: Thu, 1 May 2008 20:05:41 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805012005.42400.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whitout this build fails with unknown macro on 
e4c576b911e364737b1bf4f5bfdab1c440713f26

Hopefully I did everything correct, as this is my first usage of git beside 
checking out. Also its my first patch on lk....

Is an Signed-off-by already appropriate with such an trivial change?

Signed-off-by: Andres Freund <andres@anarazel.de>
---
 drivers/media/radio/radio-maxiradio.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/radio/radio-maxiradio.c 
b/drivers/media/radio/radio-maxiradio.c
index 0133ecf..e170fcd 100644
--- a/drivers/media/radio/radio-maxiradio.c
+++ b/drivers/media/radio/radio-maxiradio.c
@@ -34,6 +34,7 @@
 
 
 #include <linux/module.h>
+#include <linux/version.h>
 #include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/delay.h>
