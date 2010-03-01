Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab0CACu3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 21:50:29 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:33010 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab0CACu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 21:50:28 -0500
Date: Mon, 1 Mar 2010 11:49:54 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Travis <travis@sgi.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] pci: Kill off pci_register_set_vga_state() symbol export.
Message-ID: <20100301024953.GC23086@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When pci_register_set_vga_state() was made __init, the EXPORT_SYMBOL()
was retained, which now leaves us with a section mismatch.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 drivers/pci/pci.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 5b548ae..37c23b7 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3007,7 +3007,6 @@ EXPORT_SYMBOL(pcim_pin_device);
 EXPORT_SYMBOL(pci_disable_device);
 EXPORT_SYMBOL(pci_find_capability);
 EXPORT_SYMBOL(pci_bus_find_capability);
-EXPORT_SYMBOL(pci_register_set_vga_state);
 EXPORT_SYMBOL(pci_release_regions);
 EXPORT_SYMBOL(pci_request_regions);
 EXPORT_SYMBOL(pci_request_regions_exclusive);
