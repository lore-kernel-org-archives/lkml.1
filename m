Return-Path: <linux-kernel-owner+w=401wt.eu-S1752940AbYJREm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbYJREm3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 00:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbYJREmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 00:42:04 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:42224 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbYJREmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 00:42:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:cc:message-id:mime-version:content-type
         :content-transfer-encoding:x-mailer;
        b=PQjhDszGcpJljIqaqD5NVXx5Pn+eqtDCRc4Ava6KWx93CxLFjOq1DRvAkvQuJG1lNT
         2IbMz0TTuAoQtgDBsuGLhisSFN6z2uzlXi79wVF8ZsOtVO1pEEPk81MH8sS4SmWMnftZ
         asAaMIhu2sadlsQ/wfn8StED2C7koaBNBf0bs=
Date: Sat, 18 Oct 2008 12:41:57 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: gregkh@suse.de
Subject: staging: SLICOSS: remove unused #include <version.h>
Cc: linux-kernel@vger.kernel.org
Message-Id: <20081018123715.CD78.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.24.02 [en]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file(s) below do not use LINUX_VERSION_CODE nor KERNEL_VERSION.
  drivers/staging/slicoss/slicoss.c

This patch removes the said #include <version.h>.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index b61ac4b..7d23d9a 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -54,7 +54,6 @@
  *       IS-NIC driver.
  */

-#include <linux/version.h>

 #define SLIC_DUMP_ENABLED               0
 #define KLUDGE_FOR_4GB_BOUNDARY         1



