Return-Path: <linux-kernel-owner+w=401wt.eu-S938704AbXGUPCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938704AbXGUPCz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761259AbXGUPCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:02:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:37344 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939040AbXGUPCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:02:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=G83zaOna8eH0dji6UToro4SaZ8oX7Vo3XfsrvKqvID8U1vwh2/Hc+3NlH3xSVVQr8jpsDHcIIGpwx9pQuiEU38iV6ecXw43k7Cr/5YZsuwnlV5cA6Io8iTO68D2dso7VGEvFToE7lz31eTp77gV1+6fIK7lj3qpxkCbJLeVidoQ=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][01/37] Clean up duplicate includes in Documentation/
Date: Sat, 21 Jul 2007 17:01:37 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Shailabh Nagar <nagar@watson.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Jay Lan <jlan@engr.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707211701.37966.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch cleans up duplicate includes in
	Documentation/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
index 24c5aad..0ccfeae 100644
--- a/Documentation/accounting/getdelays.c
+++ b/Documentation/accounting/getdelays.c
@@ -21,7 +21,6 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/socket.h>
-#include <sys/types.h>
 #include <signal.h>
 
 #include <linux/genetlink.h>
