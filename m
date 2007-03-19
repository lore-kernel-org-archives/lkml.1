Return-Path: <linux-kernel-owner+w=401wt.eu-S1030686AbXCSVtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030686AbXCSVtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030680AbXCSVtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:49:05 -0400
Received: from ganymede.vroon.org ([195.66.242.11]:55978 "EHLO
	ganymede.vroon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030683AbXCSVsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:48:46 -0400
From: Tony Vroon <chainsaw@gentoo.org>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: <htejun@gmail.com>, <alan@lxorguk.ukuu.org.uk>,
       <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2.6.22 2/3] Add LED trigger to libata core
Message-Id: <20070319214837.DC3CE5B80F1@ganymede.vroon.org>
Date: Mon, 19 Mar 2007 21:48:37 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This hooks up ata_ac_issue_prot_with_ledtrigger.
Respin of an earlier patch, based on comments by Tejun Heo & Alan Cox.

Signed-off-by: Tony Vroon <chainsaw@gentoo.org>

--- linux-2.6/include/linux/libata.h.orig	2007-03-19 21:15:04.000000000 +0000
+++ linux-2.6/include/linux/libata.h	2007-03-19 21:15:30.000000000 +0000
@@ -786,6 +786,7 @@
 extern void ata_qc_prep(struct ata_queued_cmd *qc);
 extern void ata_noop_qc_prep(struct ata_queued_cmd *qc);
 extern unsigned int ata_qc_issue_prot(struct ata_queued_cmd *qc);
+extern unsigned int ata_qc_issue_prot_with_ledtrigger(struct ata_queued_cmd *qc);
 extern void ata_sg_init_one(struct ata_queued_cmd *qc, void *buf,
 		unsigned int buflen);
 extern void ata_sg_init(struct ata_queued_cmd *qc, struct scatterlist *sg,
