Return-Path: <linux-kernel-owner+w=401wt.eu-S1757399AbYDXE5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbYDXE5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 00:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756043AbYDXE4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 00:56:38 -0400
Received: from ozlabs.org ([203.10.76.45]:58760 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756033AbYDXE4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 00:56:36 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Wed, 23 Apr 2008 23:56:29 -0500
Cc: virtualization@lists.linux-foundation.org,
       Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 4/6] virtio: export more headers to userspace
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804241456.29940.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

Rusty,

is there a reason why we dont export the virtio headers for
9p, balloon, console, pci, and virtio_ring? kvm uses make sync,
but I think it is still useful to heave these headers exported 
as they might be useful for other userspace tools.

I dont export virtio.h, because it does not seem to have useful 
information for userspace and it requires scatterlist.h which is 
also not exported. See also my other mail about your "virtio:
change config to guest endian." patch.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/Kbuild |    5 +++++
 1 file changed, 5 insertions(+)

Index: kvm/include/linux/Kbuild
===================================================================
--- kvm.orig/include/linux/Kbuild
+++ kvm/include/linux/Kbuild
@@ -346,6 +346,11 @@ unifdef-y += videodev.h
 unifdef-y += virtio_config.h
 unifdef-y += virtio_blk.h
 unifdef-y += virtio_net.h
+unifdef-y += virtio_9p.h
+unifdef-y += virtio_balloon.h
+unifdef-y += virtio_console.h
+unifdef-y += virtio_pci.h
+unifdef-y += virtio_ring.h
 unifdef-y += vt.h
 unifdef-y += wait.h
 unifdef-y += wanrouter.h


