Return-Path: <linux-kernel-owner+w=401wt.eu-S965920AbXHIOzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965920AbXHIOzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 10:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939641AbXHIOyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 10:54:55 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:46469 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936419AbXHIOyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 10:54:54 -0400
Date: Thu, 9 Aug 2007 16:55:11 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] include linux/types.h in if_fddi.h
Message-ID: <20070809145511.GA8244@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


include/linux/if_fddi.h is an exported header.
It uses __be16. Include linux/types.h to get this prototype.

Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
 include/linux/if_fddi.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/if_fddi.h
+++ b/include/linux/if_fddi.h
@@ -24,6 +24,8 @@
 #ifndef _LINUX_IF_FDDI_H
 #define _LINUX_IF_FDDI_H
 
+#include <linux/types.h>
+
 /*
  *  Define max and min legal sizes.  The frame sizes do not include
  *  4 byte FCS/CRC (frame check sequence).
