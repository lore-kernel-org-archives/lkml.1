Return-Path: <linux-kernel-owner+w=401wt.eu-S934766AbZKYRLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934766AbZKYRLs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933637AbZKYRLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:11:44 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:39819 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934738AbZKYRLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:11:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=U/IPKhkKubl9XYW1EohcIRBX3sWPBYMxxg1CGdOLdVyraHe8a1U/BMPvy0JdnNJ+qh
         PXRuJIM6I+dtayhQ4cBs5UziUfs6yWu3r0JeMDVMvUmw1FU2WsGP2+0zVXQ12pQhC7Dx
         NWpO7k+KqGP20xf+8guxhBLbqiQj4ouTabuW8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:11:00 +0100
Message-Id: <20091125171100.5446.73058.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 72/86] pata_serverworks: add 32-bit PIO support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_serverworks: add 32-bit PIO support

There shouldn't be any problems with it as IDE serverworks host driver
has been allowing 32-bit PIO operations for years.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_serverworks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/pata_serverworks.c
===================================================================
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -300,7 +300,7 @@ static struct scsi_host_template serverw
 };
 
 static struct ata_port_operations serverworks_osb4_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
+	.inherits	= &ata_bmdma32_port_ops,
 	.cable_detect	= serverworks_cable_detect,
 	.mode_filter	= serverworks_osb4_filter,
 	.set_piomode	= serverworks_set_piomode,
