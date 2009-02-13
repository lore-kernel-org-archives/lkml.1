Return-Path: <linux-kernel-owner+w=401wt.eu-S1760248AbZBMR0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760248AbZBMR0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 12:26:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750971AbZBMRZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 12:25:50 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:12130 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbZBMRZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 12:25:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=fx2mFOiBt7FIacccDsNX/bTcPiDalPToYW96G/2X3U6o1w+ytgSRvJ8ou/ziSk/1Mf
         n37w3QSpGlg10LbX+IiIY+qbsVomiJy3wHeqT8SkfzX9r+Kd4VSRz6lAZhNBD1LhhJ31
         M17s2skb2z3rxiYE1YMu0FNUBxkYl9BXkA5Vw=
Date: Fri, 13 Feb 2009 22:55:26 +0530
From: Rabin Vincent <rabin@rab.in>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] mmc_test: fix basic read test
Message-ID: <20090213172526.GA1807@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to a typo in the Basic Read test, it's currently identical to the
Basic Write test.  Fix this.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 drivers/mmc/card/mmc_test.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/card/mmc_test.c b/drivers/mmc/card/mmc_test.c
index b92b172..b9f1e84 100644
--- a/drivers/mmc/card/mmc_test.c
+++ b/drivers/mmc/card/mmc_test.c
@@ -494,7 +494,7 @@ static int mmc_test_basic_read(struct mmc_test_card *test)
 
 	sg_init_one(&sg, test->buffer, 512);
 
-	ret = mmc_test_simple_transfer(test, &sg, 1, 0, 1, 512, 1);
+	ret = mmc_test_simple_transfer(test, &sg, 1, 0, 1, 512, 0);
 	if (ret)
 		return ret;
 
-- 
1.5.6.5

