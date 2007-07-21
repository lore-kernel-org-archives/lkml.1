Return-Path: <linux-kernel-owner+w=401wt.eu-S941204AbXGUPPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941204AbXGUPPu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764149AbXGUPEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:04:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:37344 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939476AbXGUPEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:04:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=DYs+WG1Di9mM4kSMI+Zc6oTIJiCuI5BF6soY7bRTkQ35c4PkcXEWXGnYMcc08Ta8FD7/Olj2eP+0MKsrNbQiM11QZEI/9X7Mbeyk2Oq1UbB3yVnTu4d7UbEiyxcQTglLxRNCDmUxOw3Qk2iH4RZkH2wB09+qW0YNen876434UY0=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pedro Roque <roque@di.fc.ul.pt>
Subject: [PATCH][29/37] Clean up duplicate includes in net/ipv6/
Date: Sat, 21 Jul 2007 17:03:44 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       David S Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
       Pekka Savola <pekkas@netcore.fi>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707211703.44971.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch cleans up duplicate includes in
	net/ipv6/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index d67fb1e..db50114 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -56,7 +56,6 @@
 #include <net/inet_ecn.h>
 #include <net/protocol.h>
 #include <net/xfrm.h>
-#include <net/addrconf.h>
 #include <net/snmp.h>
 #include <net/dsfield.h>
 #include <net/timewait_sock.h>
