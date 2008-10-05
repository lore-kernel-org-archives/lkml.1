Return-Path: <linux-kernel-owner+w=401wt.eu-S1757866AbYJEQoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866AbYJEQoQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760501AbYJEQjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:39:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54317 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761428AbYJEQjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:39:16 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 19/19] fdomain_cs: Sort out modules with duplicate description
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:39:16 +0100
Message-ID: <20081005163913.3799.50660.stgit@localhost.localdomain>
In-Reply-To: <20081005163302.3799.61899.stgit@localhost.localdomain>
References: <20081005163302.3799.61899.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCMCIA one provides its own description so in PCMCIA mode we should use
that.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/scsi/fdomain.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index 31afaa7..32eef66 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -290,9 +290,11 @@
 #include <scsi/scsi_ioctl.h>
 #include "fdomain.h"
 
+#ifndef PCMCIA
 MODULE_AUTHOR("Rickard E. Faith");
 MODULE_DESCRIPTION("Future domain SCSI driver");
 MODULE_LICENSE("GPL");
+#endif
 
   
 #define VERSION          "$Revision: 5.51 $"

