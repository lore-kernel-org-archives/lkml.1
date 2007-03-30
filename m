Return-Path: <linux-kernel-owner+w=401wt.eu-S933463AbXC3Imm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933463AbXC3Imm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 04:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933464AbXC3Imm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 04:42:42 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:36260 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933460AbXC3Iml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 04:42:41 -0400
Date: Fri, 30 Mar 2007 12:50:30 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       auke-jan.h.kok@intel.com
Subject: 2.6.21-rc5-mm3: fix e1000 compilation
Message-ID: <20070330085029.GA6556@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  CC [M]  drivers/net/e1000/e1000_main.o
drivers/net/e1000/e1000_main.c: In function 'e1000_tso':
drivers/net/e1000/e1000_main.c:2968: error: dereferencing pointer to incomplete type
	...

--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -32,6 +32,8 @@ #include <linux/init.h>
 #include <linux/vmalloc.h>
 #include <linux/pagemap.h>
 #include <linux/netdevice.h>
+#include <linux/tcp.h>
+#include <linux/ipv6.h>
 #include <net/checksum.h>
 #include <net/ip6_checksum.h>
 #include <linux/mii.h>

