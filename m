Return-Path: <linux-kernel-owner+w=401wt.eu-S1767159AbXEBWt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767159AbXEBWt1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 18:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767161AbXEBWt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 18:49:27 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:33693 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767159AbXEBWt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 18:49:26 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: dtor@mail.ru
Subject: [patch] pull in the linux/input.h header in linux/uinput.h
Date: Wed, 2 May 2007 18:49:35 -0400
User-Agent: KMail/1.9.6
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705021849.35729.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

uinput.h relies on structures only found in input.h, so pull in the header

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
diff --git a/include/linux/uinput.h b/include/linux/uinput.h
index 1fd61ee..a6c1e8e 100644
--- a/include/linux/uinput.h
+++ b/include/linux/uinput.h
@@ -32,6 +32,8 @@
  *		- first public version
  */
 
+#include <linux/input.h>
+
 #define UINPUT_VERSION		3
 
 #ifdef __KERNEL__
