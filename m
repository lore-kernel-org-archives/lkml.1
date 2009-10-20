Return-Path: <linux-kernel-owner+w=401wt.eu-S1752532AbZJTVtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbZJTVtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 17:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbZJTVtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 17:49:20 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:60805 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbZJTVtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 17:49:20 -0400
Message-ID: <4ADE3016.3040208@oracle.com>
Date: Tue, 20 Oct 2009 14:48:06 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: [PATCH] x86 defconfigs: disable TR (token ring)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4ADE3002.021B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Disable CONFIG_TR in x86 defconfigs, bring them into
the 21st century.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/configs/i386_defconfig   |    2 +-
 arch/x86/configs/x86_64_defconfig |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- lnx-2632-rc5.orig/arch/x86/configs/i386_defconfig
+++ lnx-2632-rc5/arch/x86/configs/i386_defconfig
@@ -1089,7 +1089,7 @@ CONFIG_CHELSIO_T3_DEPENDS=y
 # CONFIG_QLGE is not set
 # CONFIG_SFC is not set
 # CONFIG_BE2NET is not set
-CONFIG_TR=y
+# CONFIG_TR is not set
 # CONFIG_IBMOL is not set
 # CONFIG_IBMLS is not set
 # CONFIG_3C359 is not set
--- lnx-2632-rc5.orig/arch/x86/configs/x86_64_defconfig
+++ lnx-2632-rc5/arch/x86/configs/x86_64_defconfig
@@ -1082,7 +1082,7 @@ CONFIG_CHELSIO_T3_DEPENDS=y
 # CONFIG_QLGE is not set
 # CONFIG_SFC is not set
 # CONFIG_BE2NET is not set
-CONFIG_TR=y
+# CONFIG_TR is not set
 # CONFIG_IBMOL is not set
 # CONFIG_3C359 is not set
 # CONFIG_TMS380TR is not set
