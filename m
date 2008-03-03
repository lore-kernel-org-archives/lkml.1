Return-Path: <linux-kernel-owner+w=401wt.eu-S1762544AbYCCVVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762544AbYCCVVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758408AbYCCVVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:21:16 -0500
Received: from namei.org ([69.55.235.186]:42077 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759778AbYCCVVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:21:14 -0500
Date: Tue, 4 Mar 2008 08:19:37 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
cc: Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       David Woodhouse <dwmw2@infradead.org>, Paul Moore <paul.moore@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Audit-ML <linux-audit@redhat.com>,
       LSM-ML <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 3/9] Audit: use new LSM hooks instead of SELinux exports
In-Reply-To: <20080301195438.GD19636@ubuntu>
Message-ID: <Xine.LNX.4.64.0803040819260.8529@us.intercode.com.au>
References: <20080301194752.GA19636@ubuntu> <20080301195438.GD19636@ubuntu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Mar 2008, Ahmed S. Darwish wrote:

> Stop using the following exported SELinux interfaces:
> selinux_get_inode_sid(inode, sid)
> selinux_get_ipc_sid(ipcp, sid) 
> selinux_get_task_sid(tsk, sid)
> selinux_sid_to_string(sid, ctx, len)
> kfree(ctx)
> 
> and use following generic LSM equivalents respectively:
> security_inode_getsecid(inode, secid)
> security_ipc_getsecid*(ipcp, secid)
> security_task_getsecid(tsk, secid)
> security_sid_to_secctx(sid, ctx, len)
> security_release_secctx(ctx, len)
> 
> Call security_release_secctx only if security_secid_to_secctx
> succeeded.
> 
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>

Acked-by: James Morris <jmorris@namei.org>


-- 
James Morris
<jmorris@namei.org>
