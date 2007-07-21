Return-Path: <linux-kernel-owner+w=401wt.eu-S941126AbXGUPOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941126AbXGUPOs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939486AbXGUPEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:04:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:37344 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939243AbXGUPEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:04:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=Mc/UdL063fKWtDjZCf35NWcQwtpqQJVt6SfB21Ouc1IG5S3/j/7j5QGdeBQ1ZBNp0EbeX8s1VXleRd8SHGv3vvJjzFIFfDAJFw2EICGs5dUTbzbp3ERVakdiMMJaFtCQk24HUvuIrRhAo+sOLCZkKBWa8ZpX0pt4pKZb+uAe6o0=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][26/37] Clean up duplicate includes in net/atm/
Date: Sat, 21 Jul 2007 17:03:34 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, netdev@vger.kernel.org,
       Marko Kiiskila <mkiiskila@yahoo.com>,
       Chas Williams <chas@cmf.nrl.navy.mil>,
       David S Miller <davem@davemloft.net>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707211703.34580.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch cleans up duplicate includes in
	net/atm/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/net/atm/lec.c b/net/atm/lec.c
index 2770fb4..59d5aa3 100644
--- a/net/atm/lec.c
+++ b/net/atm/lec.c
@@ -21,7 +21,6 @@
 #include <net/dst.h>
 #include <linux/proc_fs.h>
 #include <linux/spinlock.h>
-#include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 
 /* TokenRing if needed */
