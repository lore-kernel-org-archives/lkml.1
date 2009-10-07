Return-Path: <linux-kernel-owner+w=401wt.eu-S1759636AbZJGRXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636AbZJGRXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 13:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759613AbZJGRXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 13:23:07 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:48849 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702AbZJGRXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 13:23:06 -0400
Date: Wed, 7 Oct 2009 10:21:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, drbd-dev@lists.linbit.com
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       jens.axboe@oracle.com
Subject: [PATCH -next] drbd: needs __ratelimit()
Message-Id: <20091007102153.1a19119b.randy.dunlap@oracle.com>
In-Reply-To: <20091007173517.abfcfa2a.sfr@canb.auug.org.au>
References: <20091007173517.abfcfa2a.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4ACCCE4A.0005:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

drbd_int.h uses __ratelimit(), so it needs to #include ratelimit.h:

drivers/block/drbd/drbd_int.h:1765: error: implicit declaration of function '__ratelimit'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: drbd-dev@lists.linbit.com
---
 drivers/block/drbd/drbd_int.h |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20091007.orig/drivers/block/drbd/drbd_int.h
+++ linux-next-20091007/drivers/block/drbd/drbd_int.h
@@ -34,6 +34,7 @@
 #include <linux/bitops.h>
 #include <linux/slab.h>
 #include <linux/crypto.h>
+#include <linux/ratelimit.h>
 #include <linux/tcp.h>
 #include <linux/mutex.h>
 #include <linux/major.h>
