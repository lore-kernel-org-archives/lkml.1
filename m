Return-Path: <linux-kernel-owner+w=401wt.eu-S1762545AbZLKEmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762545AbZLKEmB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:42:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762531AbZLKEl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:41:58 -0500
Received: from kroah.org ([198.145.64.141]:37188 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762299AbZLKEgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:36:51 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:28:22 2009
Message-Id: <20091211042821.450487768@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:26:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Martin Michlmayr <tbm@cyrius.com>, Boaz Harrosh <bharrosh@panasas.com>,
       James Bottomley <James.Bottomley@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [87/90] SCSI: osd_protocol.h: Add missing #include
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=scsi-osd_protocol.h-add-missing-include.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Martin Michlmayr <tbm@cyrius.com>

commit 0899638688f223fd9e9fee60d662665e11693d12 upstream.

include/scsi/osd_protocol.h uses ALIGN() without an #include
<linux/kernel.h>, leading to:
| include/scsi/osd_protocol.h:362: error: implicit declaration of function 'ALIGN'

Signed-off-by: Martin Michlmayr <tbm@cyrius.com>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/scsi/osd_protocol.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/scsi/osd_protocol.h
+++ b/include/scsi/osd_protocol.h
@@ -17,6 +17,7 @@
 #define __OSD_PROTOCOL_H__
 
 #include <linux/types.h>
+#include <linux/kernel.h>
 #include <asm/unaligned.h>
 #include <scsi/scsi.h>
 


