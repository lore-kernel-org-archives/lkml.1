Return-Path: <linux-kernel-owner+w=401wt.eu-S936104AbZFPFyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936104AbZFPFyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763481AbZFPFvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:03 -0400
Received: from kroah.org ([198.145.64.141]:48330 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761870AbZFPFvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:02 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 14/64] kobject: samples: make SAMPLE_KOBJECT module-only
Date: Mon, 15 Jun 2009 22:46:03 -0700
Message-Id: <1245131213-24168-14-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Marek <mmarek@suse.cz>

With SAMPLE_KOBJECT=y, it isn't even linked into the kernel image.

Signed-off-by: Michal Marek <mmarek@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 samples/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/samples/Kconfig b/samples/Kconfig
index b75d28c..428b065 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -26,7 +26,8 @@ config SAMPLE_TRACE_EVENTS
 	  This build trace event example modules.
 
 config SAMPLE_KOBJECT
-	tristate "Build kobject examples"
+	tristate "Build kobject examples -- loadable modules only"
+	depends on m
 	help
 	  This config option will allow you to build a number of
 	  different kobject sample modules showing how to use kobjects,
-- 
1.6.3.2

