Return-Path: <linux-kernel-owner+w=401wt.eu-S932525AbXHJA6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525AbXHJA6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 20:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756930AbXHJA6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 20:58:22 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36207 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757047AbXHJA6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 20:58:21 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@sw.ru>,
       <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
Subject: [PATCH 05/10] sysctl: ipv6 route flushing (kill binary path)
References: <20070726164518.GB16937@localhost.sw.ru>
	<m13azbulhf.fsf@ebiederm.dsl.xmission.com>
	<20070727145235.GC6924@localhost.sw.ru>
	<20070806124530.GD6634@localhost.sw.ru>
	<m1tzr8a3ms.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ps1wa3kf.fsf_-_@ebiederm.dsl.xmission.com>
	<m1hcn8a2rq.fsf_-_@ebiederm.dsl.xmission.com>
	<m1d4xw9psl.fsf_-_@ebiederm.dsl.xmission.com>
	<m18x8k9ppv.fsf_-_@ebiederm.dsl.xmission.com>
	<m14pj89pmt.fsf_-_@ebiederm.dsl.xmission.com>
	<m1zm108axi.fsf_-_@ebiederm.dsl.xmission.com>
Date: Thu, 09 Aug 2007 18:57:24 -0600
In-Reply-To: <m1zm108axi.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Thu, 09 Aug 2007 18:56:09 -0600")
Message-ID: <m1vebo8avf.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


We don't preoperly support the sysctl binary path for flushing
the ipv6 routes.  So remove support for a binary path.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 net/ipv6/route.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 55ea80f..0d23a46 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2458,7 +2458,6 @@ int ipv6_sysctl_rtcache_flush(ctl_table *ctl, int write, struct file * filp,
 
 ctl_table ipv6_route_table[] = {
 	{
-		.ctl_name	=	NET_IPV6_ROUTE_FLUSH,
 		.procname	=	"flush",
 		.data		=	&flush_delay,
 		.maxlen		=	sizeof(int),
-- 
1.5.1.1.181.g2de0

