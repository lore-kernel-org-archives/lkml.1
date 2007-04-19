Return-Path: <linux-kernel-owner+w=401wt.eu-S1766769AbXDSPDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766769AbXDSPDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 11:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766784AbXDSPDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 11:03:31 -0400
Received: from mail10.syd.optusnet.com.au ([211.29.132.191]:51791 "EHLO
	mail10.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766769AbXDSPDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 11:03:31 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
Subject: [PATCH] [2/3] sched: implement staircase deadline scheduler docupdate
Date: Fri, 20 Apr 2007 01:02:51 +1000
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704200102.52036.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Update documentation to reflect higher maximum rr_interval.

Signed-off-by: Con Kolivas <kernel@kolivas.org>

---
 Documentation/sysctl/kernel.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.21-rc7-sd/Documentation/sysctl/kernel.txt
===================================================================
--- linux-2.6.21-rc7-sd.orig/Documentation/sysctl/kernel.txt	2007-04-20 00:29:12.000000000 +1000
+++ linux-2.6.21-rc7-sd/Documentation/sysctl/kernel.txt	2007-04-20 00:29:32.000000000 +1000
@@ -298,7 +298,7 @@ overall. This value is in milliseconds a
 depends on the number of cpus available at scheduler initialisation
 with a minimum of 8.
 
-Valid values are from 1-100.
+Valid values are from 1-5000.
 
 ==============================================================
 

-- 
-ck
