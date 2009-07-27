Return-Path: <linux-kernel-owner+w=401wt.eu-S1752558AbZG0Oi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbZG0Oi5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 10:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbZG0Oi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 10:38:57 -0400
Received: from relay1.sgi.com ([192.48.179.29]:53410 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752345AbZG0Oi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 10:38:56 -0400
Date: Mon, 27 Jul 2009 09:38:56 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: Subject: [PATCH] x86, UV: UV apic mode fix
Message-ID: <20090727143856.GA8905@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change SGI UV default apicid mode to "physical".  This is
required to match settings in the UV hub chip.


Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 arch/x86/kernel/apic/x2apic_uv_x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2009-06-22 08:36:27.000000000 -0500
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2009-06-22 08:38:59.000000000 -0500
@@ -261,7 +261,7 @@ struct apic apic_x2apic_uv_x = {
 	.apic_id_registered		= uv_apic_id_registered,
 
 	.irq_delivery_mode		= dest_Fixed,
-	.irq_dest_mode			= 1, /* logical */
+	.irq_dest_mode			= 0, /* physical */
 
 	.target_cpus			= uv_target_cpus,
 	.disable_esr			= 0,
