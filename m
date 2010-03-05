Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab0CER4K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 12:56:10 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:28748 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab0CER4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 12:56:08 -0500
Date: Fri, 5 Mar 2010 09:52:52 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org, torvalds <torvalds@linux-foundation.org>
Subject: [PATCH reresend] x86: fix mtrr missing kernel-doc
Message-Id: <20100305095252.c4f9af5c.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4B914568.00CD:SCFMA4539814,ss=1,fgs=0
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

Q: Should I merge this or the do x86 maintainers want to do it?

--- lnx-2633-rc8.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ lnx-2633-rc8/arch/x86/kernel/cpu/mtrr/main.c
@@ -145,6 +145,7 @@ struct set_mtrr_data {
 
 /**
  * ipi_handler - Synchronisation handler. Executed by "other" CPUs.
+ * @info: pointer to mtrr configuration data
  *
  * Returns nothing.
  */
