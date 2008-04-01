Return-Path: <linux-kernel-owner+w=401wt.eu-S1757886AbYDAJ1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886AbYDAJ1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 05:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755890AbYDAJ1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 05:27:46 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:52422 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563AbYDAJ1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 05:27:45 -0400
From: "Satoshi UCHIDA" <s-uchida@ap.jp.nec.com>
To: <linux-kernel@vger.kernel.org>, <containers@lists.linux-foundation.org>,
       <axboe@kernel.dk>, <menage@google.com>
Cc: <s-uchida@ap.jp.nec.com>,
       "'Tomoyoshi Sugawara'" <tom-sugawara@ap.jp.nec.com>,
       <m-takahashi@ex.jp.nec.com>
References: <007801c893d9$d89726f0$89c574d0$@jp.nec.com>
In-Reply-To: <007801c893d9$d89726f0$89c574d0$@jp.nec.com>
Subject: [RFC][patch 1/11][CFQ-cgroup] Add Configuration
Date: Tue, 1 Apr 2008 18:27:31 +0900
Message-Id: <007e01c893da$9c41ca10$d4c55e30$@jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AciT2dazsgoxpK4vQk6Hf026phpfBAAADAUg
Content-Language: ja
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds configuration entry into block/Kconfig.iosched.

   Signed-off-by: Satoshi UCHIDA <uchida@ap.jp.nec.com>

diff --git a/block/Kconfig.iosched b/block/Kconfig.iosched
index 96a01b3..493c68c 100644
--- a/block/Kconfig.iosched
+++ b/block/Kconfig.iosched
@@ -25,6 +25,15 @@ config IOSCHED_CFQ
 
 	  If unsure, say Y.
 
+config CGROUP_CFQ
+	bool "handling cgroup in CFQ"
+	default n
+	depends on IOSCHED_CFQ && CGROUPS
+	---help---
+          This option exptends CFQ to handling cgroup.
+          CFQ is changed into two layler control
+          per-cgroup layler and per-task layler.
+	
 config IOSCHED_AS
 	tristate "Anticipatory I/O scheduler"
 	default y

