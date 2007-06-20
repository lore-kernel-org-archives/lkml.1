Return-Path: <linux-kernel-owner+w=401wt.eu-S1760909AbXFTTWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760909AbXFTTWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 15:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756116AbXFTTWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 15:22:17 -0400
Received: from 241-226.umostel.ru ([77.246.241.226]:61978 "EHLO mail.aknet.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756043AbXFTTWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 15:22:16 -0400
X-Greylist: delayed 2494 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Jun 2007 15:22:16 EDT
Message-ID: <46797505.1030508@aknet.ru>
Date: Wed, 20 Jun 2007 22:42:13 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: [patch] fix module_param mistake in it821x
Content-Type: multipart/mixed;
 boundary="------------050901070303050008050402"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050901070303050008050402
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello.

The attached patch fixes a trivial
mistake in a MODULE_PARAM_DESC of pata_it821x
driver. The parameter name in MODULE_PARAM_DESC
should match the one in module_param_named.

Signed-off-by: Stas Sergeev <stsp@aknet.ru>


--------------050901070303050008050402
Content-Type: text/x-patch;
 name="it821xmodp.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="it821xmodp.diff"

--- a/drivers/ata/pata_it821x.c	2007-04-27 12:46:35.000000000 +0400
+++ b/drivers/ata/pata_it821x.c	2007-06-20 18:16:20.000000000 +0400
@@ -828,7 +828,7 @@
 
 
 module_param_named(noraid, it8212_noraid, int, S_IRUGO);
-MODULE_PARM_DESC(it8212_noraid, "Force card into bypass mode");
+MODULE_PARM_DESC(noraid, "Force card into bypass mode");
 
 module_init(it821x_init);
 module_exit(it821x_exit);

--------------050901070303050008050402--
