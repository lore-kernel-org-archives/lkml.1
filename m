Return-Path: <linux-kernel-owner+w=401wt.eu-S1759891AbZGHQH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759891AbZGHQH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759140AbZGHQFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:05:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:53251 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759196AbZGHQFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:05:40 -0400
Subject: [PATCH 35/44] includecheck fix: include/acpi, acpi_bus.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: lenb@kernel.org, linux-acpi@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 21:17:38 +0530
Message-Id: <1247068058.4382.96.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  include/acpi/acpi_bus.h: linux/device.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 include/acpi/acpi_bus.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index c65e4ce..2d8f6ef 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -356,7 +356,6 @@ void acpi_remove_dir(struct acpi_device *);
 /*
  * Bind physical devices with ACPI devices
  */
-#include <linux/device.h>
 struct acpi_bus_type {
 	struct list_head list;
 	struct bus_type *bus;
-- 
1.6.0.6



