Return-Path: <linux-kernel-owner+w=401wt.eu-S1760115AbXH3Kly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760115AbXH3Kly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 06:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756641AbXH3Klp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 06:41:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:49401 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179AbXH3Klo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 06:41:44 -0400
Date: Thu, 30 Aug 2007 12:37:36 +0200
From: andre@finow14.de
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andre Haupt <andre@finow14.de>,
       sfrench@us.ibm.com
Subject: [KJ][patch 2/3] CIFS SMB: use abs() from kernel.h where appropriate
Message-ID: <20070830103736.GC14925@ahaupt-debian-vm.localdomain>
References: <20070830102551.131398783@finow14.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cifssmb_use_abs_from_kernel_h.patch"
User-Agent: quilt/0.45-1
X-Provags-ID: V01U2FsdGVkX18hqAO+UjcuDxCSXuaGGHJP9tmsPTnjX45YLgL
 cwXXpVJ595F7kHWRUGaPubALp0nxnA8iPodoKM4ggHjkXyg85x
 TxrYR6W8NFQRqI+jI02hlDav9IDDcnw
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Haupt <andre@finow14.de>
Signed-off-by: Andre Haupt <andre@finow14.de>
---
Index: linus/fs/cifs/cifssmb.c
===================================================================
--- linus.orig/fs/cifs/cifssmb.c	2007-08-30 11:43:20.000000000 +0200
+++ linus/fs/cifs/cifssmb.c	2007-08-30 11:44:58.000000000 +0200
@@ -513,7 +513,7 @@ CIFSSMBNegotiate(unsigned int xid, struc
 				(int)ts.tv_sec, (int)utc.tv_sec,
 				(int)(utc.tv_sec - ts.tv_sec)));
 			val = (int)(utc.tv_sec - ts.tv_sec);
-			seconds = val < 0 ? -val : val;
+			seconds = abs(val);
 			result = (seconds / MIN_TZ_ADJ) * MIN_TZ_ADJ;
 			remain = seconds % MIN_TZ_ADJ;
 			if (remain >= (MIN_TZ_ADJ / 2))

--
