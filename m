Return-Path: <linux-kernel-owner+w=401wt.eu-S1757363AbZFVOc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbZFVOc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757218AbZFVOco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:32:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53457 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757287AbZFVOcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:32:43 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] LDSCRIPT: Name INIT_RAM_FS consistently
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>, Sam Ravnborg <sam@ravnborg.org>
Date: Mon, 22 Jun 2009 15:32:31 +0100
Message-ID: <20090622143231.3927.1495.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In asm-generic/vmlinux.lds.h, name INIT_RAM_FS consistently, no matter the
setting of CONFIG_BLK_DEV_INITRD.  This corrects:

	commit ef53dae8658cf0e93d380983824a661067948d87
	Author: Sam Ravnborg <sam@ravnborg.org>
	Date:   Sun Jun 7 20:46:37 2009 +0200
	Subject: Improve vmlinux.lds.h support for arch specific linker scripts

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
---

 include/asm-generic/vmlinux.lds.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 55413e5..92b73b6 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -625,7 +625,7 @@
 	*(.init.ramfs)							\
 	VMLINUX_SYMBOL(__initramfs_end) = .;
 #else
-#define INITRAMFS
+#define INIT_RAM_FS
 #endif
 
 /**

