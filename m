Return-Path: <linux-kernel-owner+w=401wt.eu-S1753877AbXC0OWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbXC0OWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 10:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbXC0OWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 10:22:10 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:39897 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbXC0OWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 10:22:08 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
Organization: IBM Corporation
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ibmebus: newline fix
Date: Tue, 27 Mar 2007 15:18:55 +0100
User-Agent: KMail/1.6.2
Cc: pmac@au1.ibm.com, hnguyen@de.ibm.com, johnrose@austin.ibm.com,
       johnrose@us.ibm.com, nfont@austin.ibm.com, paulus@samba.org,
       themann@de.ibm.com
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200703271618.55616.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stupid me forgot a newline in an error message.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---


Applies on top of
"ibmebus: change probe/remove interface from using loc-code to DT path"


 ibmebus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff -Nurp 03b.path/arch/powerpc/kernel/ibmebus.c 03c.path/arch/powerpc/kernel/ibmebus.c
--- 03b.path/arch/powerpc/kernel/ibmebus.c	2007-03-21 15:23:23.000000000 +0100
+++ 03c.path/arch/powerpc/kernel/ibmebus.c	2007-03-27 15:30:44.341143552 +0200
@@ -421,7 +421,7 @@ static ssize_t ibmebus_store_probe(struc
 		of_node_put(dn);
 		rc = IS_ERR(dev) ? PTR_ERR(dev) : count;
 	} else {
-		printk(KERN_WARNING "%s: no such device node: %s",
+		printk(KERN_WARNING "%s: no such device node: %s\n",
 		       __FUNCTION__, path);
 		rc = -ENODEV;
 	}

