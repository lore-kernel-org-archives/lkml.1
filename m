Return-Path: <linux-kernel-owner+w=401wt.eu-S933708AbYDVPLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933708AbYDVPLB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:11:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755814AbYDVPKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:10:46 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:15502 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647AbYDVPKp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:10:45 -0400
Message-Id: <480E1C1E.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Tue, 22 Apr 2008 16:10:54 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH] FB_EFI should depend on EFI
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 drivers/video/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.25/drivers/video/Kconfig	2008-04-17 04:49:44.000000000 +0200
+++ 2.6.25-fb-efi/drivers/video/Kconfig	2008-04-15 10:49:20.000000000 +0200
@@ -656,7 +656,7 @@ config FB_VESA
 
 config FB_EFI
 	bool "EFI-based Framebuffer Support"
-	depends on (FB = y) && X86
+	depends on (FB = y) && X86 && EFI
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT



