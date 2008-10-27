Return-Path: <linux-kernel-owner+w=401wt.eu-S1754352AbYJ0Vig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352AbYJ0Vig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 17:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbYJ0ViI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 17:38:08 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:42604 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751828AbYJ0ViG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 17:38:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ALnlXegcf83hM6IFFPCktHeLcqnIRm5jLqFRd8md3pdtIHugFNtS6eOxlAasL4Sy1ZP0Tj18UPA9flkCVnKTbhUQURaY85NzAhUGiCxYR0QjE7QYsUukrvgfqoDkVW8rYfzHpoEyJZegB9qDUTuWKFShMGRXtssn3yfAy6Df/Wk=  ;
X-YMail-OSG: jl8lZHsVM1lj6KYjqFMn3WwxjNYWD4nziTFCUC5sYWpWQD6WR8kDI0YKG1s9D4q04_Qa.IqCTlboJAvjCnEO4jx6CIbpwpaZKMXUft7E.Rki_CGlyvNXouuWRfKqm3KMpcP42T.EXaeNsu3dNzc9qbRI
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: linux-acpi@vger.kernel.org
Subject: [patch/RESEND 2.6.28-rc2 1/2] ACPI:  fix ACPI_FADT_S4_RTC_WAKE comment
Date: Mon, 27 Oct 2008 13:57:23 -0700
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810271357.23861.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Make the comment for ACPI_FADT_S4_RTC_WAKE match the ACPI spec;
that bit has nothing to do with status bits.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 include/acpi/actbl.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/acpi/actbl.h	2008-08-19 20:25:36.000000000 -0700
+++ b/include/acpi/actbl.h	2008-08-19 20:26:14.000000000 -0700
@@ -245,7 +245,7 @@ struct acpi_table_fadt {
 #define ACPI_FADT_POWER_BUTTON      (1<<4)	/* 04: Power button is handled as a generic feature */
 #define ACPI_FADT_SLEEP_BUTTON      (1<<5)	/* 05: Sleep button is handled as a generic feature, or  not present */
 #define ACPI_FADT_FIXED_RTC         (1<<6)	/* 06: RTC wakeup stat not in fixed register space */
-#define ACPI_FADT_S4_RTC_WAKE       (1<<7)	/* 07: RTC wakeup stat not possible from S4 */
+#define ACPI_FADT_S4_RTC_WAKE       (1<<7)	/* 07: RTC wakeup possible from S4 */
 #define ACPI_FADT_32BIT_TIMER       (1<<8)	/* 08: tmr_val is 32 bits 0=24-bits */
 #define ACPI_FADT_DOCKING_SUPPORTED (1<<9)	/* 09: Docking supported */
 #define ACPI_FADT_RESET_REGISTER    (1<<10)	/* 10: System reset via the FADT RESET_REG supported */
