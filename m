Return-Path: <linux-kernel-owner+w=401wt.eu-S1757240AbXJOFl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240AbXJOFl7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 01:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbXJOFlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 01:41:49 -0400
Received: from ozlabs.org ([203.10.76.45]:53556 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbXJOFls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 01:41:48 -0400
Date: Mon, 15 Oct 2007 00:40:34 -0500
From: Anton Blanchard <anton@samba.org>
To: rt2400-devel@lists.sourceforge.net
Cc: arjan@linux.intel.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: [PATCH] jiffies_round -> jiffies_round_relative conversion - rt2x00
Message-ID: <20071015054034.GC3257@kryten>
References: <20071015053428.GA3257@kryten> <20071015053801.GB3257@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071015053801.GB3257@kryten>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When rounding a relative timeout we need to use round_jiffies_relative(). 

Signed-off-by: Anton Blanchard <anton@samba.org>
---

diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 298faa9..06d9bc0 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -30,7 +30,7 @@
  * Interval defines
  * Both the link tuner as the rfkill will be called once per second.
  */
-#define LINK_TUNE_INTERVAL	( round_jiffies(HZ) )
+#define LINK_TUNE_INTERVAL	( round_jiffies_relative(HZ) )
 #define RFKILL_POLL_INTERVAL	( 1000 )
 
 /*
