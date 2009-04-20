Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbZDTLrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbZDTLrZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 07:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754980AbZDTLrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 07:47:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58429 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754882AbZDTLrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 07:47:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Don't attempt to #include <linux/blk.h> as it doesn't
	exist
To: torvalds@osdl.org, akpm@linux-foundation.org, rpjday@crashcourse.ca
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Mon, 20 Apr 2009 12:46:24 +0100
Message-ID: <20090420114624.28368.9627.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop the FRV arch from attempting to #include <linux/blk.h> as it doesn't
exist.

Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/kernel/setup.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)


diff --git a/arch/frv/kernel/setup.c b/arch/frv/kernel/setup.c
index 0669e13..55e4fab 100644
--- a/arch/frv/kernel/setup.c
+++ b/arch/frv/kernel/setup.c
@@ -46,7 +46,6 @@
 #include <asm/io.h>
 
 #ifdef CONFIG_BLK_DEV_INITRD
-#include <linux/blk.h>
 #include <asm/pgtable.h>
 #endif
 

