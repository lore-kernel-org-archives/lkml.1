Return-Path: <linux-kernel-owner+w=401wt.eu-S1756489AbYE2SV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489AbYE2SV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbYE2ST5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:19:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756644AbYE2STz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:19:55 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 5/6] Werror: Remove the packed attribute from PofTimStamp_tag
	in the hysdn driver
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, bunk@kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 29 May 2008 19:17:46 +0100
Message-ID: <20080529181746.5396.60932.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080529181726.5396.79336.stgit@warthog.procyon.org.uk>
References: <20080529181726.5396.79336.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the packed attribute from PofTimStamp_tag in the hysdn driver as the
thing being packed is just an array of chars.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/isdn/hysdn/hysdn_pof.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/isdn/hysdn/hysdn_pof.h b/drivers/isdn/hysdn/hysdn_pof.h
index a368d6c..3a72b90 100644
--- a/drivers/isdn/hysdn/hysdn_pof.h
+++ b/drivers/isdn/hysdn/hysdn_pof.h
@@ -60,7 +60,7 @@ typedef struct PofRecHdr_tag {	/* Pof record header */
 
 typedef struct PofTimeStamp_tag {
 /*00 */ unsigned long UnixTime __attribute__((packed));
-	/*04 */ unsigned char DateTimeText[0x28] __attribute__((packed));
+	/*04 */ unsigned char DateTimeText[0x28];
 	/* =40 */
 /*2C */
 } tPofTimeStamp;

