Return-Path: <linux-kernel-owner+w=401wt.eu-S1752338AbYJDKJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338AbYJDKJh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 06:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbYJDKJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 06:09:14 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34930 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbYJDKJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 06:09:11 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [mmotm 02/Oct] fix buid error of autodetect_raid()
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20081004190725.CE3E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Sat,  4 Oct 2008 19:09:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch against: mmotm 02 Oct
Applied after: git-fastboot.patch


fix following build error

>  CC      init/do_mounts_md.o
>init/do_mounts_md.c: In function 'autodetect_raid':
>init/do_mounts_md.c:278: error: implicit declaration of function 'msleep'
>make[1]: *** [init/do_mounts_md.o] Error 1
>make: *** [init] Error 2

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Arjan van de Ven <arjan@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>
---
 init/do_mounts_md.c |    1 +
 1 file changed, 1 insertion(+)

Index: b/init/do_mounts_md.c
===================================================================
--- a/init/do_mounts_md.c
+++ b/init/do_mounts_md.c
@@ -1,5 +1,6 @@
 
 #include <linux/raid/md.h>
+#include <linux/delay.h>
 
 #include "do_mounts.h"
 


