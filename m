Return-Path: <linux-kernel-owner+w=401wt.eu-S1761968AbXKHRR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761968AbXKHRR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 12:17:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760980AbXKHRQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 12:16:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760794AbXKHRQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 12:16:37 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 4/6] MN10300: Allocate serial port UART IDs for on-chip serial
	ports [try #4]
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-am33-list@redhat.com,
       dhowells@redhat.com
Date: Thu, 08 Nov 2007 17:16:32 +0000
Message-ID: <20071108171632.26590.12547.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071108171612.26590.4348.stgit@warthog.procyon.org.uk>
References: <20071108171612.26590.4348.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Allocate serial port UART type IDs for the MN10300 on-chip serial ports.

Signed-off-by: David Howells <dhowells@redhat.com>
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
 

