Return-Path: <linux-kernel-owner+w=401wt.eu-S1754330Ab0AOArd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab0AOArd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 19:47:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730Ab0AOArc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 19:47:32 -0500
Received: from [206.15.93.42] ([206.15.93.42]:15422 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751156Ab0AOArb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 19:47:31 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH] scsi_scan.c: quiet sparse noise
Date: Thu, 14 Jan 2010 17:47:32 -0700
Cc: James.Bottomley@suse.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001141747.32906.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

scsi_scan.c: quiet sparse noise

Include the <scsi/scsi_scan.h> header to pick up the extern
prototype of scsi_complete_async_scans in order to quiet
the following sparse warning:

warning: symbol 'scsi_complete_async_scans' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>

---

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 012f73a..6e3ca0a 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -42,6 +42,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_eh.h>
+#include <scsi/scsi_scan.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
