Return-Path: <linux-kernel-owner+w=401wt.eu-S2992663AbXCBRa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992663AbXCBRa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 12:30:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992664AbXCBRa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 12:30:56 -0500
Received: from mail.suse.de ([195.135.220.2]:57563 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992663AbXCBRaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 12:30:55 -0500
Date: Fri, 2 Mar 2007 18:30:54 +0100
From: Bernhard Walle <bwalle@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix ACPI documentation in kernel-parameters.txt
Message-ID: <20070302173054.GB9157@strauss.suse.de>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add hint that acpi=off doesn't work on IA64.

Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 Documentation/kernel-parameters.txt |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.21-rc2-mm1/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.21-rc2-mm1.orig/Documentation/kernel-parameters.txt
+++ linux-2.6.21-rc2-mm1/Documentation/kernel-parameters.txt
@@ -126,7 +126,8 @@ and is between 256 and 4096 characters. 
 			See header of drivers/scsi/53c7xx.c.
 			See also Documentation/scsi/ncr53c7xx.txt.
 
-	acpi=		[HW,ACPI] Advanced Configuration and Power Interface
+	acpi=		[HW,ACPI,X86-64,i386]
+			Advanced Configuration and Power Interface
 			Format: { force | off | ht | strict | noirq }
 			force -- enable ACPI if default was off
 			off -- disable ACPI if default was on
