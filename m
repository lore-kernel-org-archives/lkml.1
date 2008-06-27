Return-Path: <linux-kernel-owner+w=401wt.eu-S932125AbYF0XEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbYF0XEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 19:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764578AbYF0W7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 18:59:07 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:22978 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764331AbYF0W66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 18:58:58 -0400
Message-Id: <20080627225800.517972351@ldl.fc.hp.com>
References: <20080627225651.663174474@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 16:57:02 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-acpi@vger.kernel.org, Rene Herman <rene.herman@gmail.com>
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [patch 11/28] PNP: whitespace/coding style fixes
Content-Disposition: inline; filename=pnp-interface-style
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change; just make a couple declarations
consistent with the rest of the file.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-by: Rene Herman <rene.herman@gmail.com>

Index: work10/drivers/pnp/interface.c
===================================================================
--- work10.orig/drivers/pnp/interface.c	2008-05-09 14:42:25.000000000 -0600
+++ work10/drivers/pnp/interface.c	2008-05-09 14:45:57.000000000 -0600
@@ -216,12 +216,12 @@ static ssize_t pnp_show_options(struct d
 				struct device_attribute *attr, char *buf)
 {
 	struct pnp_dev *dev = to_pnp_dev(dmdev);
+	pnp_info_buffer_t *buffer;
 	struct pnp_option *independent = dev->independent;
 	struct pnp_option *dependent = dev->dependent;
 	int ret, dep = 1;
 
-	pnp_info_buffer_t *buffer = (pnp_info_buffer_t *)
-	    pnp_alloc(sizeof(pnp_info_buffer_t));
+	buffer = pnp_alloc(sizeof(pnp_info_buffer_t));
 	if (!buffer)
 		return -ENOMEM;
 
@@ -248,17 +248,18 @@ static ssize_t pnp_show_current_resource
 					  char *buf)
 {
 	struct pnp_dev *dev = to_pnp_dev(dmdev);
+	pnp_info_buffer_t *buffer;
 	struct pnp_resource *pnp_res;
 	struct resource *res;
 	int ret;
-	pnp_info_buffer_t *buffer;
 
 	if (!dev)
 		return -EINVAL;
 
-	buffer = (pnp_info_buffer_t *) pnp_alloc(sizeof(pnp_info_buffer_t));
+	buffer = pnp_alloc(sizeof(pnp_info_buffer_t));
 	if (!buffer)
 		return -ENOMEM;
+
 	buffer->len = PAGE_SIZE;
 	buffer->buffer = buf;
 	buffer->curr = buffer->buffer;
@@ -295,9 +296,9 @@ static ssize_t pnp_show_current_resource
 	return ret;
 }
 
-static ssize_t
-pnp_set_current_resources(struct device *dmdev, struct device_attribute *attr,
-			  const char *ubuf, size_t count)
+static ssize_t pnp_set_current_resources(struct device *dmdev,
+					 struct device_attribute *attr,
+					 const char *ubuf, size_t count)
 {
 	struct pnp_dev *dev = to_pnp_dev(dmdev);
 	char *buf = (void *)ubuf;

-- 
