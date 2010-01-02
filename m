Return-Path: <linux-kernel-owner+w=401wt.eu-S1752459Ab0ABEgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab0ABEgw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 23:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399Ab0ABEgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 23:36:52 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:37123 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab0ABEgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 23:36:51 -0500
Date: Fri, 1 Jan 2010 20:35:41 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>,
       torvalds <torvalds@linux-foundation.org>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
Subject: [PATCH 2/4] Documentation: fix ioremap return type
Message-Id: <20100101203541.6ce233bc.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4B3ECD59.006F:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H Hartley Sweeten <hsweeten@visionengravers.com>
Subject: Documentation: fix ioremap return type

ioremap() returns a void __iomem * not a char *.  Update the documentation
file to reflect this.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/IO-mapping.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.33-rc2-git4.orig/Documentation/IO-mapping.txt
+++ linux-2.6.33-rc2-git4/Documentation/IO-mapping.txt
@@ -157,7 +157,7 @@ For such memory, you can do things like
 	 * access only the 640k-1MB area, so anything else
 	 * has to be remapped.
 	 */
-	char * baseptr = ioremap(0xFC000000, 1024*1024);
+	void __iomem *baseptr = ioremap(0xFC000000, 1024*1024);
 
 	/* write a 'A' to the offset 10 of the area */
 	writeb('A',baseptr+10);
