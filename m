Return-Path: <linux-kernel-owner+w=401wt.eu-S1759357AbYHDRNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759357AbYHDRNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 13:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756488AbYHDRNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 13:13:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57704 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754658AbYHDRNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 13:13:13 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 5/6] alpha: Fix breakage in wdt_pci
To: torvalds@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 04 Aug 2008 17:56:02 +0100
Message-ID: <20080804165540.15222.82130.stgit@localhost.localdomain>
In-Reply-To: <20080804164941.15222.24613.stgit@localhost.localdomain>
References: <20080804164941.15222.24613.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

drivers/watchdog/wdt_pci.c: In function 'wdtpci_ctr_mode':
drivers/watchdog/wdt_pci.c:120: error: implicit declaration of function 'udelay'
{standard input}: Assembler messages:

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/watchdog/wdt_pci.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/drivers/watchdog/wdt_pci.c b/drivers/watchdog/wdt_pci.c
index 078f37f..5d922fd 100644
--- a/drivers/watchdog/wdt_pci.c
+++ b/drivers/watchdog/wdt_pci.c
@@ -44,6 +44,7 @@
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
 #include <linux/ioport.h>
+#include <linux/delay.h>
 #include <linux/notifier.h>
 #include <linux/reboot.h>
 #include <linux/init.h>

