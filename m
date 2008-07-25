Return-Path: <linux-kernel-owner+w=401wt.eu-S1753143AbYGYPaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbYGYPaZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 11:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbYGYPaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 11:30:10 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:61458 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbYGYPaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 11:30:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-transfer-encoding:x-mailer;
        b=ovVVsT46R1grYFuandh1OIlLmyKZ2x/gPISuuJ1FAzG9Ycy++dNtHJy2+ipOlOxeaZ
         rhU2YTD76/7FUXwZ62fc/dg6OFxC1AsbpSIkGXJBj3C8wlvs7ZZt+lrVKvARTQ8UjuB3
         +G609dxHRnWA3XAoUf6N5F3uZz5AkS+xUFCOU=
Date: Fri, 25 Jul 2008 23:30:05 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: mm/sparse.c: Removed duplicated include
Message-Id: <20080725210703.912E.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.24.02 [en]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed duplicated include file "internal.h" in 
mm/sparse.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

diff --git a/mm/sparse.c b/mm/sparse.c
index 8ffc089..8e07810 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -12,7 +12,6 @@
 #include <asm/dma.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
-#include "internal.h"

 /*
  * Permanent SPARSEMEM data:


