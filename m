Return-Path: <linux-kernel-owner+w=401wt.eu-S1756872AbZLWTxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbZLWTxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 14:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbZLWTxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 14:53:18 -0500
Received: from kroah.org ([198.145.64.141]:52961 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496AbZLWTxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 14:53:16 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Michael Hennerich <michael.hennerich@analog.com>,
       Mike Frysinger <vapier@gentoo.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/10] Driver core: export platform_device_register_data as a GPL symbol
Date: Wed, 23 Dec 2009 11:52:42 -0800
Message-Id: <1261597963-18323-9-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.6
In-Reply-To: <20091223194955.GB18101@kroah.com>
References: <20091223194955.GB18101@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

This allows MFD's to register/bind drivers for their sub devices while
still being compiled as a module.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 9d2ee25..58efaf2 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -441,6 +441,7 @@ error:
 	platform_device_put(pdev);
 	return ERR_PTR(retval);
 }
+EXPORT_SYMBOL_GPL(platform_device_register_data);
 
 static int platform_drv_probe(struct device *_dev)
 {
-- 
1.6.5.7

