Return-Path: <linux-kernel-owner+w=401wt.eu-S1762121AbZDAOKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762121AbZDAOKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 10:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765880AbZDAOGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 10:06:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37771 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764271AbZDAOGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 10:06:03 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 13/24] usb: Auto-load cdc_acm module when device opened.
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Date: Wed, 01 Apr 2009 15:06:16 +0100
Message-ID: <20090401140614.22882.63937.stgit@localhost.localdomain>
In-Reply-To: <20090401140241.22882.93477.stgit@localhost.localdomain>
References: <20090401140241.22882.93477.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Scott James Remnant <scott@canonical.com>

The cdc_acm module is missing the char-major-166-* alias that would
cause it to be auto-loaded when a device of that type is opened.  This
patch adds the alias.

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/usb/class/cdc-acm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 5f957a9..869d47c 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1496,4 +1496,4 @@ module_exit(acm_exit);
 MODULE_AUTHOR( DRIVER_AUTHOR );
 MODULE_DESCRIPTION( DRIVER_DESC );
 MODULE_LICENSE("GPL");
-
+MODULE_ALIAS_CHARDEV_MAJOR(ACM_TTY_MAJOR);

