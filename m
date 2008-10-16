Return-Path: <linux-kernel-owner+w=401wt.eu-S1757332AbYJPTXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332AbYJPTXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 15:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbYJPTXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 15:23:33 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:50791 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbYJPTXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 15:23:32 -0400
Date: Fri, 17 Oct 2008 00:53:20 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       benh@kernel.crashing.org, jwboyer@linux.vnet.ibm.com, apw@shadowen.org
Subject: [PATCH] linux-next: Tree for October 16 - build failure at MAL
	support on powerpc
Message-ID: <20081016192320.GA7534@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20081016211811.a523c8f2.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081016211811.a523c8f2.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

        next-20081016 kernel build fails on powerpc, with build error

drivers/net/ibm_newemac/mal.c: In function 'mal_txeob':
drivers/net/ibm_newemac/mal.c:284: error: implicit declaration of function 'mtdcri'
drivers/net/ibm_newemac/mal.c:284: error: 'SDR0' undeclared (first use in this function)
drivers/net/ibm_newemac/mal.c:284: error: (Each undeclared identifier is reported only once
drivers/net/ibm_newemac/mal.c:284: error: for each function it appears in.)
drivers/net/ibm_newemac/mal.c:285: error: implicit declaration of function 'mfdcri'
drivers/net/ibm_newemac/mal.c: In function 'mal_rxeob':
drivers/net/ibm_newemac/mal.c:302: error: 'SDR0' undeclared (first use in this function)
make[3]: *** [drivers/net/ibm_newemac/mal.o] Error 1

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---
 drivers/net/ibm_newemac/mal.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ibm_newemac/mal.c b/drivers/net/ibm_newemac/mal.c
index 1839d3f..c5f91a6 100644
--- a/drivers/net/ibm_newemac/mal.c
+++ b/drivers/net/ibm_newemac/mal.c
@@ -29,6 +29,7 @@
 
 #include "core.h"
 #include <asm/dcr-regs.h>
+#include <asm/dcr-native.h>
 
 static int mal_count;
 
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
