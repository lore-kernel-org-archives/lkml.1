Return-Path: <linux-kernel-owner+w=401wt.eu-S1753313AbYDUVhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbYDUVhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 17:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757586AbYDUVcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 17:32:54 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:60462 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757571AbYDUVcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 17:32:54 -0400
Date: Tue, 22 Apr 2008 00:32:23 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Christoph Lameter <clameter@sgi.com>
Subject: [2.6 patch] mm/migrate.c should #include <linux/syscalls.h>
Message-ID: <20080421213223.GR2633@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every file should include the headers containing the externs for its 
global functions (in this case for sys_move_pages()).

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Christoph Lameter <clameter@sgi.com>

---

This patch has been sent on:
- 14 Apr 2008
- 31 Mar 2008
- 22 Feb 2008

5624ee2189a0b767e8e474cdd53d8a536dd8f262 diff --git a/mm/migrate.c b/mm/migrate.c
index a73504f..36e1820 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -30,6 +30,7 @@
 #include <linux/vmalloc.h>
 #include <linux/security.h>
 #include <linux/memcontrol.h>
+#include <linux/syscalls.h>
 
 #include "internal.h"
 

