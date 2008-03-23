Return-Path: <linux-kernel-owner+w=401wt.eu-S1760739AbYCWINi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760739AbYCWINi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758908AbYCWIIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:08:09 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2242 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758394AbYCWIIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:08:07 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/148] include/asm-x86: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:01:35 -0700
Message-Id: <1206259443-13210-1-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup to standardize formatting of .h files

Checkpatch now reports "mostly" clean.

Checkpatch reports errors and warnings that are inappropriate for
asm files.

Ingo's code-quality script totals for include/asm-x86

         Errors      LOC
Before:    1457    31320
After:      252    31729

Changes:

s/__asm__/asm/g
s/__volatile__/volatile/g
s/__inline__/inline/g
80 columns
no spaces before casts
do {} while macro formatting

No objdump -D code changes in x86 defconfig and allyesconfig

There are __LINE__, __DATE__, and __TIME__ changes
in the objects, but no code changes as far I can tell.


