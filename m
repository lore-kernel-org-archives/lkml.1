Return-Path: <linux-kernel-owner+w=401wt.eu-S1762726AbXIKISR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762726AbXIKISR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 04:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760614AbXIKISF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 04:18:05 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:59844 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759725AbXIKISD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 04:18:03 -0400
Date: Tue, 11 Sep 2007 17:17:52 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Januszewski <spock@gentoo.org>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm] video: uvesafb: Add X86 dependency.
Message-ID: <20070911081752.GA19495@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Januszewski <spock@gentoo.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

uvesafb is x86-specific, reflect that in the Kconfig.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

--

 drivers/video/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.23-rc4-mm1.orig/drivers/video/Kconfig	2007-09-11 15:15:52.000000000 +0900
+++ linux-2.6.23-rc4-mm1/drivers/video/Kconfig	2007-09-11 17:01:04.000000000 +0900
@@ -593,7 +593,7 @@
 
 config FB_UVESA
 	tristate "Userspace VESA VGA graphics support"
-	depends on FB && CONNECTOR
+	depends on FB && CONNECTOR && X86
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
