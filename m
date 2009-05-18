Return-Path: <linux-kernel-owner+w=401wt.eu-S1754125AbZERTOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbZERTOF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 15:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbZERTNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 15:13:54 -0400
Received: from smtp-out.google.com ([216.239.33.17]:39197 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbZERTNy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 15:13:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:content-transfer-encoding:x-system-of-record;
	b=tI+svB5Jk7Q2rcixc/2vHAfA4ZBrimAj5snM2kuNjMatrB/0pGtHhn3mQ4uz7bYzQ
	XKzP/w2T3qGBTOMxa0XrA==
MIME-Version: 1.0
Date: Mon, 18 May 2009 12:13:51 -0700
Message-ID: <63a2e74f0905181213r54a2d8b2tb7dcecd177d474c2@mail.gmail.com>
Subject: [PATCH] Doc fix: ext2 can only have 32,000 subdirs, not 32,768.
From: Michael Shields <mshields@google.com>
To: rdunlap@xenotime.net, linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext2.txt says that dirs can have 32,768 subdirs, but the actual value
of EXT2_LINK_MAX is 32000.
ext3 is the same, but the doc does not mention it.  One of ext4's
features is to "fix 32000 subdirectory limit".

--- linux-2.6.29.3/Documentation/filesystems/ext2.txt.orig 2009-05-08
15:47:21.000000000 -0700
+++ linux-2.6.29.3/Documentation/filesystems/ext2.txt 2009-05-18
12:03:58.000000000 -0700
@@ -322,7 +322,7 @@ an upper limit on the block size imposed
 so 8kB blocks are only allowed on Alpha systems (and other architectures
 which support larger pages).

-There is an upper limit of 32768 subdirectories in a single directory.
+There is an upper limit of 32000 subdirectories in a single directory.

 There is a "soft" upper limit of about 10-15k files in a single directory
 with the current linear linked-list directory implementation.  This limit
