Return-Path: <linux-kernel-owner+w=401wt.eu-S1753476AbZDWATU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbZDWATU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 20:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbZDWATK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 20:19:10 -0400
Received: from exprod6og101.obsmtp.com ([64.18.1.181]:42541 "HELO
	exprod6og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751905AbZDWATJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 20:19:09 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] net/sunrpc/svc_xprt.c: fix sparse warnings
Date: Wed, 22 Apr 2009 20:18:19 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090165F128@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] net/sunrpc/svc_xprt.c: fix sparse warnings
Thread-Index: AcnDqQF9FhnPvsT/TXm2xwr63E+TiA==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 23 Apr 2009 00:19:05.0449 (UTC) FILETIME=[1CA8E590:01C9C3A9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following sparse warnings in net/sunrpc/svc_xprt.c.

  warning: symbol 'svc_recv' was not declared. Should it be static?
  warning: symbol 'svc_drop' was not declared. Should it be static?
  warning: symbol 'svc_send' was not declared. Should it be static?
  warning: symbol 'svc_close_all' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index c200d92..f200393 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -11,6 +11,7 @@
 #include <net/sock.h>
 #include <linux/sunrpc/stats.h>
 #include <linux/sunrpc/svc_xprt.h>
+#include <linux/sunrpc/svcsock.h>
 
 #define RPCDBG_FACILITY	RPCDBG_SVCXPRT
  
