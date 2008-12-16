Return-Path: <linux-kernel-owner+w=401wt.eu-S1756587AbYLPLcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbYLPLcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 06:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbYLPLbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 06:31:48 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:38931 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbYLPLbr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 06:31:47 -0500
Message-Id: <49479FC6.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 16 Dec 2008 11:32:06 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH] mark late_time_init as __initdata
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.28-rc8/init/main.c	2008-12-11 14:37:26.000000000 +0100
+++ 2.6.28-rc8-late-time-init/init/main.c	2008-12-15 11:35:43.000000000 +0100
@@ -116,7 +116,7 @@ EXPORT_SYMBOL(system_state);
 
 extern void time_init(void);
 /* Default late time init is NULL. archs can override this later. */
-void (*late_time_init)(void);
+void (*__initdata late_time_init)(void);
 extern void softirq_init(void);
 
 /* Untouched command line saved by arch-specific code. */



