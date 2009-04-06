Return-Path: <linux-kernel-owner+w=401wt.eu-S1759276AbZDFPmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759276AbZDFPmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 11:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757449AbZDFPgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 11:36:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57006 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757363AbZDFPgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:36:50 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 27/27] 8250: Fix warning
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 06 Apr 2009 17:35:42 +0100
Message-ID: <20090406163539.12934.21845.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090406162959.12934.97904.stgit@t61.ukuu.org.uk>
References: <20090406162959.12934.97904.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 8430 patch was short a const so caused a warning.

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/serial/8250_pci.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)


diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
index 5b0e80d..7ddff3f 100644
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -728,7 +728,8 @@ static int pci_ni8430_init(struct pci_dev *dev)
 #define NI8430_PORTCON_TXVR_ENABLE	(1 << 3)
 
 static int
-pci_ni8430_setup(struct serial_private *priv, struct pciserial_board *board,
+pci_ni8430_setup(struct serial_private *priv,
+		 const struct pciserial_board *board,
 		 struct uart_port *port, int idx)
 {
 	void __iomem *p;

