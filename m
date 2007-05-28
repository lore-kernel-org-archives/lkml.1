Return-Path: <linux-kernel-owner+w=401wt.eu-S1760286AbXE1BIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760286AbXE1BIt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 21:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754616AbXE1BIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 21:08:42 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:17769 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594AbXE1BIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 21:08:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Mv9hohaNGyJq25bso5YqwpN/aGjwXw7GinJkpEh14vQjyHJ5b3yDS7xhHUBqPguZFT+zc/Qm/OZMRMvJUnQGamhtKZYOUXB2nKG1LUzOzgTNruo5goamzuvu+QQuvSKVLB/M/CI/LROTNvXXisibRtvjHoZ+1K2jqLibm7aTPhY=
Message-ID: <a8e1da0705271808w3a6dc453rfb47dd3db100718@mail.gmail.com>
Date: Mon, 28 May 2007 01:08:41 +0000
From: "young dave" <hidave.darkstar@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: [patch -mm 1/1] remove useless tolower in isofs
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Remove useless tolower in isofs

Signed-off-by: dave young <hidave.darkstar@gmail.com>

 inode.c |    2 +-
 1 file changed, 1 insertions(+), 1 deletions(-)

diff -dur linux/fs/isofs/inode.c linux.new/fs/isofs/inode.c
--- linux/fs/isofs/inode.c      2007-05-28 08:54:33.000000000 +0000
+++ linux.new/fs/isofs/inode.c  2007-05-28 08:55:02.000000000 +0000
@@ -197,7 +197,7 @@
        hash = init_name_hash();
        while (len--) {
                c = tolower(*name++);
-               hash = partial_name_hash(tolower(c), hash);
+               hash = partial_name_hash(c, hash);
        }
        qstr->hash = end_name_hash(hash);

Regards
dave
