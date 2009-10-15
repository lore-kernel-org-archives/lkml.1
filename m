Return-Path: <linux-kernel-owner+w=401wt.eu-S1760334AbZJOBrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760334AbZJOBrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 21:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755614AbZJOBrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 21:47:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:27811 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755528AbZJOBrh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 21:47:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,562,1249282800"; 
   d="scan'208";a="559688846"
From: "Zhang, Rui" <rui.zhang@intel.com>
To: Tim Hoppen <timhoppen@gmail.com>
CC: "lenb@kernel.org" <lenb@kernel.org>,
       "jgarzik@redhat.com" <jgarzik@redhat.com>,
       "tj@kernel.org" <tj@kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 15 Oct 2009 09:45:41 +0800
Subject: RE: [PATCH 1/1] Added an additional Sony laptop to
 acpi_osi_dmi_table
Thread-Topic: [PATCH 1/1] Added an additional Sony laptop to
 acpi_osi_dmi_table
Thread-Index: AcpNMncgY4Fz9RecTxig96ADn8gvyQABo+BA
Message-ID: <037F493892196B458CD3E193E8EBAD4F01EDB41A43@pdsmsx502.ccr.corp.intel.com>
References: <1255568391-8400-1-git-send-email-timhoppen@gmail.com>
In-Reply-To: <1255568391-8400-1-git-send-email-timhoppen@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any bug report for this issue?
If yes, can you add the link in the change log please?

Thanks,
Rui

-----Original Message-----
From: Tim Hoppen [mailto:timhoppen@gmail.com] 
Sent: Thursday, October 15, 2009 9:00 AM
Cc: lenb@kernel.org; Zhang, Rui; jgarzik@redhat.com; tj@kernel.org; linux-acpi@vger.kernel.org; linux-kernel@vger.kernel.org; Tim Hoppen
Subject: [PATCH 1/1] Added an additional Sony laptop to acpi_osi_dmi_table


Signed-off-by: Tim Hoppen <timhoppen@gmail.com>
---
 drivers/acpi/blacklist.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/blacklist.c b/drivers/acpi/blacklist.c
index e56b2a7..01cca5f 100644
--- a/drivers/acpi/blacklist.c
+++ b/drivers/acpi/blacklist.c
@@ -211,6 +211,14 @@ static struct dmi_system_id acpi_osi_dmi_table[] __initdata = {
 		     DMI_MATCH(DMI_PRODUCT_NAME, "Sony VGN-SR290J"),
 		},
 	},
+	{
+        .callback = dmi_disable_osi_vista,
+        .ident = "Sony VGN-FW351J",
+        .matches = {
+                     DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+                     DMI_MATCH(DMI_PRODUCT_NAME, "VGN-FW351J"),
+                },
+        },
 
 	/*
 	 * BIOS invocation of _OSI(Linux) is almost always a BIOS bug.
-- 
1.6.5

