Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828Ab0AHSMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab0AHSMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 13:12:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123Ab0AHSMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 13:12:47 -0500
Received: from [206.15.93.42] ([206.15.93.42]:26885 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752026Ab0AHSMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 13:12:46 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH] drivers/acpi: Remove unnecessary cast
Date: Fri, 8 Jan 2010 11:12:41 -0700
Cc: rui.zhang@intel.com, lenb@kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001081112.41469.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/acpi: Remove unnecessary cast.

The struct seq_file 'private' member is a void *, the cast is not needed.
Also, remove an extra whitespace line.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>

---

diff --git a/drivers/acpi/processor_thermal.c b/drivers/acpi/processor_thermal.c
index 140c5c5..6deafb4 100644
--- a/drivers/acpi/processor_thermal.c
+++ b/drivers/acpi/processor_thermal.c
@@ -443,8 +443,7 @@ struct thermal_cooling_device_ops processor_cooling_ops = {
 #ifdef CONFIG_ACPI_PROCFS
 static int acpi_processor_limit_seq_show(struct seq_file *seq, void *offset)
 {
-	struct acpi_processor *pr = (struct acpi_processor *)seq->private;
-
+	struct acpi_processor *pr = seq->private;
 
 	if (!pr)
 		goto end;
