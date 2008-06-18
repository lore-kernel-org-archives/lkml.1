Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166AbYFRR3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbYFRR3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 13:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbYFRR3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 13:29:14 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:48777 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbYFRR3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 13:29:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=UfHPwqR4ymDvcEjmfAeAzziIXP/MoxWaonIjceTuXX9xNZdaOi4MyzZrmDUq5xwHll
         YCo8sg1AcFt5qY8904zcVfIrFcAHSnO6u1fXFNIBiiT84zMcWOpQc1YEvBq6e+KJpZ/B
         IctFMXZO0qx165ZynRJ4sfcAYgpCePAK2w9hY=
Subject: [PATCH] w100fb: do not depend on SHARPSL
From: Philipp Zabel <philipp.zabel@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Alberto Mardegan <mardy@users.sourceforge.net>, Ian Molton <spyro@f2s.com>,
       Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain
Date: Wed, 18 Jun 2008 19:29:06 +0200
Message-Id: <1213810146.8144.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apart from Sharp SL-Cxx series, there are a few other devices that have
ATI Imageon chips, among them HP iPAQ hx4700.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/video/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 002b61b..e0c5f96 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -1825,12 +1825,13 @@ config FB_FSL_DIU
 
 config FB_W100
 	tristate "W100 frame buffer support"
-	depends on FB && PXA_SHARPSL
+	depends on FB && ARCH_PXA
  	select FB_CFB_FILLRECT
  	select FB_CFB_COPYAREA
  	select FB_CFB_IMAGEBLIT
 	---help---
 	  Frame buffer driver for the w100 as found on the Sharp SL-Cxx series.
+	  It can also drive the w3220 chip found on iPAQ hx4700.
 
 	  This driver is also available as a module ( = code which can be
 	  inserted and removed from the running kernel whenever you want). The
-- 
1.5.5.4


