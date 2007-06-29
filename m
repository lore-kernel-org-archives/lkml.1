Return-Path: <linux-kernel-owner+w=401wt.eu-S1753564AbXF2TY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbXF2TY0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 15:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbXF2TYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 15:24:17 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:35169 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbXF2TYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 15:24:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=MJ4CX+JggPobBWw2l+PVoHRYBlve/3UkrTBTlULfwI5sYJZFE4k9aE39vOEIyyoNPjPT+nyBqzcCqefpLRT+zkVrOxEUxN+ODOE4Oa8V+BGv7nQ5XJqYuo3IrVOS/5Ht82EjJqPe/sscUgJJiqXDAjL5e+Tj0tO1lNH5oBqRak8=
Date: Fri, 29 Jun 2007 23:22:09 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH] UDF: fix function name from udf_crc16 to udf_crc
Message-ID: <20070629192209.GA6519@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We have to change udf_crc16() name to udf_crc()
to be able to play with CRC test.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

 fs/udf/crc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/udf/crc.c b/fs/udf/crc.c
index 490aebe..85aaee5 100644
--- a/fs/udf/crc.c
+++ b/fs/udf/crc.c
@@ -105,8 +105,8 @@ int main(void)
 {
 	unsigned short x;
 
-	x = udf_crc16(bytes, sizeof bytes);
-	printf("udf_crc16: calculated = %4.4x, correct = %4.4x\n", x, 0x3299U);
+	x = udf_crc(bytes, sizeof bytes);
+	printf("udf_crc: calculated = %4.4x, correct = %4.4x\n", x, 0x3299U);
 
 	return 0;
 }

