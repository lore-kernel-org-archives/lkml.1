Return-Path: <linux-kernel-owner+w=401wt.eu-S942214AbXHJVKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942214AbXHJVKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 17:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760490AbXHJVKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 17:10:05 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:45165 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760435AbXHJVKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 17:10:01 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] sysctl: Update sysctl_checks list of binary paths.
References: <20070809224254.11f42716.akpm@linux-foundation.org>
	<46BC8F71.3070006@googlemail.com> <46BC944F.9020801@googlemail.com>
	<m1fy2rxpje.fsf@ebiederm.dsl.xmission.com>
	<20070810124156.2de9710e.akpm@linux-foundation.org>
	<m1ps1vw1ey.fsf_-_@ebiederm.dsl.xmission.com>
	<m1lkcjw1cc.fsf_-_@ebiederm.dsl.xmission.com>
	<m1hcn7w18w.fsf_-_@ebiederm.dsl.xmission.com>
	<m1d4xvw14e.fsf_-_@ebiederm.dsl.xmission.com>
	<m18x8jw10b.fsf_-_@ebiederm.dsl.xmission.com>
Date: Fri, 10 Aug 2007 15:09:50 -0600
In-Reply-To: <m18x8jw10b.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Fri, 10 Aug 2007 15:08:52 -0600")
Message-ID: <m14pj7w0yp.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


In the netfilter code and the ipv6 ipqueue code I have
found two more binary paths that don't conflict with anything.
So this patch adds them to the list of valid sysctl binary
paths.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/sysctl_check.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sysctl_check.c b/kernel/sysctl_check.c
index 930a514..d5e0337 100644
--- a/kernel/sysctl_check.c
+++ b/kernel/sysctl_check.c
@@ -564,6 +564,7 @@ static struct trans_ctl_table trans_net_ipv6_table[] = {
 	{ NET_IPV6_IP6FRAG_TIME,	"ip6frag_time" },
 	{ NET_IPV6_IP6FRAG_SECRET_INTERVAL,	"ip6frag_secret_interval" },
 	{ NET_IPV6_MLD_MAX_MSF,		"mld_max_msf" },
+	{ 2088 /* IPQ_QMAX */,		"ip6_queue_maxlen" },
 	{}
 };
 
@@ -722,6 +723,7 @@ static struct trans_ctl_table trans_net_table[] = {
 	{ NET_LLC,		"llc",		trans_net_llc_table },
 	{ NET_NETFILTER,	"netfilter",	trans_net_netfilter_table },
 	{ NET_DCCP,		"dccp",		trans_net_dccp_table },
+	{ 2089,			"nf_conntrack_max" },
 	{}
 };
 
-- 
1.5.1.1.181.g2de0

