Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbYKOEMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbYKOEMf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 23:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbYKOEM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 23:12:26 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42177 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbYKOEMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 23:12:25 -0500
Date: Sat, 15 Nov 2008 13:11:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: Re: mmotm 2008-11-14-17-14 uploaded
Message-Id: <20081115131143.9af8e8aa.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200811150115.mAF1FDpD010853@imap1.linux-foundation.org>
References: <200811150115.mAF1FDpD010853@imap1.linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2008 17:15:12 -0800
akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2008-11-14-17-14 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> It contains the following patches against 2.6.28-rc4:
> 
Sorry..

  CC      arch/x86/kernel/asm-offsets.s
In file included from include/linux/swap.h:8,
                 from include/linux/suspend.h:7,
                 from arch/x86/kernel/asm-offsets_64.c:12,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/memcontrol.h: In function 'mem_cgroup_disabled':
include/linux/memcontrol.h:93: error: 'mem_cgroup_subsys' undeclared (first use in this function)
include/linux/memcontrol.h:93: error: (Each undeclared identifier is reported only once
include/linux/memcontrol.h:93: error: for each function it appears in.)

This is
memcg-add-mem_cgroup_disabled-fix.patch
=


Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: mmotm-2.6.28-Nov14/include/linux/memcontrol.h
===================================================================
--- mmotm-2.6.28-Nov14.orig/include/linux/memcontrol.h
+++ mmotm-2.6.28-Nov14/include/linux/memcontrol.h
@@ -19,7 +19,7 @@
 
 #ifndef _LINUX_MEMCONTROL_H
 #define _LINUX_MEMCONTROL_H
-
+#include <linux/cgroup.h>
 struct mem_cgroup;
 struct page_cgroup;
 struct page;

