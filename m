Return-Path: <linux-kernel-owner+w=401wt.eu-S1753177AbZI1UfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbZI1UfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 16:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbZI1UfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 16:35:06 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:21923 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbZI1UfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 16:35:05 -0400
Date: Mon, 28 Sep 2009 13:34:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: akpm@linux-foundation.org, Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, ecryptfs-devel@lists.launchpad.net
Subject: [PATCH -mmotm] ecryptfs: depends on CRYPTO
Message-Id: <20090928133420.f53a015f.randy.dunlap@oracle.com>
In-Reply-To: <200909252158.n8PLwFhG024011@imap1.linux-foundation.org>
References: <200909252158.n8PLwFhG024011@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt007.oracle.com [141.146.116.16]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4AC11DD1.001E:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

ecryptfs uses crypto APIs so it should depend on CRYPTO.
Otherwise many build errors occur. [63 lines not pasted]

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/ecryptfs/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- mmotm-2009-0925-1435.orig/fs/ecryptfs/Kconfig
+++ mmotm-2009-0925-1435/fs/ecryptfs/Kconfig
@@ -1,6 +1,6 @@
 config ECRYPT_FS
 	tristate "eCrypt filesystem layer support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && KEYS && NET
+	depends on EXPERIMENTAL && KEYS && NET && CRYPTO
 	select CRYPTO_ECB
 	select CRYPTO_CBC
 	help
