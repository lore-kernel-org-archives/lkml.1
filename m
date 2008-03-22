Return-Path: <linux-kernel-owner+w=401wt.eu-S1758753AbYCVXL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758753AbYCVXL6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 19:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbYCVXLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 19:11:35 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:24305 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbYCVXLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 19:11:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=D990yENt9mJAyzkmjdrp5E2v5x0lORNVal5sjL2IB0VZCoa29z3rW4JoYzdch0yshiFR++iKGmnToI/rmnBduPgWgT3dp93rERtx5Kev+lyooXvi/K2KhFafm8teE26cLiCMgpiCluV9W1nJwth4lDlH2U/X83P9asBzHtOR9R0=
Date: Sun, 23 Mar 2008 02:09:12 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org, adaplas@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] nv: drop useless CONFIG_PCI checks
Message-ID: <20080322230912.GA14426@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both FB_RIVA and FB_NVIDIA depends on PCI, so
CONFIG_PCI always defined for them.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/video/riva/fbdev.c     |    4 ----
 drivers/video/riva/nv_driver.c |    5 -----
 2 files changed, 9 deletions(-)

--- a/drivers/video/riva/fbdev.c
+++ b/drivers/video/riva/fbdev.c
@@ -56,10 +56,6 @@
 #include "rivafb.h"
 #include "nvreg.h"
 
-#ifndef CONFIG_PCI		/* sanity check */
-#error This driver requires PCI support.
-#endif
-
 /* version number of this driver */
 #define RIVAFB_VERSION "0.9.5b"
 
--- a/drivers/video/riva/nv_driver.c
+++ b/drivers/video/riva/nv_driver.c
@@ -41,11 +41,6 @@
 #include "rivafb.h"
 #include "nvreg.h"
 
-
-#ifndef CONFIG_PCI		/* sanity check */
-#error This driver requires PCI support.
-#endif
-
 #define PFX "rivafb: "
 
 static inline unsigned char MISCin(struct riva_par *par)

