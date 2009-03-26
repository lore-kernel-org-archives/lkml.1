Return-Path: <linux-kernel-owner+w=401wt.eu-S1760148AbZCZUq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760148AbZCZUq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 16:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755033AbZCZUqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 16:46:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33481 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754190AbZCZUqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 16:46:48 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] dontdiff: Fix asm exclude
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Date: Thu, 26 Mar 2009 20:47:00 +0000
Message-ID: <20090326204654.4720.97362.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the headers are in arch/foo/include/asm we don't want to exclude
them when preparing diff files.

Closes-bug: 12921

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 Documentation/dontdiff |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)


diff --git a/Documentation/dontdiff b/Documentation/dontdiff
index 1e89a51..88519da 100644
--- a/Documentation/dontdiff
+++ b/Documentation/dontdiff
@@ -62,7 +62,6 @@ aic7*reg_print.c*
 aic7*seq.h*
 aicasm
 aicdb.h*
-asm
 asm-offsets.h
 asm_offsets.h
 autoconf.h*

