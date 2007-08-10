Return-Path: <linux-kernel-owner+w=401wt.eu-S942325AbXHJVL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942325AbXHJVL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 17:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756416AbXHJVLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 17:11:05 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:45171 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S942286AbXHJVLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 17:11:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] sysctl: Remove the cad_pid binary sysctl path
References: <20070809224254.11f42716.akpm@linux-foundation.org>
	<46BC8F71.3070006@googlemail.com> <46BC944F.9020801@googlemail.com>
	<m1fy2rxpje.fsf@ebiederm.dsl.xmission.com>
	<20070810124156.2de9710e.akpm@linux-foundation.org>
	<m1ps1vw1ey.fsf_-_@ebiederm.dsl.xmission.com>
	<m1lkcjw1cc.fsf_-_@ebiederm.dsl.xmission.com>
	<m1hcn7w18w.fsf_-_@ebiederm.dsl.xmission.com>
	<m1d4xvw14e.fsf_-_@ebiederm.dsl.xmission.com>
	<m18x8jw10b.fsf_-_@ebiederm.dsl.xmission.com>
	<m14pj7w0yp.fsf_-_@ebiederm.dsl.xmission.com>
Date: Fri, 10 Aug 2007 15:10:51 -0600
In-Reply-To: <m14pj7w0yp.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Fri, 10 Aug 2007 15:09:50 -0600")
Message-ID: <m1zm0zumck.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


It looks like we inadvertently killed the cad_pid binary sysctl
support when cap_pid  was changed to be a struct pid.  Since
no one has complained just remove the binary path.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/sysctl.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index f18e7ec..6d01497 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -494,7 +494,6 @@ static struct ctl_table kern_table[] = {
 #endif
 #ifdef CONFIG_PROC_SYSCTL
 	{
-		.ctl_name	= KERN_CADPID,
 		.procname	= "cad_pid",
 		.data		= NULL,
 		.maxlen		= sizeof (int),
-- 
1.5.1.1.181.g2de0

