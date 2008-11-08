Return-Path: <linux-kernel-owner+w=401wt.eu-S1754177AbYKHIoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbYKHIoA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 03:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbYKHInv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 03:43:51 -0500
Received: from ti-out-0910.google.com ([209.85.142.185]:49132 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbYKHInu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 03:43:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=Ygczftm2tbEXvKkR4os9CDZ9F7fjFfXXgRN74prtJtBpDMbr3/FDzTQiQSaNBVIt6x
         4Nb7C0wYkfnpIyVs8VlA96fBaqsie6j+G1Ak9yWbkhIVHTaIoSPciKKEB9cdNzVtitL+
         Dik/Q4S6EjLgKD12qb6Z+PXjAoaRvjJTLMllg=
Date: Sat, 8 Nov 2008 16:43:35 +0800
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: rdunlap@xenotime.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] /fs/ncpfs/getopt.c: cleanup keneldoc
Message-ID: <20081108164335.706739d4@ubuntu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no argument named @flag in ncp_getopt(), remove it.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/fs/ncpfs/getopt.c b/fs/ncpfs/getopt.c
index 335b003..0af3349 100644
--- a/fs/ncpfs/getopt.c
+++ b/fs/ncpfs/getopt.c
@@ -16,7 +16,6 @@
  *	@opts: an array of &struct option entries controlling parser operations
  *	@optopt: output; will contain the current option
  *	@optarg: output; will contain the value (if one exists)
- *	@flag: output; may be NULL; should point to a long for or'ing flags
  *	@value: output; may be NULL; will be overwritten with the integer value
  *		of the current argument.
  *
