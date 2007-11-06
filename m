Return-Path: <linux-kernel-owner+w=401wt.eu-S1757444AbXKFVyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbXKFVyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 16:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754805AbXKFVyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 16:54:45 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754534AbXKFVyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 16:54:44 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Remove the section annotation on free_initmem()
To: torvalds@osdl.org, akpm@osdl.org, jdi@l4x.org
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Tue, 06 Nov 2007 21:54:44 +0000
Message-ID: <20071106215444.6521.3556.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Remove the section annotation on FRV's free_initmem().  It can't be marked
__init, lest it free itself.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/mm/init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/frv/mm/init.c b/arch/frv/mm/init.c
index 4103c2c..b841ecf 100644
--- a/arch/frv/mm/init.c
+++ b/arch/frv/mm/init.c
@@ -197,7 +197,7 @@ void __init mem_init(void)
 /*
  * free the memory that was only required for initialisation
  */
-void __init free_initmem(void)
+void free_initmem(void)
 {
 #if defined(CONFIG_RAMKERNEL) && !defined(CONFIG_PROTECT_KERNEL)
 	unsigned long start, end, addr;

