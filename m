Return-Path: <linux-kernel-owner+w=401wt.eu-S1760605AbZJMRBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760605AbZJMRBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 13:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760578AbZJMRBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 13:01:42 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:43628 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbZJMRBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 13:01:41 -0400
Date: Tue, 13 Oct 2009 10:00:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, davem@davemloft.net,
       Krzysztof Halasa <khc@pm.waw.pl>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Subject: [PATCH] wan: pci200syn needs capability.h
Message-Id: <20091013100016.3c9bfad7.randy.dunlap@oracle.com>
In-Reply-To: <20091013162312.8b93998b.sfr@canb.auug.org.au>
References: <20091013162312.8b93998b.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4AD4B23F.009F:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Driver is missing header file capability.h:

drivers/net/wan/pci200syn.c:212: error: implicit declaration of function 'capable'
drivers/net/wan/pci200syn.c:212: error: 'CAP_NET_ADMIN' undeclared (first use in this function)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/net/wan/pci200syn.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20091012.orig/drivers/net/wan/pci200syn.c
+++ linux-next-20091012/drivers/net/wan/pci200syn.c
@@ -18,6 +18,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/types.h>
+#include <linux/capability.h>
 #include <linux/fcntl.h>
 #include <linux/in.h>
 #include <linux/string.h>
