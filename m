Return-Path: <linux-kernel-owner+w=401wt.eu-S1422907AbXCGRVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422907AbXCGRVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422927AbXCGRSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:18:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43790 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422909AbXCGRSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:18:15 -0500
Message-Id: <20070307171638.068565670@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:12:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, mingo@elte.hu
Subject: [patch 091/101] lockdep: forward declare struct task_struct
Content-Disposition: inline; filename=lockdep-forward-declare-struct-task_struct.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Heiko Carstens <heiko.carstens@de.ibm.com>

3117df0453828bd045c16244e6f50e5714667a8a causes this:

In file included from arch/s390/kernel/early.c:13:
include/linux/lockdep.h:300: warning:
		"struct task_struct" declared inside parameter list
include/linux/lockdep.h:300:
		warning: its scope is only this definition or
		declaration, which is probably not what you want

Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/lockdep.h |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.20.1.orig/include/linux/lockdep.h
+++ linux-2.6.20.1/include/linux/lockdep.h
@@ -8,6 +8,8 @@
 #ifndef __LINUX_LOCKDEP_H
 #define __LINUX_LOCKDEP_H
 
+struct task_struct;
+
 #ifdef CONFIG_LOCKDEP
 
 #include <linux/linkage.h>

--
