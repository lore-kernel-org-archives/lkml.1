Return-Path: <linux-kernel-owner+w=401wt.eu-S965267AbXCNJGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965267AbXCNJGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965360AbXCNJGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:06:22 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:41346 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965268AbXCNJGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:06:20 -0400
From: Faik Uygur <faik@pardus.org.tr>
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: jgarzik@pobox.com
Subject: [PATCH] kernel-parameters.txt: ATAPI enabled by default
Date: Wed, 14 Mar 2007 11:07:40 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703141107.41168.faik@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In case of libata, discovery of ATAPI devices is the default behaviour.

Signed-off-by: Faik Uygur <faik@pardus.org.tr>

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 856c8b1..96b6ec5 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -695,11 +695,9 @@ and is between 256 and 4096 characters. It is defined in the file
 			Format: <irq>
 
 	combined_mode=	[HW] control which driver uses IDE ports in combined
-			mode: legacy IDE driver, libata, or both
-			(in the libata case, libata.atapi_enabled=1 may be
-			useful as well).  Note that using the ide or libata
-			options may affect your device naming (e.g. by
-			changing hdc to sdb).
+			mode: legacy IDE driver, libata, or both. Note that
+			using the ide or libata options may affect your device
+			naming (e.g. by changing hdc to sdb).
 			Format: combined (default), ide, or libata
 
 	inttest=	[IA64]
