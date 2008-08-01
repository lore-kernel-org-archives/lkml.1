Return-Path: <linux-kernel-owner+w=401wt.eu-S1758485AbYHATTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758485AbYHATTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 15:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbYHATTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 15:19:10 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52814 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752935AbYHATTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 15:19:09 -0400
Date: Fri, 1 Aug 2008 14:19:08 -0500
From: Dean Nelson <dcn@sgi.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jack Steiner <steiner@sgi.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] add dependency of CONFIG_SGI_XP upon CONFIG_NET
Message-ID: <20080801191908.GA457@sgi.com>
References: <20080731175854.09ea35c8.sfr@canb.auug.org.au> <20080731223758.b5985dd7.randy.dunlap@oracle.com> <20080801145526.GA29354@sgi.com> <20080801105028.3411f703.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801105028.3411f703.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a dependency of CONFIG_SGI_XP upon CONFIG_NET to Kconfig.

Signed-off-by: Dean Nelson <dcn@sgi.com>

---

 drivers/misc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux/drivers/misc/Kconfig
===================================================================
--- linux.orig/drivers/misc/Kconfig	2008-08-01 09:16:53.000000000 -0500
+++ linux/drivers/misc/Kconfig	2008-08-01 14:02:59.000000000 -0500
@@ -426,6 +426,7 @@ config ENCLOSURE_SERVICES
 
 config SGI_XP
 	tristate "Support communication between SGI SSIs"
+	depends on NET
 	depends on IA64_GENERIC || IA64_SGI_SN2 || IA64_SGI_UV || (X86_64 && SMP)
 	select IA64_UNCACHED_ALLOCATOR if IA64_GENERIC || IA64_SGI_SN2
 	select GENERIC_ALLOCATOR if IA64_GENERIC || IA64_SGI_SN2
