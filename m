Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab0BLXSd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 18:18:33 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:63964 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab0BLXSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 18:18:32 -0500
Date: Fri, 12 Feb 2010 15:17:42 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org
Subject: [PATCH] mtrr: fix missing kernel-doc
Message-Id: <20100212151742.8d659da9.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4B75E1A2.00D8:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix missing kernel-doc notation in mtrr/main.c:

Warning(arch/x86/kernel/cpu/mtrr/main.c:152): No description found for parameter 'info'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/kernel/cpu/mtrr/main.c |    1 +
 1 file changed, 1 insertion(+)

--- lnx-2633-rc8.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ lnx-2633-rc8/arch/x86/kernel/cpu/mtrr/main.c
@@ -145,6 +145,7 @@ struct set_mtrr_data {
 
 /**
  * ipi_handler - Synchronisation handler. Executed by "other" CPUs.
+ * @info: pointer to mtrr configuration data
  *
  * Returns nothing.
  */
