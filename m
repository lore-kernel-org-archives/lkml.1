Return-Path: <linux-kernel-owner+w=401wt.eu-S933383AbXHJBGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933383AbXHJBGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 21:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757682AbXHJBGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 21:06:23 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:44960 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756116AbXHJBGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 21:06:22 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@sw.ru>,
       <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>,
       trond.myklebust@fys.uio.no
Subject: [PATCH 06/10] sysctl: Remove broken sunrpc debug binary sysctls
In-Reply-To: <m1vebo8avf.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Thu, 09 Aug 2007 18:57:24 -0600")
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
	<m1vebo8avf.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
Date: Thu, 09 Aug 2007 19:04:35 -0600
Message-ID: <m18x8k8ajg.fsf_-_@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is debug code so no need to support binary sysctl,
and the binary sysctls as they were written were not
consistent with what showed up in /proc so remove
the binary sysctl support.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 net/sunrpc/sysctl.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/sysctl.c b/net/sunrpc/sysctl.c
index 738db32..864b541 100644
--- a/net/sunrpc/sysctl.c
+++ b/net/sunrpc/sysctl.c
@@ -114,7 +114,6 @@ done:
 
 static ctl_table debug_table[] = {
 	{
-		.ctl_name	= CTL_RPCDEBUG,
 		.procname	= "rpc_debug",
 		.data		= &rpc_debug,
 		.maxlen		= sizeof(int),
@@ -122,7 +121,6 @@ static ctl_table debug_table[] = {
 		.proc_handler	= &proc_dodebug
 	},
 	{
-		.ctl_name	= CTL_NFSDEBUG,
 		.procname	= "nfs_debug",
 		.data		= &nfs_debug,
 		.maxlen		= sizeof(int),
@@ -130,7 +128,6 @@ static ctl_table debug_table[] = {
 		.proc_handler	= &proc_dodebug
 	},
 	{
-		.ctl_name	= CTL_NFSDDEBUG,
 		.procname	= "nfsd_debug",
 		.data		= &nfsd_debug,
 		.maxlen		= sizeof(int),
@@ -138,7 +135,6 @@ static ctl_table debug_table[] = {
 		.proc_handler	= &proc_dodebug
 	},
 	{
-		.ctl_name	= CTL_NLMDEBUG,
 		.procname	= "nlm_debug",
 		.data		= &nlm_debug,
 		.maxlen		= sizeof(int),
-- 
1.5.1.1.181.g2de0

