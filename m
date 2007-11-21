Return-Path: <linux-kernel-owner+w=401wt.eu-S1762298AbXKUQSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762298AbXKUQSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 11:18:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760893AbXKUQRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 11:17:11 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760750AbXKUQRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 11:17:07 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 6/9] MN10300: Allocate serial port UART IDs for on-chip serial
	ports [2.6.24-rc3-mm1]
To: akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
Date: Wed, 21 Nov 2007 16:16:57 +0000
Message-ID: <20071121161657.1097.13476.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071121161632.1097.9556.stgit@warthog.procyon.org.uk>
References: <20071121161632.1097.9556.stgit@warthog.procyon.org.uk>
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

 include/linux/serial_core.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 5a895f2..de569cf 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -152,6 +152,10 @@
 /* Blackfin SPORT */
 #define PORT_BFIN_SPORT		79
 
+/* MN10300 on-chip UART numbers */
+#define PORT_MN10300		80
+#define PORT_MN10300_CTS	81
+
 #ifdef __KERNEL__
 
 #include <linux/compiler.h>

