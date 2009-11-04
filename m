Return-Path: <linux-kernel-owner+w=401wt.eu-S932323AbZKDRfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323AbZKDRfN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:35:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932306AbZKDRfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:35:10 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:5665 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932305AbZKDRfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:35:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Lprw25un0kIzSj2SMpzZx5EwoC5Us1Ac2tFsTa8ZDJXnz18v4uiu64oKBVWCA54BZs
         4w9pxXMjuTN5okhrnlcfkyLsJAd7c8pivDfbUBPnQlqmTFSLhYLyxeaAKYikL39AShz9
         wzfHGgTqltwNuUXO7nIAn6Z4qmJZckwYZonRE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:34:46 +0100
Message-Id: <20091104173446.28463.62662.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 23/41] rt2x00: add driver private field to struct rt2x00_dev
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2x00: add driver private field to struct rt2x00_dev

Enhance rt2x00 infrastructure by adding driver specific field to
struct rt2x00_dev.

The new field will be used by rt2800 drivers for chipset registers
access abstraction layer.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h |    5 +++++
 1 file changed, 5 insertions(+)

Index: b/drivers/net/wireless/rt2x00/rt2x00.h
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -842,6 +842,11 @@ struct rt2x00_dev {
 	 * Firmware image.
 	 */
 	const struct firmware *fw;
+
+	/*
+	 * Driver specific data.
+	 */
+	void *priv;
 };
 
 /*
