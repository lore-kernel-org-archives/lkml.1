Return-Path: <linux-kernel-owner+w=401wt.eu-S1756612AbYABCv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbYABCv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 21:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbYABCvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 21:51:51 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:50315 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbYABCvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 21:51:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=xIk1G5Fn4iynuRI1HVjiWGwJuLsY+qdFarZ043ZyS1+L5a0bFIEitntU4deEw5jUhOxpINotlsai7zHbP38Uu4TI/6hJ4uBE2QkQEFSU3RL2LInV4IEIM5URSHl+8Kb6+dYG03k8jSJyy/U/6SbuJtvRRpt5LV3kgZX574hFku0=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] Nuke duplicate header from sysctl.c
Date: Wed, 2 Jan 2008 03:46:49 +0100
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
References: <200801020339.00698.jesper.juhl@gmail.com>
In-Reply-To: <200801020339.00698.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801020346.50160.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jesper.juhl@gmail.com>


Don't include linux/security.h twice in kernel/sysctl.c

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 sysctl.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c68f68d..01b12c3 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -37,7 +37,6 @@
 #include <linux/highuid.h>
 #include <linux/writeback.h>
 #include <linux/hugetlb.h>
-#include <linux/security.h>
 #include <linux/initrd.h>
 #include <linux/times.h>
 #include <linux/limits.h>
