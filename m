Return-Path: <linux-kernel-owner+w=401wt.eu-S1753112AbZGXPD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbZGXPD5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 11:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbZGXPD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 11:03:56 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:46554 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751854AbZGXPDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 11:03:55 -0400
Subject: [PATCH] Include linux/sched.h in fs/ramfs/file-nommu.c
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Howells <dhowells@redhat.com>
Date: Fri, 24 Jul 2009 16:03:34 +0100
Message-ID: <20090724150334.2559.33065.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.15-rc1-9-gd8846
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jul 2009 15:03:35.0241 (UTC) FILETIME=[EAB98390:01CA0C6F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file makes use of various macros defined in files like
asm/current.h or asm-generic/resource.h. All these files can be included
via sched.h. The building of the !MMU ARM kernel (with additional
patches) fails without this change.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Howells <dhowells@redhat.com>
---
 fs/ramfs/file-nommu.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
index ebb2c41..11f0c06 100644
--- a/fs/ramfs/file-nommu.c
+++ b/fs/ramfs/file-nommu.c
@@ -20,6 +20,7 @@
 #include <linux/ramfs.h>
 #include <linux/pagevec.h>
 #include <linux/mman.h>
+#include <linux/sched.h>
 
 #include <asm/uaccess.h>
 #include "internal.h"

