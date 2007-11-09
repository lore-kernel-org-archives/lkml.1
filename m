Return-Path: <linux-kernel-owner+w=401wt.eu-S1763674AbXKIPgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763674AbXKIPgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 10:36:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763458AbXKIPe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 10:34:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763446AbXKIPe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 10:34:57 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 4/6] MN10300: Allocate serial port UART IDs for on-chip serial
	ports [try #5]
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-am33-list@redhat.com,
       dhowells@redhat.com
Date: Fri, 09 Nov 2007 15:34:53 +0000
Message-ID: <20071109153453.20803.35463.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071109153432.20803.69832.stgit@warthog.procyon.org.uk>
References: <20071109153432.20803.69832.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Allocate serial port UART type IDs for the MN10300 on-chip serial ports.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Alan Cox <alan@redhat.com>
---

 include/linux/serial_core.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 6a5203f..04e1319 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -149,6 +149,9 @@
 /* Freescale ColdFire */
 #define PORT_MCF	78
 
+/* MN10300 on-chip UART numbers */
+#define PORT_MN10300		79
+#define PORT_MN10300_CTS	80
 
 #ifdef __KERNEL__
 

