Return-Path: <linux-kernel-owner+w=401wt.eu-S1752621AbZDQTKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbZDQTKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 15:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbZDQTHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 15:07:32 -0400
Received: from kroah.org ([198.145.64.141]:51230 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754347AbZDQTHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 15:07:31 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 10/10] UIO: fix specific device driver missing statement for depmod
Date: Fri, 17 Apr 2009 12:04:34 -0700
Message-Id: <1239995074-4065-10-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20090417190144.GB3548@kroah.com>
References: <20090417190144.GB3548@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans J. Koch <hjk@linutronix.de>

On Fri, Apr 10, 2009 at 01:50:50PM -0700, Andrew Morton wrote:
> On Fri, 10 Apr 2009 13:32:01 GMT
> bugzilla-daemon@bugzilla.kernel.org wrote:
>
> > http://bugzilla.kernel.org/show_bug.cgi?id=13059

drivers/uio/uio_cif.c misses a MODULE_DEVICE_TABLE, this fixes it.

Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/uio/uio_cif.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/uio/uio_cif.c b/drivers/uio/uio_cif.c
index c60b8fc..28034c8 100644
--- a/drivers/uio/uio_cif.c
+++ b/drivers/uio/uio_cif.c
@@ -147,5 +147,6 @@ static void __exit hilscher_exit_module(void)
 module_init(hilscher_init_module);
 module_exit(hilscher_exit_module);
 
+MODULE_DEVICE_TABLE(pci, hilscher_pci_ids);
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Hans J. Koch, Benedikt Spranger");
-- 
1.6.2

