Return-Path: <linux-kernel-owner+w=401wt.eu-S1756054AbZHMULi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbZHMULi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932082AbZHMULg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:11:36 -0400
Received: from kroah.org ([198.145.64.141]:41704 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755932AbZHMT73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:29 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:28 2009
Message-Id: <20090813195127.947446438@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:49:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Lu Zhihe <tombowfly@gmail.com>,
       Doug Thompson <dougthompson@xmission.com>
Subject: [patch 23/74] edac: x38 fix mchbar high register addr
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=edac-x38-fix-mchbar-high-register-addr.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lu Zhihe <tombowfly@gmail.com>

commit 3d768213a6c34a27fac1804143da8cf18b8b175f upstream.

Intel X38 MCHBAR is a 64bits register, base from 0x48, so its higher base
is 0x4C.

Signed-off-by: Lu Zhihe <tombowfly@gmail.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/edac/x38_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/edac/x38_edac.c
+++ b/drivers/edac/x38_edac.c
@@ -30,7 +30,7 @@
 /* Intel X38 register addresses - device 0 function 0 - DRAM Controller */
 
 #define X38_MCHBAR_LOW	0x48	/* MCH Memory Mapped Register BAR */
-#define X38_MCHBAR_HIGH	0x4b
+#define X38_MCHBAR_HIGH	0x4c
 #define X38_MCHBAR_MASK	0xfffffc000ULL	/* bits 35:14 */
 #define X38_MMR_WINDOW_SIZE	16384
 


