Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbYJQBvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbYJQBvB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 21:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbYJQBux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 21:50:53 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59491 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbYJQBuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 21:50:52 -0400
Date: Fri, 17 Oct 2008 10:50:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [mmotm][PATCH] memcg-allocate-all-page_cgroup-at-boot-fix.patch
Message-Id: <20081017105028.fac894c0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081017093046.80ae7d14.kamezawa.hiroyu@jp.fujitsu.com>
References: <200810160758.m9G7wZmt018529@imap1.linux-foundation.org>
	<Pine.LNX.4.64.0810161400230.14604@shark.he.net>
	<20081017093046.80ae7d14.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Oct 2008 09:30:46 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> Hmm....it seems
> 
> memcg-allocate-all-page_cgroup-at-boot.patch doesn't includes changes to Makefile...
> 
> Thank you for report. I'll send a fix soon.
> 
This is a fix. for this.

Confirmed vmlinux can be compiled with the config.
(but need to turn off CONFIG_HID_SUPPORT..and found small troube in /samples
 directory's Makefile.

-Kame
==

compile fix to memcg-allocate-all-page_cgroup-at-boot.patch


Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

 mm/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.27/mm/Makefile
===================================================================
--- linux-2.6.27.orig/mm/Makefile
+++ linux-2.6.27/mm/Makefile
@@ -33,5 +33,5 @@ obj-$(CONFIG_FS_XIP) += filemap_xip.o
 obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_SMP) += allocpercpu.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
-obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o
+obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o page_cgroup.o
 obj-$(CONFIG_CGROUP_MEMRLIMIT_CTLR) += memrlimitcgroup.o


