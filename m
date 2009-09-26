Return-Path: <linux-kernel-owner+w=401wt.eu-S1752412AbZIZNGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbZIZNGU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 09:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbZIZNGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 09:06:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:33906 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbZIZNGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 09:06:18 -0400
Subject: [PATCH] alpha: Remove unused CONFIG ALPHA_EV7
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>
Content-Type: text/plain
Date: Sat, 26 Sep 2009 18:35:53 +0530
Message-Id: <1253970353.4568.5.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ALPHA_EV7 is unused and currently ALPHA_MARVEL is used for EV7.

Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
---
 arch/alpha/Kconfig |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 4434481..2a50491 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -449,11 +449,6 @@ config ALPHA_EV67
 	  Is this a machine based on the EV67 core?  If in doubt, select N here
 	  and the machine will be treated as an EV6.
 
-config ALPHA_EV7
-	bool
-	depends on ALPHA_MARVEL
-	default y
-
 config ALPHA_MCPCIA
 	bool
 	depends on ALPHA_RAWHIDE
-- 
1.6.0.6


