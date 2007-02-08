Return-Path: <linux-kernel-owner+w=401wt.eu-S1161418AbXBHPqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161418AbXBHPqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 10:46:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161531AbXBHPqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 10:46:07 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161418AbXBHPqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 10:46:06 -0500
Date: Thu, 8 Feb 2007 10:46:03 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, ok@artecdesign.ee
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20070208154603.17387.16239.sendpatchset@prarit.boston.redhat.com>
Subject: [PATCH]: change __init to __devinit for isp116x_probe
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Change __init to __devinit for isp116x_probe.

Resolves MODPOST warning:

WARNING: drivers/usb/host/isp116x-hcd.o - Section mismatch: reference to
.init.text:isp116x_probe from .data.rel.local between 'isp116x_driver' (at
offset 0x0) and 'isp116x_hc_driver'

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

--- linux-2.6.19.ia64.orig/drivers/usb/host/isp116x-hcd.c	2007-02-07 09:56:37.000000000 -0500
+++ linux-2.6.19.ia64/drivers/usb/host/isp116x-hcd.c	2007-02-08 10:37:28.000000000 -0500
@@ -1577,7 +1577,7 @@ static int isp116x_remove(struct platfor
 
 #define resource_len(r) (((r)->end - (r)->start) + 1)
 
-static int __init isp116x_probe(struct platform_device *pdev)
+static int __devinit isp116x_probe(struct platform_device *pdev)
 {
 	struct usb_hcd *hcd;
 	struct isp116x *isp116x;
