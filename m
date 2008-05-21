Return-Path: <linux-kernel-owner+w=401wt.eu-S936200AbYEUUE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936200AbYEUUE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 16:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765152AbYEUUD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 16:03:59 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:49171 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764990AbYEUUD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 16:03:58 -0400
Date: Wed, 21 May 2008 15:03:47 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Cedric Le Goater <clg@fr.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>, Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH -mm] remove node_ prefix_from ns subsystem
Message-ID: <20080521200347.GA25307@sergelap.austin.ibm.com>
References: <48344409.9090903@fr.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48344409.9090903@fr.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Cedric Le Goater (clg@fr.ibm.com):
> From: Cedric Le Goater <clg@fr.ibm.com>
> 
> This is a slight change in the namespace cgroup subsystem api.
> 
> Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>

I agree that is preferable.

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
>  kernel/cgroup.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: 2.6.26-rc2-mm1/kernel/cgroup.c
> ===================================================================
> --- 2.6.26-rc2-mm1.orig/kernel/cgroup.c
> +++ 2.6.26-rc2-mm1/kernel/cgroup.c
> @@ -2903,7 +2903,7 @@ int cgroup_clone(struct task_struct *tsk
>  	cg = tsk->cgroups;
>  	parent = task_cgroup(tsk, subsys->subsys_id);
> 
> -	snprintf(nodename, MAX_CGROUP_TYPE_NAMELEN, "node_%d", tsk->pid);
> +	snprintf(nodename, MAX_CGROUP_TYPE_NAMELEN, "%d", tsk->pid);
> 
>  	/* Pin the hierarchy */
>  	atomic_inc(&parent->root->sb->s_active);
