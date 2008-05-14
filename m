Return-Path: <linux-kernel-owner+w=401wt.eu-S1762553AbYENPPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762553AbYENPPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759578AbYENPPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:15:19 -0400
Received: from relay2.sgi.com ([192.48.171.30]:41174 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759404AbYENPPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:15:18 -0400
From: Paul Jackson <pj@sgi.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Jack Steiner" <steiner@sgi.com>,
       "Mike Travis" <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
       "Andi Kleen" <andi@firstfloor.org>, "Ingo Molnar" <mingo@elte.hu>,
       Paul Jackson <pj@sgi.com>
Date: Wed, 14 May 2008 08:15:16 -0700
Message-Id: <20080514151516.148486.56588.sendpatchset@jackhammer.engr.sgi.com>
In-Reply-To: <20080514151504.148486.32236.sendpatchset@jackhammer.engr.sgi.com>
References: <20080514151504.148486.32236.sendpatchset@jackhammer.engr.sgi.com>
Subject: [PATCH 3/10] x86 boot: add header comment to dmi.h stating what it is
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

The "dmi.h" file did not state anywhere in the file what "DMI" was.
For those who know, it's obvious.  For the rest of us, I added a
brief opening comment.

Signed-off-by: Paul Jackson <pj@sgi.com>

---
 drivers/firmware/dmi_scan.c |    5 +++++
 1 file changed, 5 insertions(+)

--- linux.orig/drivers/firmware/dmi_scan.c	2008-04-16 19:49:44.000000000 -0700
+++ linux/drivers/firmware/dmi_scan.c	2008-05-05 03:41:45.921911888 -0700
@@ -8,6 +8,11 @@
 #include <linux/slab.h>
 #include <asm/dmi.h>
 
+/*
+ * DMI stands for "Desktop Management Interface".  It is part
+ * of and an antecedent to, SMBIOS, which stands for System
+ * Management BIOS.  See further: http://www.dmtf.org/standards
+ */
 static char dmi_empty_string[] = "        ";
 
 static const char * __init dmi_string_nosave(const struct dmi_header *dm, u8 s)

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
