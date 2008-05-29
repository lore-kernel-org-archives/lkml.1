Return-Path: <linux-kernel-owner+w=401wt.eu-S1755084AbYE2SU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbYE2SU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbYE2STw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:19:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753928AbYE2STv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:19:51 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/6] Werror: Remove iiEllisCleanup() as it's unused.
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, bunk@kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 29 May 2008 19:17:36 +0100
Message-ID: <20080529181736.5396.28119.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080529181726.5396.79336.stgit@warthog.procyon.org.uk>
References: <20080529181726.5396.79336.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove iiEllisCleanup() as it's unused.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/char/ip2/i2ellis.c |   16 ----------------
 1 files changed, 0 insertions(+), 16 deletions(-)


diff --git a/drivers/char/ip2/i2ellis.c b/drivers/char/ip2/i2ellis.c
index 3601017..a7c89d8 100644
--- a/drivers/char/ip2/i2ellis.c
+++ b/drivers/char/ip2/i2ellis.c
@@ -85,22 +85,6 @@ iiEllisInit(void)
 }
 
 //******************************************************************************
-// Function:   iiEllisCleanup()
-// Parameters: None
-//
-// Returns:    Nothing
-//
-// Description:
-//
-// This routine performs any required cleanup of the iiEllis subsystem.
-//
-//******************************************************************************
-static void
-iiEllisCleanup(void)
-{
-}
-
-//******************************************************************************
 // Function:   iiSetAddress(pB, address, delay)
 // Parameters: pB      - pointer to the board structure
 //             address - the purported I/O address of the board

