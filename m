Return-Path: <linux-kernel-owner+w=401wt.eu-S1755962Ab0ASLNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab0ASLNf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 06:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756167Ab0ASLNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 06:13:12 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:40547 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756155Ab0ASLNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 06:13:07 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/4] serial: bfin_5xx: pull in linux/io.h for ioremap prototypes
Date: Tue, 19 Jan 2010 06:13:13 -0500
Message-Id: <1263899593-12178-4-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263899593-12178-1-git-send-email-vapier@gentoo.org>
References: <1263899593-12178-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
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
1.6.6

