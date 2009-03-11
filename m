Return-Path: <linux-kernel-owner+w=401wt.eu-S1753842AbZCKAqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbZCKAqw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 20:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753747AbZCKAqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 20:46:31 -0400
Received: from www.tglx.de ([62.245.132.106]:40002 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754260AbZCKAqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 20:46:30 -0400
Message-Id: <20090311003235.403132610@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 11 Mar 2009 00:45:24 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 01/18] genirq: prepare removal of obsolete defines and typedefs
References: <20090311003204.592133594@linutronix.de>
Content-Disposition: inline;
	filename=genirq-prepare-removal-of-obsolete-defines-and-typedefs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 Documentation/feature-removal-schedule.txt |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-2.6/Documentation/feature-removal-schedule.txt
===================================================================
--- linux-2.6.orig/Documentation/feature-removal-schedule.txt
+++ linux-2.6/Documentation/feature-removal-schedule.txt
@@ -344,3 +344,12 @@ Why:	See commits 129f8ae9b1b5be94517da76
 	Removal is subject to fixing any remaining bugs in ACPI which may
 	cause the thermal throttling not to happen at the right time.
 Who:	Dave Jones <davej@redhat.com>, Matthew Garrett <mjg@redhat.com>
+
+---------------------------
+
+What:	obsolete generic irq defines and typedefs
+When:	2.6.30
+Why:	The defines and typedefs (hw_interrupt_type, no_irq_type, irq_desc_t)
+	have been kept around for migration reasons. After more than two years
+	it's time to remove them finally
+Who:	Thomas Gleixner <tglx@linutronix.de>


