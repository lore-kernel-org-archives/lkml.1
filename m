Return-Path: <linux-kernel-owner+w=401wt.eu-S1756521AbXLGSMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbXLGSMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 13:12:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbXLGSMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 13:12:00 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3931 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597AbXLGSL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 13:11:59 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>,
       Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] md: balance braces in raid5 debug code
Date: Fri, 7 Dec 2007 19:20:11 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
In-Reply-To: <20071204211701.994dfce6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712071920.13506.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	This patch fixes the compilation breakage. Normally you don't see
that as this piece of code is under #ifdef DEBUG. This was introduced by
git-md-accel.patch at line 3179.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/md/raid5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-rc4-mm1-a/drivers/md/raid5.c	2007-12-06 09:27:02.000000000 +0100
+++ linux-2.6.24-rc4-mm1-b/drivers/md/raid5.c	2007-12-06 09:28:14.000000000 +0100
@@ -4972,7 +4972,7 @@ static void print_sh (struct seq_file *s
 	seq_printf(seq, "sh %llu,  count %d.\n",
 		   (unsigned long long)sh->sector, atomic_read(&sh->count));
 	seq_printf(seq, "sh %llu, ", (unsigned long long)sh->sector);
-	for (i = 0; i < sh->sq->disks; i++) {
+	for (i = 0; i < sh->sq->disks; i++)
 		seq_printf(seq, "(cache%d: %p %ld) ",
 			   i, sh->dev[i].page, sh->dev[i].flags);
 	seq_printf(seq, "\n");


