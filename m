Return-Path: <linux-kernel-owner+w=401wt.eu-S932364AbYBGABa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364AbYBGABa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:01:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764187AbYBFXys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:54:48 -0500
Received: from mail.suse.de ([195.135.220.2]:45256 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764270AbYBFXyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:54:47 -0500
Date: Wed, 6 Feb 2008 15:51:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Patrick Mansfield <patmans@us.ibm.com>,
       Anton Blanchard <anton@samba.org>, Paul Mackerras <paulus@samba.org>
Subject: [patch 15/73] POWERPC: Change fallocate to match unistd.h on
	powerpc
Message-ID: <20080206235131.GP13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="powerpc-change-fallocate-to-match-unistd.h-on-powerpc.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Patrick Mansfield <patmans@us.ibm.com>

patch f2205fbb5a8933514fd343cc329df631802b4543 in mainline.

Fix the fallocate system call on powerpc to match its unistd.h.

This implies none of these system calls are currently working with the
unistd.h sys call values:
	fallocate
	signalfd
	timerfd
	eventfd
	sync_file_range2

Signed-off-by: Patrick Mansfield <patmans@us.ibm.com>
Acked-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/asm-powerpc/systbl.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/asm-powerpc/systbl.h
+++ b/include/asm-powerpc/systbl.h
@@ -308,8 +308,8 @@ COMPAT_SYS_SPU(move_pages)
 SYSCALL_SPU(getcpu)
 COMPAT_SYS(epoll_pwait)
 COMPAT_SYS_SPU(utimensat)
-COMPAT_SYS(fallocate)
 COMPAT_SYS_SPU(signalfd)
 COMPAT_SYS_SPU(timerfd)
 SYSCALL_SPU(eventfd)
 COMPAT_SYS_SPU(sync_file_range2)
+COMPAT_SYS(fallocate)

-- 
