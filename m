Return-Path: <linux-kernel-owner+w=401wt.eu-S1422800AbXCGRsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422800AbXCGRsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:48:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422783AbXCGROz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:14:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43051 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422797AbXCGROq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:14:46 -0500
Message-Id: <20070307171309.492884941@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 034/101] Fix atmarp.h for userspace
Content-Disposition: inline; filename=fix-atmarp.h-for-userspace.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: David Miller <davem@davemloft.net>

[ATM]: atmarp.h needs to always include linux/types.h

To provide the __be* types, even for userspace includes.

Reported by Andrew Walrond.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/atmarp.h |    2 --
 1 file changed, 2 deletions(-)

--- linux-2.6.20.1.orig/include/linux/atmarp.h
+++ linux-2.6.20.1/include/linux/atmarp.h
@@ -6,9 +6,7 @@
 #ifndef _LINUX_ATMARP_H
 #define _LINUX_ATMARP_H
 
-#ifdef __KERNEL__
 #include <linux/types.h>
-#endif
 #include <linux/atmapi.h>
 #include <linux/atmioc.h>
 

--
