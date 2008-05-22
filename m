Return-Path: <linux-kernel-owner+w=401wt.eu-S1761422AbYEVWWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761422AbYEVWWI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 18:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756599AbYEVWVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 18:21:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:24421 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974AbYEVWVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 18:21:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=ZkrOj/Uebi2RIZryBRgcrSe0P9xnYpJlfl3IHboqAjQQysu9YhgmTEzmI1MdIc/yZ0+ml5AThB3/hrYjsvviNShKc1EX0LqjmHyOtI2CuVqWNBuYWkIbJl0MvMHTnXT0hNARkTLK07ROp/rR+ZMp1gOlTHO9C+rDjsNE71lsX/8=
Date: Thu, 22 May 2008 19:25:11 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] hrtimer: Remove unused variables in ktime_divns()
Message-ID: <20080522222511.GA30893@Pilar.ictp.trieste.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The variables dns and inc are not used, remove them.

Signed-off-by: Carlos R. Mafra <crmafra@gmail.com>
---
 kernel/hrtimer.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 421be5f..001cac2 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -300,11 +300,10 @@ EXPORT_SYMBOL_GPL(ktime_sub_ns);
  */
 u64 ktime_divns(const ktime_t kt, s64 div)
 {
-	u64 dclc, inc, dns;
+	u64 dclc;
 	int sft = 0;
 
-	dclc = dns = ktime_to_ns(kt);
-	inc = div;
+	dclc = ktime_to_ns(kt);
 	/* Make sure the divisor is less than 2^32: */
 	while (div >> 32) {
 		sft++;
-- 
1.5.5.GIT

