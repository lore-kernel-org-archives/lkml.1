Return-Path: <linux-kernel-owner+w=401wt.eu-S1755724AbYC3Wsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724AbYC3Wsu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 18:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751106AbYC3Wsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 18:48:42 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54021 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbYC3Wsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 18:48:41 -0400
Date: Mon, 31 Mar 2008 01:48:28 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] mm/migrate.c should #include <linux/syscalls.h>
Message-ID: <20080330224828.GP28445@cs181133002.pp.htv.fi>
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

---

This patch has been sent on:
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
 

