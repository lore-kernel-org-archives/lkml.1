Return-Path: <linux-kernel-owner+w=401wt.eu-S1759045AbYHZUG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759045AbYHZUG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 16:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbYHZUGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 16:06:19 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:55528 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbYHZUGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 16:06:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=e2nyeI2xWt55EamUv9+SgGewG6ttCRXvkvhS9i/dkyeomV5e8ow5sFJvbTcxi+Jaca
         lGDWfO9SrJkbCkct48B9Zpc6nSsxKwPPRh7WbrP7fLPdDrHvBpINS5UKQDMCHeagd8NX
         l9oP5Er+vSo5PtuOQhoj5MjxkbF4UUynH+eqw=
Subject: [PATCH] char: moxa.c trivial sparse annotation
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 26 Aug 2008 13:06:15 -0700
Message-Id: <1219781175.6069.10.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only use is to pass this to le16_to_cpu, declare as such
drivers/char/moxa.c:548:11: warning: cast to restricted __le16

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/char/moxa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index 5df4003..12d327a 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -513,7 +513,7 @@ static int moxa_real_load_code(struct moxa_board_conf *brd, const void *ptr,
 		size_t len)
 {
 	void __iomem *baseAddr = brd->basemem;
-	const u16 *uptr = ptr;
+	const __le16 *uptr = ptr;
 	size_t wlen, len2, j;
 	unsigned long key, loadbuf, loadlen, checksum, checksum_ok;
 	unsigned int i, retry;
-- 
1.6.0.340.g84854



