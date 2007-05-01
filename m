Return-Path: <linux-kernel-owner+w=401wt.eu-S1946502AbXEAD6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946502AbXEAD6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 23:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946504AbXEAD6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 23:58:37 -0400
Received: from mx1.suse.de ([195.135.220.2]:60967 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933510AbXEAD63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:58:29 -0400
From: Andi Kleen <ak@suse.de>
References: <20070501557.815359000@suse.de>
In-Reply-To: <20070501557.815359000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [29/30] x86_64: Don't exclude asm-offsets.c in Documentation/dontdiff
Message-Id: <20070501035828.1372713CAF@wotan.suse.de>
Date: Tue,  1 May 2007 05:58:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


asm-offsets.c is valid source code and needs to be diffed.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 Documentation/dontdiff |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/Documentation/dontdiff
===================================================================
--- linux.orig/Documentation/dontdiff
+++ linux/Documentation/dontdiff
@@ -55,8 +55,8 @@ aic7*seq.h*
 aicasm
 aicdb.h*
 asm
-asm-offsets.*
-asm_offsets.*
+asm-offsets.h
+asm_offsets.h
 autoconf.h*
 bbootsect
 bin2c
