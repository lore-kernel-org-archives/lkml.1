Return-Path: <linux-kernel-owner+w=401wt.eu-S1755687AbYAQH2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687AbYAQH2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 02:28:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755178AbYAQH2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 02:28:21 -0500
Received: from mail00d.mail.t-online.hu ([84.2.42.5]:64956 "EHLO
	mail00d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704AbYAQH2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 02:28:21 -0500
Message-ID: <478F0308.3010207@freemail.hu>
Date: Thu, 17 Jan 2008 08:26:00 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Alexey Starikovskiy <astarikovskiy@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI: EC: "DEBUG" needs to be defined earlier
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The "DEBUG" symbol needs to be defined before #including <linux/kernel.h> to
get the pr_debug() working.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
--- linux-2.6.24-rc8/drivers/acpi/ec.c.orig	2008-01-16 07:25:33.000000000 +0100
+++ linux-2.6.24-rc8/drivers/acpi/ec.c	2008-01-16 19:41:24.000000000 +0100
@@ -26,6 +26,9 @@
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */

+/* Uncomment next line to get verbose print outs*/
+/* #define DEBUG */
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -47,9 +50,6 @@
 #undef PREFIX
 #define PREFIX				"ACPI: EC: "

-/* Uncomment next line to get verbose print outs*/
-/* #define DEBUG */
-
 /* EC status register */
 #define ACPI_EC_FLAG_OBF	0x01	/* Output buffer full */
 #define ACPI_EC_FLAG_IBF	0x02	/* Input buffer full */
