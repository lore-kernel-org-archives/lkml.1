Return-Path: <linux-kernel-owner+w=401wt.eu-S932306AbXDEH02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306AbXDEH02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 03:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946023AbXDEH02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 03:26:28 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:30205 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932306AbXDEH01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 03:26:27 -0400
X-IronPort-AV: i="4.14,373,1170651600"; 
   d="scan'208"; a="33814786:sNHT27176842"
Subject: [PATCH] blackfin arch: 0.4 and 0.5 silicon doesnt exist for BF534,
	BF536 adn BF537 so dont let people select the option
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Thu, 05 Apr 2007 15:28:10 +0800
Message-Id: <1175758090.17315.50.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 88e831a..91e6804 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -131,11 +131,11 @@ config BF_REV_0_3
 
 config BF_REV_0_4
 	bool "0.4"
-	depends on (BF561 || BF537 || BF536 || BF534 || BF533 || BF532 || BF531)
+	depends on (BF561 || BF533 || BF532 || BF531)
 
 config BF_REV_0_5
 	bool "0.5"
-	depends on (BF561 || BF537 || BF536 || BF534 || BF533 || BF532 || BF531)
+	depends on (BF561 || BF533 || BF532 || BF531)
 
 endchoice
 
-- 
1.5.0.5

