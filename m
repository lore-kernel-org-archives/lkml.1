Return-Path: <linux-kernel-owner+w=401wt.eu-S1756580AbYHGWZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbYHGWZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 18:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752912AbYHGWZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 18:25:08 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:19962 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbYHGWZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 18:25:07 -0400
Date: Thu, 7 Aug 2008 15:14:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org, akpm <akpm@linux-foundation.org>, muli@il.ibm.com,
       jdmason@kudzu.us
Subject: [PATCH] pci-calgary: fix function declaration
Message-Id: <20080807151455.12b53aa5.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
cc: muli@il.ibm.com, jdmason@kudzu.us

Fix function declaration:

linux-next-20080807/arch/x86/kernel/pci-calgary_64.c:1353:36: warning: non-ANSI function declaration of function 'get_tce_space_from_tar'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/kernel/pci-calgary_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20080807.orig/arch/x86/kernel/pci-calgary_64.c
+++ linux-next-20080807/arch/x86/kernel/pci-calgary_64.c
@@ -1350,7 +1350,7 @@ static void calgary_init_bitmap_from_tce
  * Function for kdump case. Get the tce tables from first kernel
  * by reading the contents of the base adress register of calgary iommu
  */
-static void get_tce_space_from_tar()
+static void get_tce_space_from_tar(void)
 {
 	int bus;
 	void __iomem *target;


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
