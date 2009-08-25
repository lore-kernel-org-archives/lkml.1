Return-Path: <linux-kernel-owner+w=401wt.eu-S1754360AbZHYD5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbZHYD5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 23:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbZHYD5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 23:57:37 -0400
Received: from smtp.zeugmasystems.com ([70.79.96.174]:23083 "EHLO
	zeugmasystems.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754100AbZHYD5g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 23:57:36 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] : eliminate code duplication in kernel/tracepoint.c
Date: Mon, 24 Aug 2009 20:57:35 -0700
Message-ID: <DDFD17CC94A9BD49A82147DDF7D545C501EA902E@exchange.ZeugmaSystems.local>
In-Reply-To: <4A933C55.4090808@cn.fujitsu.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] : eliminate code duplication in kernel/tracepoint.c
Thread-Index: AcolIn/wF6rc6z8JRrKXTlL2AlYiOAAFXmvA
References: <DDFD17CC94A9BD49A82147DDF7D545C501EA8FBB@exchange.ZeugmaSystems.local> <4A933C55.4090808@cn.fujitsu.com>
From: "Anirban Sinha" <ASinha@zeugmasystems.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, <linux-kernel@vger.kernel.org>,
       "Oleg Nesterov" <oleg@tv-sign.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, here's the modified patch:

>From 52cea59801ac5b772c49ae995f4df1940a0d88fa Mon Sep 17 00:00:00 2001
From: Anirban Sinha <asinha@zeugmasystems.com>
Date: Mon, 24 Aug 2009 20:52:35 -0700
Subject: cleanup: eliminate code duplication in kernel/tracepoint.c


Signed-off-by: Anirban Sinha <asinha@zeugmasystems.com>
---
 kernel/tracepoint.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 1ef5d3a..35eed9c 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -554,13 +554,9 @@ int tracepoint_module_notify(struct notifier_block
*self,
 
 	switch (val) {
 	case MODULE_STATE_COMING:
-		tracepoint_update_probe_range(mod->tracepoints,
-			mod->tracepoints + mod->num_tracepoints);
-		break;
 	case MODULE_STATE_GOING:
 		tracepoint_update_probe_range(mod->tracepoints,
 			mod->tracepoints + mod->num_tracepoints);
-		break;
 	}
 	return 0;
 }
-- 
1.6.4

