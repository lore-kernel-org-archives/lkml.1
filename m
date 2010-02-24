Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758408Ab0BXWYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 17:24:23 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:65141 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758395Ab0BXWYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 17:24:22 -0500
Date: Wed, 24 Feb 2010 14:23:21 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org
Subject: [PATCH resend] mtrr: fix missing kernel-doc notation
Message-Id: <20100224142321.cc614f0e.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4B85A6E5.009A:SCFMA4539814,ss=1,fgs=0
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
---
~Randy
