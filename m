Return-Path: <linux-kernel-owner+w=401wt.eu-S1761538AbZJIXNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761538AbZJIXNM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761162AbZJIXNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:13:11 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:43927 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761027AbZJIXNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:13:10 -0400
Date: Fri, 9 Oct 2009 16:10:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       lenb@kernel.org
Subject: [PATCH -mmotm] cmpc_acpi: depends on ACPI
Message-Id: <20091009161036.7f752529.randy.dunlap@oracle.com>
In-Reply-To: <200910090830.n998Ubvv020464@imap1.linux-foundation.org>
References: <200910090830.n998Ubvv020464@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4ACFC316.0133:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix about 100 build errors/warnings when ACPI is not enabled.  E.g.:

drivers/platform/x86/cmpc_acpi.c:50: error: dereferencing pointer to incomplete type
drivers/platform/x86/cmpc_acpi.c:55: error: dereferencing pointer to incomplete type
drivers/platform/x86/cmpc_acpi.c:56: error: dereferencing pointer to incomplete type
drivers/platform/x86/cmpc_acpi.c:72: warning: 'struct acpi_device' declared inside parameter list
drivers/platform/x86/cmpc_acpi.c:77: error: dereferencing pointer to incomplete type
drivers/platform/x86/cmpc_acpi.c:79: error: dereferencing pointer to incomplete type

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/platform/x86/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- mmotm-2009-1009-0107.orig/drivers/platform/x86/Kconfig
+++ mmotm-2009-1009-0107/drivers/platform/x86/Kconfig
@@ -438,7 +438,7 @@ config ACPI_TOSHIBA
 
 config ACPI_CMPC
 	tristate "CMPC Laptop Extras"
-	depends on X86
+	depends on X86 && ACPI
 	select INPUT
 	select BACKLIGHT_CLASS_DEVICE
 	default n
