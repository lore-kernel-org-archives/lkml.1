Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab0CBXhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:37:17 -0500
Received: from kroah.org ([198.145.64.141]:51628 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754935Ab0CBXhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:37:03 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Mike Frysinger <vapier@gentoo.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 23/36] serial: bfin_5xx: pull in linux/io.h for ioremap prototypes
Date: Tue,  2 Mar 2010 15:36:30 -0800
Message-Id: <1267573003-782-23-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230956.GC32287@kroah.com>
References: <20100302230956.GC32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/bfin_5xx.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 6b87955..fcf273e 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -14,6 +14,7 @@
 
 #include <linux/module.h>
 #include <linux/ioport.h>
+#include <linux/io.h>
 #include <linux/init.h>
 #include <linux/console.h>
 #include <linux/sysrq.h>
-- 
1.7.0.1

