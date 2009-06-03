Return-Path: <linux-kernel-owner+w=401wt.eu-S1753604AbZFCAEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbZFCAEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 20:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbZFCAEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 20:04:36 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:63182 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbZFCAEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 20:04:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:organization:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZhX8KAidbuT+YCoeTCmJY+HrxSdQNmRYc13FTxPE0FZwefCN3IrK/q9PXS48gGtm82
         HwQC7vVpx+Rk9OXq80WHzdpSdVI0o+wUqSxGnlVWnIRK07r6TtYr1+GLiEQ4jYWePSNL
         Brm1VVWGh8c/Af0Yh6P4COO+l8WBUhNKSp1l4=
Subject: [PATCH] Fix the meaning of EDAC abbreviation
From: GeunSik Lim <leemgs1@gmail.com>
Reply-To: leemgs1@gmail.com
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, dougthompson@xmission.com
Content-Type: text/plain
Organization: Private
Date: Wed, 03 Jun 2009 09:04:29 +0900
Message-Id: <1243987469.20635.69.camel@centos51>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dear Jiri Kosina,

This is trivial patch about meaning of EDAC in the driver/edac/Kconfig file.
 * Screenshot after patch :
   http://blogfiles16.naver.net/data42/2009/6/3/31/edac-before-after-invain.png


Thanks, 


Subject: [PATCH] Fix the meaning of EDAC abbreviation

Fix the meaning of EDAC(Error Detection And Correction) correctly.
 - http://bluesmoke.sourceforge.net

        Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>
---
 drivers/edac/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 956982f..2a81915 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -5,7 +5,7 @@
 #
 
 menuconfig EDAC
-	bool "EDAC - error detection and reporting"
+	bool "EDAC - Error Detection And Correction"
 	depends on HAS_IOMEM
 	depends on X86 || PPC
 	help
-- 
1.6.3.1



-----------------------------------------------
To unsubscribe from this list: send the line "unsubscribe linux-***" 
in the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

GeunSik Lim ( Samsung Electronics )
e-Mail  :1) geunsik.lim@samsung.com
         2) leemgs@gmail.com , leemgs1@gmail.com
HomePage: http://blog.naver.com/invain/
-----------------------------------------------

