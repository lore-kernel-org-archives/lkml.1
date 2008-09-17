Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbYIQIRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbYIQIRy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 04:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbYIQIRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 04:17:46 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35104 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbYIQIRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 04:17:45 -0400
Date: Wed, 17 Sep 2008 17:21:54 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, fmayhar@google.com, adobriyan@gmail.com,
       mingo@elte.hu, oleg@tv-sign.ru, roland@redhat.com, tglx@linutronix.de,
       sds@tycho.nsa.gov
Subject: Re: + itimers-fix-itimer-many-thread-hang.patch added to -mm tree
Message-Id: <20080917172154.b79a7f8c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200809122353.m8CNrCmR011310@imap1.linux-foundation.org>
References: <200809122353.m8CNrCmR011310@imap1.linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2008 16:53:12 -0700
akpm@linux-foundation.org wrote:
> ------------------------------------------------------
> Subject: itimers: fix itimer/many thread hang
> From: Frank Mayhar <fmayhar@google.com>
> 

Just a notification of confliction in the latext mmtom.
- with linux-next

==
Fix build error with selinux(from the change in linux-next.patch) and
patches/itimers-fix-itimer-many-thread-hang.patch


Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


Index: linux-2.6.27-rc6+/security/selinux/hooks.c
===================================================================
--- linux-2.6.27-rc6+.orig/security/selinux/hooks.c
+++ linux-2.6.27-rc6+/security/selinux/hooks.c
@@ -2322,7 +2322,7 @@ static void selinux_bprm_committing_cred
 			 * This will cause RLIMIT_CPU calculations to be
 			 * refigured.
 			 */
-			current->it_prof_expires = jiffies_to_cputime(1);
+			current->signal->it_prof_expires = jiffies_to_cputime(1);
 		}
 	}
 }

