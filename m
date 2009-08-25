Return-Path: <linux-kernel-owner+w=401wt.eu-S1754652AbZHYIHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbZHYIHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 04:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbZHYIHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 04:07:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:41124 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbZHYIHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 04:07:09 -0400
Date: Tue, 25 Aug 2009 08:06:41 GMT
From: tip-bot for Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       broonie@opensource.wolfsonmicro.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       broonie@opensource.wolfsonmicro.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1251142084-9852-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1251142084-9852-1-git-send-email-broonie@opensource.wolfsonmicro.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Add prototype for handle_nested_irq()
Message-ID: <tip-31b47cf7609288893a10706c648faa932c7aef90@git.kernel.org>
Git-Commit-ID: 31b47cf7609288893a10706c648faa932c7aef90
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 25 Aug 2009 08:06:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  31b47cf7609288893a10706c648faa932c7aef90
Gitweb:     http://git.kernel.org/tip/31b47cf7609288893a10706c648faa932c7aef90
Author:     Mark Brown <broonie@opensource.wolfsonmicro.com>
AuthorDate: Mon, 24 Aug 2009 20:28:04 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 25 Aug 2009 10:05:05 +0200

genirq: Add prototype for handle_nested_irq()

The function is supposed to be called from the primary IRQ
handler for a demultiplexing chip so make a protype visible for
them.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
LKML-Reference: <1251142084-9852-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/irq.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 6956df9..9e9eb76 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -282,6 +282,7 @@ extern void handle_edge_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_simple_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_percpu_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_bad_irq(unsigned int irq, struct irq_desc *desc);
+extern void handle_nested_irq(unsigned int irq);
 
 /*
  * Monolithic do_IRQ implementation.
