Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbYKEKrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbYKEKrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 05:47:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315AbYKEKqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 05:46:55 -0500
Received: from mga03.intel.com ([143.182.124.21]:20250 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbYKEKqy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 05:46:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,550,1220252400"; 
   d="scan'208";a="71368294"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH]1/3 intel_menlow:Adding comment for GTHS legal values
Date: Wed, 5 Nov 2008 16:15:13 +0530
Message-ID: <7D0189F5BE1DF549A570B212D1D5612182AF02@bgsmsx412.gar.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH]1/3 intel_menlow:Adding comment for GTHS legal values
Thread-Index: Ack/M5T0rMgyJgTPQmWdX8AutIXceA==
From: "Thomas, Sujith" <sujith.thomas@intel.com>
To: "Len Brown" <lenb@kernel.org>, "Zhang, Rui" <rui.zhang@intel.com>,
       "Thomas, Sujith" <sujith.thomas@intel.com>
Cc: "Brown, Len" <len.brown@intel.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       <linux-acpi@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
X-OriginalArrivalTime: 05 Nov 2008 10:45:19.0288 (UTC) FILETIME=[9899FB80:01C93F33]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation of legal values for GTHS
To be patched over Rui's 09/11 bug fix patch

Signed-off-by: Sujith Thomas <sujith.thomas@intel.com>
---
 drivers/misc/intel_menlow.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6.27/drivers/misc/intel_menlow.c
===================================================================
--- linux-2.6.27.orig/drivers/misc/intel_menlow.c
+++ linux-2.6.27/drivers/misc/intel_menlow.c
@@ -52,6 +52,11 @@ MODULE_LICENSE("GPL");
 #define MEMORY_ARG_CUR_BANDWIDTH 1
 #define MEMORY_ARG_MAX_BANDWIDTH 0
 
+/*
+ * GTHS returning 'n' would mean that [0,n-1] states are supported
+ * In that case max_cstate would be n-1
+ * GTHS returning '0' would mean that no bandwidth control states are
supported
+ */
 static int memory_get_int_max_bandwidth(struct thermal_cooling_device
*cdev,
 					unsigned long *max_state)
 {
