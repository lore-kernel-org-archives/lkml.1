Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753033AbYLRTNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033AbYLRTNg (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 14:13:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbYLRTN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 14:13:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752006AbYLRTNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 14:13:25 -0500
Date: Thu, 18 Dec 2008 11:12:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sharyathi Nagesh <sharyath@in.ibm.com>
Cc: serge@hallyn.com, linux-kernel@vger.kernel.org, menage@google.com,
        adobriyan@gmail.com, balbir@linux.vnet.ibm.com, risrajak@in.ibm.com
Subject: Re: Error with cgroups: "unused subsystem ns"
Message-Id: <20081218111255.3d95bd1c.akpm@linux-foundation.org>
In-Reply-To: <494A30DA.5030605@in.ibm.com>
References: <4948D3C4.9060900@in.ibm.com>
	<20081218010841.GA17385@hallyn.com>
	<494A30DA.5030605@in.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2008 16:45:38 +0530
Sharyathi Nagesh <sharyath@in.ibm.com> wrote:

> Serge
> > 
> > Resend the patch to lkml.  Assuming you are talking about commit id
> > 93af30a60055a83a00188ae04b88bbd9b4e1489a, go ahead and add my
> > Acked-by.
> Yes it is the same patch. I am attaching the patch for 2.6.28-rc8 let me 
> know: when this can accepted into main line?
> 
> > Converting it to a pr_debug() might be another thing to consider, but
> > I'm not sure anyone wants these messages.
> > 
> > -serge
> 
> Thanks
> Yeehaw
> 
> 
> 
> 
> 
> [unused_subsystem_ns.patch  text/x-diff (667B)]
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> Signed-off-by: Sharyathi Nagesh <sharyathi@in.ibm.com>
> 
> Acked-by: Serge E. Hallyn <serge@hallyn.com>
> -----------------
> 
> 
> Index: linux-2.6.28-rc8/kernel/cgroup.c
> ===================================================================
> --- linux-2.6.28-rc8.orig/kernel/cgroup.c	2008-12-11 04:41:51.000000000 +0530
> +++ linux-2.6.28-rc8/kernel/cgroup.c	2008-12-18 21:55:58.000000000 +0530
> @@ -2934,9 +2934,6 @@
>   again:
>  	root = subsys->root;
>  	if (root == &rootnode) {
> -		printk(KERN_INFO
> -		       "Not cloning cgroup for unused subsystem %s\n",
> -		       subsys->name);
>  		mutex_unlock(&cgroup_mutex);
>  		return 0;
>  	}
> 

I'm unsure waht to make of this.  It has no changelog.  It appears to have
been authored by yourself, although it's unclear why it has Alexey's
signoff as well.
