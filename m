Return-Path: <linux-kernel-owner+w=401wt.eu-S932776AbZDAOOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776AbZDAOOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 10:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932479AbZDAOHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 10:07:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37789 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932364AbZDAOHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 10:07:01 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 19/24] jsm: define init function as __devinit
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Date: Wed, 01 Apr 2009 15:07:16 +0100
Message-ID: <20090401140702.22882.42599.stgit@localhost.localdomain>
In-Reply-To: <20090401140241.22882.93477.stgit@localhost.localdomain>
References: <20090401140241.22882.93477.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Breno Leitao <leitao@linux.vnet.ibm.com>

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/serial/jsm/jsm_driver.c |    2 +-
 drivers/serial/jsm/jsm_tty.c    |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/drivers/serial/jsm/jsm_driver.c b/drivers/serial/jsm/jsm_driver.c
index ac79cbe..576aafb 100644
--- a/drivers/serial/jsm/jsm_driver.c
+++ b/drivers/serial/jsm/jsm_driver.c
@@ -52,7 +52,7 @@ int jsm_debug;
 module_param(jsm_debug, int, 0);
 MODULE_PARM_DESC(jsm_debug, "Driver debugging level");
 
-static int jsm_probe_one(struct pci_dev *pdev, const struct pci_device_id *ent)
+static int __devinit jsm_probe_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int rc = 0;
 	struct jsm_board *brd;
diff --git a/drivers/serial/jsm/jsm_tty.c b/drivers/serial/jsm/jsm_tty.c
index 324c74d..3306963 100644
--- a/drivers/serial/jsm/jsm_tty.c
+++ b/drivers/serial/jsm/jsm_tty.c
@@ -367,7 +367,7 @@ static struct uart_ops jsm_ops = {
  * Init the tty subsystem.  Called once per board after board has been
  * downloaded and init'ed.
  */
-int jsm_tty_init(struct jsm_board *brd)
+int __devinit jsm_tty_init(struct jsm_board *brd)
 {
 	int i;
 	void __iomem *vaddr;
@@ -431,7 +431,7 @@ int jsm_tty_init(struct jsm_board *brd)
 	return 0;
 }
 
-int jsm_uart_port_init(struct jsm_board *brd)
+int __devinit jsm_uart_port_init(struct jsm_board *brd)
 {
 	int i;
 	struct jsm_channel *ch;

