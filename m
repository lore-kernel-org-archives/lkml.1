Return-Path: <linux-kernel-owner+w=401wt.eu-S1753408AbYJ1Hk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbYJ1Hk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 03:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbYJ1HkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 03:40:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:46097 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbYJ1HkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 03:40:13 -0400
Message-ID: <4906C1A0.1090701@kernel.org>
Date: Tue, 28 Oct 2008 00:39:12 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ACPI Devel Maling List" <linux-acpi@vger.kernel.org>
Subject: [PATCH] acpi: use macro to replace hard number
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup

use MACRO for rev 3 fadt id instead of 3 directly

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/acpi/tables/tbfadt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/acpi/tables/tbfadt.c
===================================================================
--- linux-2.6.orig/drivers/acpi/tables/tbfadt.c
+++ linux-2.6/drivers/acpi/tables/tbfadt.c
@@ -304,7 +304,7 @@ static void acpi_tb_convert_fadt(void)
 	 * The ACPI 1.0 reserved fields that will be zeroed are the bytes located at
 	 * offset 45, 55, 95, and the word located at offset 109, 110.
 	 */
-	if (acpi_gbl_FADT.header.revision < 3) {
+	if (acpi_gbl_FADT.header.revision < FADT2_REVISION_ID) {
 		acpi_gbl_FADT.preferred_profile = 0;
 		acpi_gbl_FADT.pstate_control = 0;
 		acpi_gbl_FADT.cst_control = 0;
