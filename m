Return-Path: <linux-kernel-owner+w=401wt.eu-S1756130AbYLaKyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbYLaKyP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 05:54:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755887AbYLaKwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 05:52:24 -0500
Received: from vms173007pub.verizon.net ([206.46.173.7]:41129 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460AbYLaKwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 05:52:12 -0500
Date: Wed, 31 Dec 2008 05:52:00 -0500
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 10/15] ACPICA: acopcode.h is private
In-reply-to: <1230720725-9376-1-git-send-email-lenb@kernel.org>
In-reply-to: <526647e1bb69fd3248558fce365bb1fbfb226ccd.1230719795.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>
Message-id: <1a88b5162920e1976816ece1b1a221f0edd15767.1230719805.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.1.28.gc32f76
References: <1230720725-9376-1-git-send-email-lenb@kernel.org>
References: <526647e1bb69fd3248558fce365bb1fbfb226ccd.1230719795.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Signed-off-by: Len Brown <len.brown@intel.com>
---
 {include/acpi => kernel/acpi/acpica}/acopcode.h |    0 
 kernel/acpi/acpica/psopcode.c                   |    2 +-
 2 files changed, 1 insertions(+), 1 deletions(-)
 rename {include/acpi => kernel/acpi/acpica}/acopcode.h (100%)

diff --git a/include/acpi/acopcode.h b/kernel/acpi/acpica/acopcode.h
similarity index 100%
rename from include/acpi/acopcode.h
rename to kernel/acpi/acpica/acopcode.h
diff --git a/kernel/acpi/acpica/psopcode.c b/kernel/acpi/acpica/psopcode.c
index b52e198..ccb9652 100644
--- a/kernel/acpi/acpica/psopcode.c
+++ b/kernel/acpi/acpica/psopcode.c
@@ -44,7 +44,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include <acpi/acparser.h>
-#include <acpi/acopcode.h>
+#include "acopcode.h"
 #include <acpi/amlcode.h>
 
 #define _COMPONENT          ACPI_PARSER
-- 
1.5.6.6

