Return-Path: <linux-kernel-owner+w=401wt.eu-S1761016AbYDCHL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761016AbYDCHL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 03:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758730AbYDCHLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 03:11:49 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:64625 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758801AbYDCHLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 03:11:48 -0400
From: "Satoshi UCHIDA" <s-uchida@ap.jp.nec.com>
To: "'Satoshi UCHIDA'" <s-uchida@ap.jp.nec.com>,
       "'Paul Menage'" <menage@google.com>, <linux-kernel@vger.kernel.org>,
       <containers@lists.linux-foundation.org>
Cc: <axboe@kernel.dk>, <tom-sugawara@ap.jp.nec.com>
References: <007801c893d9$d89726f0$89c574d0$@jp.nec.com>		<008001c893db$4e2eccf0$ea8c66d0$@jp.nec.com>	<6599ad830804021541s3c1e3197y77d87f63bf47e4b3@mail.gmail.com> <005d01c89559$9e538200$dafa8600$@jp.nec.com>
In-Reply-To: <005d01c89559$9e538200$dafa8600$@jp.nec.com>
Subject: [PATCH] [RFC][patch 1/12][CFQ-cgroup] Add Configuration
Date: Thu, 3 Apr 2008 16:11:34 +0900
Message-Id: <005e01c89559$f37ef1b0$da7cd510$@jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AciVEsqJacziMmPnQjKpkKdoNO90TwARhoqAAAA3wOA=
Content-Language: ja
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds configuration entry into block/Kconfig.iosched.

      Signed-off-by: Satoshi UCHIDA <uchida@ap.jp.nec.com>

---
 block/Kconfig.iosched |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/block/Kconfig.iosched b/block/Kconfig.iosched
index 96a01b3..25fa6bb 100644
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
+          CFQ is changed into two layler control --
+          per-cgroup layler and per-task layler --.
+	
 config IOSCHED_AS
 	tristate "Anticipatory I/O scheduler"
 	default y
-- 
1.5.4.1


