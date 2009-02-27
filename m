Return-Path: <linux-kernel-owner+w=401wt.eu-S1758437AbZB0TqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437AbZB0TqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 14:46:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757361AbZB0Tpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 14:45:54 -0500
Received: from perninha.conectiva.com.br ([200.140.247.100]:38393 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757271AbZB0Tpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 14:45:53 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Organization: Mandriva
To: Jaya Kumar <jayakumar.lkml@gmail.com>
Subject: [PATCH v2] n411: add missing Makefile entry
Date: Fri, 27 Feb 2009 16:46:04 -0300
User-Agent: KMail/1.11.0 (Linux/2.6.29-desktop-0.rc6.1.1mnb; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902271646.05170.herton@mandriva.com.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no entry for n411.c to be built, include one in Makefile.

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 drivers/video/Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

v2: resend, proper patch without mailer line breaks

diff --git a/drivers/video/Makefile b/drivers/video/Makefile
index 2a998ca..4bd8050 100644
--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@ -76,6 +76,7 @@ obj-$(CONFIG_FB_ATARI)            += atafb.o c2p_iplan2.o atafb_mfb.o \
                                      atafb_iplan2p2.o atafb_iplan2p4.o atafb_iplan2p8.o
 obj-$(CONFIG_FB_MAC)              += macfb.o
 obj-$(CONFIG_FB_HECUBA)           += hecubafb.o
+obj-$(CONFIG_FB_N411)             += n411.o
 obj-$(CONFIG_FB_HGA)              += hgafb.o
 obj-$(CONFIG_FB_XVR500)           += sunxvr500.o
 obj-$(CONFIG_FB_XVR2500)          += sunxvr2500.o
-- 
1.6.1.3

