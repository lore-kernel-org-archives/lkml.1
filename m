Return-Path: <linux-kernel-owner+w=401wt.eu-S937342AbXG0VQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937342AbXG0VQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 17:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763906AbXG0VQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 17:16:11 -0400
Received: from 91-65-233-90-dynip.superkabel.de ([91.65.233.90]:57938 "EHLO
	charon.n2.diac24.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1761096AbXG0VQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 17:16:10 -0400
X-Greylist: delayed 1403 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jul 2007 17:16:10 EDT
Date: Fri, 27 Jul 2007 22:52:43 +0200
From: David Lamparter <lists@diac24.net>
To: Lionel Bouton <Lionel.Bouton@inet6.fr>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ide: sis5513.c: Add FSC Amilo A1630 PCI subvendor/dev to
	laptops
Message-ID: <20070727205242.GA1216@charon.n2.diac24.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] ide: sis5513.c: Add FSC Amilo A1630 PCI subvendor/dev to laptops

Recognise the FSC Amilo A1630's incarnation of a SiS5513 chip as laptop to
get UDMA100 support.

Signed-off-by: David Lamparter <equinox@diac24.net>
---
 drivers/ide/pci/sis5513.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/ide/pci/sis5513.c b/drivers/ide/pci/sis5513.c
index 63fbb79..26f2480 100644
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -801,6 +801,7 @@ struct sis_laptop {
 static const struct sis_laptop sis_laptop[] = {
 	/* devid, subvendor, subdev */
 	{ 0x5513, 0x1043, 0x1107 },	/* ASUS A6K */
+	{ 0x5513, 0x1734, 0x105f },	/* FSC Amilo A1630 */
 	/* end marker */
 	{ 0, }
 };
-- 
1.5.2.1

