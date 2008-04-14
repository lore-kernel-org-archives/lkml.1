Return-Path: <linux-kernel-owner+w=401wt.eu-S1766014AbYDNSRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766014AbYDNSRZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765111AbYDNSOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:14:54 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:57993 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765103AbYDNSOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:14:53 -0400
Date: Mon, 14 Apr 2008 21:13:41 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Christoph Lameter <clameter@sgi.com>
Subject: [2.6 patch] mm/migrate.c should #include <linux/syscalls.h>
Message-ID: <20080414181341.GH6695@cs181133002.pp.htv.fi>
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
 

