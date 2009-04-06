Return-Path: <linux-kernel-owner+w=401wt.eu-S1751971AbZDFOut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbZDFOut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 10:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbZDFOui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 10:50:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42875 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbZDFOuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 10:50:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Make CONFIG_SLOW_WORK an automatic rather than manual config
	option
To: torvalds@osdl.org, akpm@linux-foundation.org, jeff@garzik.org
Cc: dhowells@redhat.com, jj@chaosbits.net, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Date: Mon, 06 Apr 2009 15:47:25 +0100
Message-ID: <20090406144725.19407.16817.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make CONFIG_SLOW_WORK an automatic rather than manual config option so that
people configuring their kernels don't have to make the choice.  It can be
selected automatically by those things that require it (such as FS-Cache).

Signed-off-by: David Howells <dhowells@redhat.com>
---

 init/Kconfig |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)


diff --git a/init/Kconfig b/init/Kconfig
index 09c7953..c52d1d4 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1016,7 +1016,7 @@ source "arch/Kconfig"
 
 config SLOW_WORK
 	default n
-	bool "Enable slow work thread pool"
+	bool
 	help
 	  The slow work thread pool provides a number of dynamically allocated
 	  threads that can be used by the kernel to perform operations that
@@ -1026,6 +1026,8 @@ config SLOW_WORK
 	  by a series of mkdirs and a create call, all of which have to touch
 	  disk.
 
+	  See Documentation/slow-work.txt.
+
 endmenu		# General setup
 
 config HAVE_GENERIC_DMA_COHERENT

