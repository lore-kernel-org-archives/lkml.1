Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbZGMOJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbZGMOJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 10:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756003AbZGMOJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 10:09:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47064 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755997AbZGMOJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 10:09:55 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] mn10300: remove duplicated #include
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>,
       David Howells <dhowells@redhat.com>
Date: Mon, 13 Jul 2009 15:09:25 +0100
Message-ID: <20090713140925.30526.90560.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Weiyi <weiyi.huang@gmail.com>

Remove duplicated #include('s) in
  arch/mn10300/kernel/sys_mn10300.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/kernel/sys_mn10300.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)


diff --git a/arch/mn10300/kernel/sys_mn10300.c b/arch/mn10300/kernel/sys_mn10300.c
index 29d196b..3e52a10 100644
--- a/arch/mn10300/kernel/sys_mn10300.c
+++ b/arch/mn10300/kernel/sys_mn10300.c
@@ -20,7 +20,6 @@
 #include <linux/mman.h>
 #include <linux/file.h>
 #include <linux/utsname.h>
-#include <linux/syscalls.h>
 #include <linux/tty.h>
 
 #include <asm/uaccess.h>

