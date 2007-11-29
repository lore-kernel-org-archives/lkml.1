Return-Path: <linux-kernel-owner+w=401wt.eu-S934430AbXK2W4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934430AbXK2W4A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 17:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933260AbXK2WyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 17:54:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933695AbXK2WxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 17:53:19 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 6/9] MN10300: Allocate serial port UART IDs for on-chip serial
	ports [2.6.24-rc3-mm2]
To: akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
Date: Thu, 29 Nov 2007 22:52:45 +0000
Message-ID: <20071129225245.21536.65028.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071129225219.21536.58653.stgit@warthog.procyon.org.uk>
References: <20071129225219.21536.58653.stgit@warthog.procyon.org.uk>
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
index f59559f..ca5e58c 100644
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

