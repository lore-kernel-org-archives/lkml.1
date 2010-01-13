Return-Path: <linux-kernel-owner+w=401wt.eu-S1755850Ab0AMKjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab0AMKjF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:39:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755828Ab0AMKi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:38:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:38588 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755833Ab0AMKiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:38:52 -0500
Date: Wed, 13 Jan 2010 10:38:07 GMT
From: tip-bot for Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       broonie@opensource.wolfsonmicro.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       broonie@opensource.wolfsonmicro.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1262698198-30392-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1262698198-30392-1-git-send-email-broonie@opensource.wolfsonmicro.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Fix documentation of default chip disable()
Message-ID: <tip-599faa0e264fe2e7f563f87b4aad8c83e9dc46d1@git.kernel.org>
Git-Commit-ID: 599faa0e264fe2e7f563f87b4aad8c83e9dc46d1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:38:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  599faa0e264fe2e7f563f87b4aad8c83e9dc46d1
Gitweb:     http://git.kernel.org/tip/599faa0e264fe2e7f563f87b4aad8c83e9dc46d1
Author:     Mark Brown <broonie@opensource.wolfsonmicro.com>
AuthorDate: Tue, 5 Jan 2010 13:29:58 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 11:14:18 +0100

genirq: Fix documentation of default chip disable()

The documentation says that by default disable() will be
chip->mask but in fact default_disable() is a noop.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
LKML-Reference: <1262698198-30392-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/irq.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 451481c..d13492d 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -90,7 +90,7 @@ struct msi_desc;
  * @startup:		start up the interrupt (defaults to ->enable if NULL)
  * @shutdown:		shut down the interrupt (defaults to ->disable if NULL)
  * @enable:		enable the interrupt (defaults to chip->unmask if NULL)
- * @disable:		disable the interrupt (defaults to chip->mask if NULL)
+ * @disable:		disable the interrupt
  * @ack:		start of a new interrupt
  * @mask:		mask an interrupt source
  * @mask_ack:		ack and mask an interrupt source
