Return-Path: <linux-kernel-owner+w=401wt.eu-S934534AbYCEBSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934534AbYCEBSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 20:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934356AbYCEBRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 20:17:45 -0500
Received: from el-out-1112.google.com ([209.85.162.176]:6506 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934340AbYCEBRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 20:17:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=IpV+HviqCYKfZOMYR6LQj9H2hmoqm4Tyv/vMZ/2y4eCMzo6ccFlDUTItB7oD5B2qzj52+1gLPpb44+FfsqSi11Igu0zoJPJIFoJrTwLH8X9NfcK74ZFHC/0YQw36/1x6xGfjLDmIEiyxb7hi8FlmPytz0paqCQIJNRaVI+MKq/0=
Subject: [PATCH 3/9] isdn: replace __inline with inline
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 17:17:17 -0800
Message-Id: <1204679837.5698.69.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/isdn/i4l/isdn_common.c |    4 ++--
 drivers/isdn/i4l/isdn_v110.c   |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/i4l/isdn_common.c b/drivers/isdn/i4l/isdn_common.c
index 9cef6fc..d4ad699 100644
--- a/drivers/isdn/i4l/isdn_common.c
+++ b/drivers/isdn/i4l/isdn_common.c
@@ -981,13 +981,13 @@ isdn_readbchan_tty(int di, int channel, struct tty_struct *tty, int cisco_hack)
 }
 

-static __inline int
+static inline int
 isdn_minor2drv(int minor)
 {
 	return (dev->drvmap[minor]);
 }
 
-static __inline int
+static inline int
 isdn_minor2chan(int minor)
 {
 	return (dev->chanmap[minor]);
diff --git a/drivers/isdn/i4l/isdn_v110.c b/drivers/isdn/i4l/isdn_v110.c
index 5484d3c..c5d02b6 100644
--- a/drivers/isdn/i4l/isdn_v110.c
+++ b/drivers/isdn/i4l/isdn_v110.c
@@ -62,7 +62,7 @@ static unsigned char V110_OffMatrix_38400[] =
  * and to 67452301 when keylen = 2. This is necessary because ordering on
  * the isdn line is the other way.
  */
-static __inline unsigned char
+static inline unsigned char
 FlipBits(unsigned char c, int keylen)
 {
 	unsigned char b = c;
-- 
1.5.4.3.500.g83a2c


