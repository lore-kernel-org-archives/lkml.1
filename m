Return-Path: <linux-kernel-owner+w=401wt.eu-S1757451AbXICIV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451AbXICIV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 04:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758098AbXICIUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 04:20:42 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:35744 "EHLO
	outbound5-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758054AbXICIUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 04:20:41 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Message-ID: <20070903081736.497614000@amd.com>
References: <20070903081736.288288000@amd.com>
User-Agent: quilt/0.46-1
Date: Mon, 03 Sep 2007 10:17:38 +0200
From: "Robert Richter" <robert.richter@amd.com>
To: "Andi Kleen" <ak@suse.de>
cc: patches@x86-64.org, linux-kernel@vger.kernel.org,
       "Robert Richter" <robert.richter@amd.com>
Subject: [patch 2/5] x86: Add AMD64 Barcelona NB cfg MSR definitions
X-OriginalArrivalTime: 03 Sep 2007 08:18:31.0621 (UTC)
 FILETIME=[039BE750:01C7EE03]
MIME-Version: 1.0
X-WSS-ID: 6AC51C181A46452963-01-01
Content-Disposition: inline;
 filename=i386-add-amd64-barcelona-nb-cfg-msr-definitions.patch
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds MSR definitions for the northbridge configuration
register for AMD's Barcelona CPUs.

Signed-off-by: Robert Richter <robert.richter@amd.com>

---
 include/asm-i386/msr-index.h |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/include/asm-i386/msr-index.h
===================================================================
--- linux-2.6.orig/include/asm-i386/msr-index.h
+++ linux-2.6/include/asm-i386/msr-index.h
@@ -76,6 +76,7 @@
 /* AMD64 MSRs. Not complete. See the architecture manual for a more
    complete list. */
 
+#define MSR_AMD64_NB_CFG		0xc001001f
 #define MSR_AMD64_IBSFETCHCTL		0xc0011030
 #define MSR_AMD64_IBSFETCHLINAD		0xc0011031
 #define MSR_AMD64_IBSFETCHPHYSAD	0xc0011032

-- 
AMD Saxony, Dresden, Germany
Operating System Research Center
email: robert.richter@amd.com



