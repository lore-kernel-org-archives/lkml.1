Return-Path: <linux-kernel-owner+w=401wt.eu-S1763967AbYFFQnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763967AbYFFQnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 12:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbYFFQnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 12:43:32 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60685 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751173AbYFFQnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 12:43:32 -0400
Date: Fri, 6 Jun 2008 11:43:31 -0500
From: Dean Nelson <dcn@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 02/18] define xpSalError reason code
Message-ID: <20080606164331.GC13695@sgi.com>
References: <20080606164034.GA13695@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080606164034.GA13695@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define xpSalError reason code.

Signed-off-by: Dean Nelson <dcn@sgi.com>

---

 drivers/misc/sgi-xp/xp.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/misc/sgi-xp/xp.h
===================================================================
--- linux-2.6.orig/drivers/misc/sgi-xp/xp.h	2008-05-01 08:31:32.000000000 -0500
+++ linux-2.6/drivers/misc/sgi-xp/xp.h	2008-05-01 08:54:07.530247696 -0500
@@ -249,8 +249,9 @@ enum xp_retval {
 	xpDisconnected,		/* 51: channel disconnected (closed) */
 
 	xpBteCopyError,		/* 52: bte_copy() returned error */
+	xpSalError,		/* 53: sn SAL error */
 
-	xpUnknownReason		/* 53: unknown reason - must be last in enum */
+	xpUnknownReason		/* 54: unknown reason - must be last in enum */
 };
 
 /*
