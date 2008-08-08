Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbYHHJRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbYHHJRi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 05:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbYHHJRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 05:17:30 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:54701 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbYHHJR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 05:17:29 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: export virtio_rng.h
Date: Fri, 8 Aug 2008 11:15:07 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization@lists.linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808081115.07411.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rusty,

The entropy device was added after we exported all virtio headers. This
patch adds virtio_rng.h to the exportable userspace headers.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

---
 include/linux/Kbuild |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/include/linux/Kbuild
===================================================================
--- linux-2.6.orig/include/linux/Kbuild
+++ linux-2.6/include/linux/Kbuild
@@ -356,6 +356,7 @@ unifdef-y += virtio_balloon.h
 unifdef-y += virtio_console.h
 unifdef-y += virtio_pci.h
 unifdef-y += virtio_ring.h
+unifdef-y += virtio_rng.h
 unifdef-y += vt.h
 unifdef-y += wait.h
 unifdef-y += wanrouter.h
