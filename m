Return-Path: <linux-kernel-owner+w=401wt.eu-S935468AbYBCAsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935468AbYBCAsm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 19:48:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbYBCAsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 19:48:35 -0500
Received: from www.tglx.de ([62.245.132.106]:51082 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008AbYBCAse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 19:48:34 -0500
Date: Sun, 3 Feb 2008 01:48:28 +0100
From: =?UTF-8?B?SGFucy1Kw7xyZ2Vu?= Koch <hjk@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Benedikt Spranger <b.spranger@linutronix.de>
Subject: [PATCH] Remove needless PCI_DEVICE_ID definition from uio_cif.c
Message-ID: <20080203014828.579d6504@dilbert.local>
Organization: Linutronix
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans J. Koch <hjk@linutronix.de>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Benedikt Spranger <b.spranger@linutronix.de>
Subject: Remove needless PCI_DEVICE_ID definition from uio_cif.c
Date: Sun, 03 Feb 2008 01:37:58 +0100

Meanwhile, PCI_DEVICE_ID_PLX_9030 is defined in pci_ids.h, no need to
define it again in the driver.

Signed-off-by: Hans J. Koch <hjk@linutronix.de>

---
 drivers/uio/uio_cif.c |    4 ----
 1 file changed, 4 deletions(-)

Index: linux-2.6.25-rc/drivers/uio/uio_cif.c
===================================================================
--- linux-2.6.25-rc.orig/drivers/uio/uio_cif.c	2008-02-03
01:29:55.000000000 +0100 +++
linux-2.6.25-rc/drivers/uio/uio_cif.c	2008-02-03
01:31:00.000000000 +0100 @@ -15,10 +15,6 @@ 
 #include <asm/io.h>
 
-#ifndef PCI_DEVICE_ID_PLX_9030
-#define PCI_DEVICE_ID_PLX_9030	0x9030
-#endif
-
 #define PLX9030_INTCSR		0x4C
 #define INTSCR_INT1_ENABLE	0x01
 #define INTSCR_INT1_STATUS	0x04
