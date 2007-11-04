Return-Path: <linux-kernel-owner+w=401wt.eu-S1760199AbXKDPIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760199AbXKDPIs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 10:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756485AbXKDPIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 10:08:39 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:2386 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242AbXKDPIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 10:08:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=mvwnw5oajIthsRJ697Q/rLdfuDIDUQwVc6pD4SZOAxAvf5x7RRuQ9wWELqKmT8c5c9Bsa8EavOAfznxu7TAk61RROio17gDJ60uvq3YTVmdWJdJwN9O5L1gH3b0N8W8iu4EXoe943c7ayfsnGPsuXLULBpPVqQtFx6BCyLD7rAs=
Message-ID: <e5bfff550711040708t21583f6w19ad6433726496ee@mail.gmail.com>
Date: Sun, 4 Nov 2007 16:08:37 +0100
From: "Marco Costalba" <mcostalba@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] Remove a duplicated include in jffs2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marco Costalba <mcostalba@gmail.com>
---
 fs/jffs2/compr_rubin.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/jffs2/compr_rubin.c b/fs/jffs2/compr_rubin.c
index c73fa89..6584eb3 100644
--- a/fs/jffs2/compr_rubin.c
+++ b/fs/jffs2/compr_rubin.c
@@ -24,8 +24,6 @@
 #define BIT_DIVIDER_MIPS 1043
 static int bits_mips[8] = { 277,249,290,267,229,341,212,241}; /* mips32 */

-#include <linux/errno.h>
-
 struct pushpull {
 	unsigned char *buf;
 	unsigned int buflen;
-- 
1.5.3.5.532.g5c38-dirty
