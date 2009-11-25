Return-Path: <linux-kernel-owner+w=401wt.eu-S932529AbZKYRXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529AbZKYRXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:23:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759234AbZKYRGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:06:37 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:57397 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759271AbZKYRGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:06:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=mtZGW0ARIY+aEk/cc+LpKoU1MxUzcr+Qk0W7VU0LivSfYEBzXcbKRvD+hzzkynUrPb
         O+WxLgC7mudUwthVZS17Hv6YWvDwh2DMM0ZHPbuWaxlrAXnpQG6dpfklakNKrN17vg5M
         0FPB6/gh+G5U8QfgQodAjP9xZTksFQWlxth78=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:05:46 +0100
Message-Id: <20091125170546.5446.7389.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 29/86] pata_cypress: document known issues
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_cypress: document known issues

Document known issues with the driver to aid distribution makers,
users and developers in making informed decisions instead of wasting
their time needlessly.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

Index: b/drivers/ata/Kconfig
===================================================================
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -344,6 +344,9 @@ config PATA_CYPRESS
 	  This option enables support for the Cypress/Contaq CY82C693
 	  chipset found in some Alpha systems
 
+	  Known issues:
+	  - only the primary channel is currently supported
+
 	  If unsure, say N.
 
 config PATA_EFAR
