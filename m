Return-Path: <linux-kernel-owner+w=401wt.eu-S1759529AbZGHOtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759529AbZGHOtX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 10:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759379AbZGHOsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 10:48:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:52282 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759388AbZGHOsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 10:48:21 -0400
Subject: [PATCH 13/44] includecheck fix: mn10300, sys_mn10300.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 20:14:47 +0530
Message-Id: <1247064287.4382.33.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

includecheck fix: mn10300, sys_mn10300.c

fix the following 'make includecheck' warning:

  arch/mn10300/kernel/sys_mn10300.c: linux/syscalls.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/mn10300/kernel/sys_mn10300.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/mn10300/kernel/sys_mn10300.c b/arch/mn10300/kernel/sys_mn10300.c
index bca5a84..6551ada 100644
--- a/arch/mn10300/kernel/sys_mn10300.c
+++ b/arch/mn10300/kernel/sys_mn10300.c
@@ -21,7 +21,6 @@
 #include <linux/mman.h>
 #include <linux/file.h>
 #include <linux/utsname.h>
-#include <linux/syscalls.h>
 #include <linux/tty.h>
 
 #include <asm/uaccess.h>
-- 
1.6.0.6



