Return-Path: <linux-kernel-owner+w=401wt.eu-S1161177AbXCAXQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161177AbXCAXQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 18:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161249AbXCAXQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 18:16:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:45485 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161177AbXCAXQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 18:16:42 -0500
Date: Fri, 2 Mar 2007 00:16:40 +0100
From: Bernhard Walle <bwalle@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix ACPI documentation in kernel-parameters.txt
Message-ID: <20070301231640.GD21440@strauss.suse.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add hint that acpi=off doesn't work on IA64.

Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 Documentation/kernel-parameters.txt |    1 +
 1 file changed, 1 insertion(+)

Index: b/Documentation/kernel-parameters.txt
===================================================================
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -135,6 +135,7 @@ and is between 256 and 4096 characters. 
 				strictly ACPI specification compliant.
 
 			See also Documentation/pm.txt, pci=noacpi
+			On IA64, ACPI cannot be deactivated.
 
 	acpi_sleep=	[HW,ACPI] Sleep options
 			Format: { s3_bios, s3_mode }
