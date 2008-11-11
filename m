Return-Path: <linux-kernel-owner+w=401wt.eu-S1753384AbYKKXtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbYKKXtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 18:49:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbYKKXtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 18:49:43 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:64036 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbYKKXtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 18:49:42 -0500
Message-ID: <491A19E2.6090307@oracle.com>
Date: Tue, 11 Nov 2008 15:48:50 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: akpm <akpm@linux-foundation.org>, tony.luck@intel.com
Subject: [PATCH] DOC: add min_addr, fix max_addr
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010207.491A19E5.0055:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add "min_addr" documentation.
For "max_addr", add nn before [KMG] since a number is needed and this
is consistent with other uses of [KMG].

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/kernel-parameters.txt |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- lin2628-rc4.orig/Documentation/kernel-parameters.txt
+++ lin2628-rc4/Documentation/kernel-parameters.txt
@@ -1210,8 +1210,8 @@ and is between 256 and 4096 characters. 
 			it is equivalent to "nosmp", which also disables
 			the IO APIC.
 
-	max_addr=[KMG]	[KNL,BOOT,ia64] All physical memory greater than or
-			equal to this physical address is ignored.
+	max_addr=nn[KMG]	[KNL,BOOT,ia64] All physical memory greater than
+			or equal to this physical address is ignored.
 
 	max_luns=	[SCSI] Maximum number of LUNs to probe.
 			Should be between 1 and 2^32-1.
@@ -1311,6 +1311,9 @@ and is between 256 and 4096 characters. 
 
 	mga=		[HW,DRM]
 
+	min_addr=nn[KMG]	[KNL,BOOT,ia64] All physical memory below this
+			physical address is ignored.
+
 	mminit_loglevel=
 			[KNL] When CONFIG_DEBUG_MEMORY_INIT is set, this
 			parameter allows control of the logging verbosity for

