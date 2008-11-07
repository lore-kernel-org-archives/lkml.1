Return-Path: <linux-kernel-owner+w=401wt.eu-S1754089AbYKGCy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbYKGCy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 21:54:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750903AbYKGCyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 21:54:18 -0500
Received: from rv-out-0506.google.com ([209.85.198.235]:58835 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbYKGCyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 21:54:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=c1CIFNuNjjZFflJEVTmj1bpPp0QohalVdnEDV7bonaxQ41IWaaVcOqzC145HmsyCDL
         EKx7I7FiUBoy8V2oF4f3ipqxKD/2wfAn8qJYvEd8P3zSdAQJNwuxGIr80YoBWEYF/kio
         CID56ivyfVU0CQW2HMl5gUcuy54f0jRk7to1g=
Subject: [PATCH] fb: carminefb trivial annotation packing color register
From: Harvey Harrison <harvey.harrison@gmail.com>
To: airlied@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 06 Nov 2008 18:54:14 -0800
Message-Id: <1226026454.11596.3.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/video/carminefb.c:171:41: warning: cast to restricted __be32

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/video/carminefb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/carminefb.c b/drivers/video/carminefb.c
index c9b1913..c7ff3c1 100644
--- a/drivers/video/carminefb.c
+++ b/drivers/video/carminefb.c
@@ -168,7 +168,7 @@ static int carmine_setcolreg(unsigned regno, unsigned red, unsigned green,
 	blue >>= 8;
 	transp >>= 8;
 
-	((u32 *)info->pseudo_palette)[regno] = be32_to_cpu(transp << 24 |
+	((__be32 *)info->pseudo_palette)[regno] = cpu_to_be32(transp << 24 |
 		red << 0 | green << 8 | blue << 16);
 	return 0;
 }
-- 
1.6.0.3.756.gb776d



