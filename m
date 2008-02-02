Return-Path: <linux-kernel-owner+w=401wt.eu-S933242AbYBBJv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933242AbYBBJv7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 04:51:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762705AbYBBJvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 04:51:39 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:43498 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761878AbYBBJvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 04:51:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ELm/b7PrIJYQGrkDfAXcq5Hk0DUB+6JFz7l/erd/EIG+hPhUIdTd2SlIFsgPDDbJgmQFsTarHmpTdlwbYLPyEP8fgd8Tltf2p0zztPNL2WQWxvEUHcpVDsfT7/Icm06r5QUgj+c9uFWwdX0sQHOXEjAcUHGyYhfdzNZdS5csHSw=
From: Denis Cheng <crquan@gmail.com>
To: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, cr_quan@163.com
Subject: [PATCH 2/3] uio: mark pci_device_id hilscher_pci_ids[] __devinitdata
Date: Sat,  2 Feb 2008 17:51:36 +0800
Message-Id: <1201945897-32297-2-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1201945897-32297-1-git-send-email-crquan@gmail.com>
References: <
 <1201945897-32297-1-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 drivers/uio/uio_cif.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/uio/uio_cif.c b/drivers/uio/uio_cif.c
index 838bae4..4a5a97e 100644
--- a/drivers/uio/uio_cif.c
+++ b/drivers/uio/uio_cif.c
@@ -116,7 +116,7 @@ static void hilscher_pci_remove(struct pci_dev *dev)
 	kfree (info);
 }
 
-static struct pci_device_id hilscher_pci_ids[] = {
+static struct pci_device_id hilscher_pci_ids[] __devinitdata = {
 	{
 		.vendor =	PCI_VENDOR_ID_PLX,
 		.device =	PCI_DEVICE_ID_PLX_9030,
-- 
1.5.3.8

