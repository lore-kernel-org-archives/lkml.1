Return-Path: <linux-kernel-owner+w=401wt.eu-S1755901AbZFCKUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbZFCKUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 06:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753588AbZFCKUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 06:20:14 -0400
Received: from mail-px0-f182.google.com ([209.85.216.182]:60193 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbZFCKUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 06:20:13 -0400
X-Greylist: delayed 435 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Jun 2009 06:20:13 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=ZJ1WaVSr+rJO0GwQBWmBE//UAnUMVzZ0fZJmbCveHTM8gkomU0Pow690rAMAWnaQd/
         pvWDCkj7BvPkyucIPR6fkfclnsri9DURZKiL6dQIJqr2JV/UHzUlGnOdUN0F5BmTQm5N
         Ft3L8l8liwh/HHR9dbHTBFu6YOBsHkuXUrZlI=
Subject: [PATCH V2] Fix the meaning of EDAC abbreviation
From: GeunSik Lim <leemgs1@gmail.com>
Reply-To: leemgs1@gmail.com
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, dougthompson@xmission.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1243987469.20635.69.camel@centos51>
References: <1243987469.20635.69.camel@centos51>
Content-Type: text/plain
Organization: Private
Date: Wed, 03 Jun 2009 19:12:53 +0900
Message-Id: <1244023973.20635.81.camel@centos51>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




Dear Jiri Kosina,

This is trivial patch.
I updated description about EDAC in the driver/edac/Kconfig. 
thanks to Alan Cox.  Please, merge this patch. 
 
 * Changelogs - V1
    - Modify original word of EDAC abbreviation.
       ( http://patchwork.kernel.org/patch/27592/ )
 


Thanks, 


Subject: [PATCH V2] Fix the meaning of EDAC abbreviation

Fix the meaning of EDAC(Error Detection And Correction) correctly.
 - http://bluesmoke.sourceforge.net

        Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>
        Reviewed-by  : Alan Cox <alan@lxorguk.ukuu.org.uk>
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
+	bool "EDAC(Error Detection And Correction) reporting"
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

