Return-Path: <linux-kernel-owner+w=401wt.eu-S934875AbZKYRNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934875AbZKYRNg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:13:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934865AbZKYRNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:13:31 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52976 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934853AbZKYRN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:13:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=OqmoZ4IpQzkDbJEQFKQWsMSA7glLZSfFdnLB8d7tC5JAlbhRP6r0EwIcTU90zQuC3l
         O9kuFtTM9BwBKS6nwQH1kuDpa4BIwS/ga6ViUXZ6aH+0rGewZg9JOsU7Gqq7YJMQCSQr
         tXmOu+KIYDhbLjeklePho6g02n9ccygOtoj6I=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:12:48 +0100
Message-Id: <20091125171248.5446.22482.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 86/86] libata: add private driver field to struct ata_device
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] libata: add private driver field to struct ata_device

This brings struct ata_device in-line with struct ata_{port,host}.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 include/linux/libata.h |    1 +
 1 file changed, 1 insertion(+)

Index: b/include/linux/libata.h
===================================================================
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -585,6 +585,7 @@ struct ata_device {
 	unsigned int		horkage;	/* List of broken features */
 	unsigned long		flags;		/* ATA_DFLAG_xxx */
 	struct scsi_device	*sdev;		/* attached SCSI device */
+	void			*private_data;
 #ifdef CONFIG_ATA_ACPI
 	acpi_handle		acpi_handle;
 	union acpi_object	*gtf_cache;
