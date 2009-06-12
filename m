Return-Path: <linux-kernel-owner+w=401wt.eu-S1764171AbZFLJ4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764171AbZFLJ4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 05:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764127AbZFLJ4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 05:56:16 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:55880 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933147AbZFLJ4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 05:56:15 -0400
Subject: [PATCH 1/2] kmemleak: Remove the kmemleak.h include in
	drivers/char/vt.c
To: Linus Torvalds <torvalds@linux-foundation.org>
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 12 Jun 2009 10:55:44 +0100
Message-ID: <20090612095544.14809.74717.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <1244800406.26670.29.camel@pc1117.cambridge.arm.com>
References: <1244800406.26670.29.camel@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.385.g1112
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Jun 2009 09:55:45.0247 (UTC) FILETIME=[F46696F0:01C9EB43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file is no longer annotated for false positives but the kmemleak.h
include was still present.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 drivers/char/vt.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index de9ebee..c796a86 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -103,7 +103,6 @@
 #include <linux/io.h>
 #include <asm/system.h>
 #include <linux/uaccess.h>
-#include <linux/kmemleak.h>
 
 #define MAX_NR_CON_DRIVER 16
 

