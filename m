Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881AbYKGXpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbYKGXpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 18:45:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbYKGXpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 18:45:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56729 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750903AbYKGXpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 18:45:23 -0500
Date: Fri, 7 Nov 2008 15:44:49 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       stable@kernel.org
Subject: Re: Linux 2.6.27.5
In-Reply-To: <20081107233456.GB5036@kroah.com>
Message-ID: <alpine.LFD.2.00.0811071543370.3468@nehalem.linux-foundation.org>
References: <20081107233437.GA5036@kroah.com> <20081107233456.GB5036@kroah.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 7 Nov 2008, Greg KH wrote:
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 3d9120c..6bfb849 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1286,7 +1286,9 @@ struct task_struct {
>  	atomic_t fs_excl;	/* holding fs exclusive resources */
>  	struct rcu_head rcu;
>  
> -	/*
> +	struct list_head	*scm_work_list;
> +
> +/*
>  	 * cache last used pipe for splice
>  	 */
>  	struct pipe_inode_info *splice_pipe;

You did somethign wrong here when merging that scm_destroy() fix. See the 
badly indented comment start.

		Linus
