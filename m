Return-Path: <linux-kernel-owner+w=401wt.eu-S1758824AbYJ3ScX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824AbYJ3ScX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 14:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756108AbYJ3ScK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 14:32:10 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53374 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755401AbYJ3ScJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 14:32:09 -0400
Message-ID: <4909FDEF.2050803@sgi.com>
Date: Thu, 30 Oct 2008 11:33:19 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@elte.hu>
CC: Jack Steiner <steiner@sgi.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1]: SGI x86 UV: Fix compile error in uv_hub.h
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: SGI x86 UV: Fix compile error in uv_hub.h

Fix compile errors of files that include asm/uv/uv_hub.h but do
not include linux/timer.h.

Based on linux-next.

Signed-of-by: Mike Travis <travis@sgi.com>
---
 arch/x86/include/asm/uv/uv_hub.h |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6-next.orig/arch/x86/include/asm/uv/uv_hub.h
+++ linux-2.6-next/arch/x86/include/asm/uv/uv_hub.h
@@ -13,6 +13,7 @@
 
 #include <linux/numa.h>
 #include <linux/percpu.h>
+#include <linux/timer.h>
 #include <asm/types.h>
 #include <asm/percpu.h>
 
