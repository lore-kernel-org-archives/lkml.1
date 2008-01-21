Return-Path: <linux-kernel-owner+w=401wt.eu-S1761107AbYAUXUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761107AbYAUXUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 18:20:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757498AbYAUXSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 18:18:14 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:43432 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757433AbYAUXSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 18:18:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=AB4I2n9pmXAhc2SnlrAybr9ouCYcRGiKyfTGURdmeVa95CtqRfu8cHSluui4cWvA1lv3jzpBlkxdp5VaOeuZ5EcfXi3S0C/1IoCqYHxliDcffQuZ5L+Kc/b8LoKhGEcE5luFwzgQqkWoFWVPDxcICI0eY0KRJx7fz1uUTpk9A4U=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 22 Jan 2008 00:31:17 +0100
Message-Id: <20080121233117.30311.46211.sendpatchset@localhost.localdomain>
In-Reply-To: <20080121233036.30311.76015.sendpatchset@localhost.localdomain>
References: <20080121233036.30311.76015.sendpatchset@localhost.localdomain>
Subject: [PATCH 06/16] ide: remove unused ->auto_poll field from ide_hwif_t
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 include/linux/ide.h |    1 -
 1 file changed, 1 deletion(-)

Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -607,7 +607,6 @@ typedef struct hwif_s {
 	unsigned	serialized : 1;	/* serialized all channel operation */
 	unsigned	sharing_irq: 1;	/* 1 = sharing irq with another hwif */
 	unsigned	reset      : 1;	/* reset after probe */
-	unsigned	auto_poll  : 1; /* supports nop auto-poll */
 	unsigned	sg_mapped  : 1;	/* sg_table and sg_nents are ready */
 	unsigned	mmio       : 1; /* host uses MMIO */
 
