Return-Path: <linux-kernel-owner+w=401wt.eu-S1757871AbYFXV53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871AbYFXV53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 17:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756681AbYFXV4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 17:56:34 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:51389 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646AbYFXV4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 17:56:16 -0400
Date: Wed, 25 Jun 2008 00:54:15 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       rmk@arm.linux.org.uk, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [1/5] remove BLK_DEV_HD_ONLY
Message-ID: <20080624215414.GC18252@cs181140183.pp.htv.fi>
References: <20080609222155.GA1987@cs181133002.pp.htv.fi> <200806101956.15711.bzolnier@gmail.com> <20080622101752.GG27069@cs181133002.pp.htv.fi> <200806221521.33506.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200806221521.33506.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit 80aa31cb460d12c1e02327b43eceb3eebc6e7090
(ide: remove CONFIG_BLK_DEV_HD_IDE config option (take 2))
the indirection through BLK_DEV_HD_ONLY is no longer required.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/ide/Kconfig |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

5af5ece5e303cf8d6797510fa2e1ec0ffdf9c110 diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 8e07de2..1933345 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -1019,7 +1019,7 @@ config BLK_DEV_IDEDMA
 
 endif
 
-config BLK_DEV_HD_ONLY
+config BLK_DEV_HD
 	bool "Old hard disk (MFM/RLL/IDE) driver"
 	depends on !ARM || ARCH_RPC || ARCH_SHARK || BROKEN
 	help
@@ -1042,7 +1042,4 @@ config BLK_DEV_HD_ONLY
 	  Disk-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-config BLK_DEV_HD
-	def_bool BLK_DEV_HD_ONLY
-
 endif # IDE
