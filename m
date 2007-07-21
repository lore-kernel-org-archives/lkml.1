Return-Path: <linux-kernel-owner+w=401wt.eu-S940351AbXGUPK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940351AbXGUPK2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939233AbXGUPD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:03:58 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:37344 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939056AbXGUPD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:03:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=R0LrfxFhNrMUCwozS66Ax/LpafLk++DBr28hIqdOfD8DUd+ouDrX2exGVyGU+V2bmBThQUbWl5vhpW+GcF1q5R6u/8B+PfmhGGkT90oWuvPH0qUP0wWCTj2bb5tOtndaWptQu9gn7g6RzwGYf0o1K9TCAQLecPQwlv4DtRFSB1A=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][15/37] Clean up duplicate includes in drivers/usb/
Date: Sat, 21 Jul 2007 17:02:59 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Greg Kroah-Hartman <greg@kroah.com>, gregkh@suse.de,
       linux-usb-users@lists.sourceforge.net,
       Tony Olech <tony.olech@elandigitalsystems.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707211702.59265.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch cleans up duplicate includes in
	drivers/usb/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/drivers/usb/host/u132-hcd.c b/drivers/usb/host/u132-hcd.c
index 7f765ec..b38a9bd 100644
--- a/drivers/usb/host/u132-hcd.c
+++ b/drivers/usb/host/u132-hcd.c
@@ -51,7 +51,6 @@
 #include <linux/usb.h>
 #include <linux/workqueue.h>
 #include <linux/platform_device.h>
-#include <linux/pci_ids.h>
 #include <linux/mutex.h>
 #include <asm/io.h>
 #include <asm/irq.h>
