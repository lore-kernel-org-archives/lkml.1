Return-Path: <linux-kernel-owner+w=401wt.eu-S934482AbYBCAc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934482AbYBCAc2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 19:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763298AbYBCAcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 19:32:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57298 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656AbYBCAcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 19:32:20 -0500
Date: Sat, 2 Feb 2008 16:22:49 -0800
From: Greg KH <greg@kroah.com>
To: Heikki Orsila <shdl@zakalwe.fi>
Cc: linux-kernel@vger.kernel.org, mpm@selenic.com, ak@suse.de,
       m-ikeda@ds.jp.nec.com, zhongyu@18mail.cn, minchan.kim@gmail.com
Subject: Re: [PATCH] Improve Documentation/stable_api_nonsense.txt v2
Message-ID: <20080203002249.GB3453@kroah.com>
References: <20080202144457.653482BC98@zakalwe.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080202144457.653482BC98@zakalwe.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2008 at 04:44:57PM +0200, Heikki Orsila wrote:
> This is version 2 of the patch. Address Gregs, Matts and Andis comments.
> Retain the word "exact" due to request of Greg. Use "the exact
> same" as per "Matt Mackall".
> 
> * Change wording
> * Make a remark about necessary changes in interfaces
> 
> Signed-off-by: Heikki Orsila <heikki.orsila@iki.fi>
> ---
>  Documentation/stable_api_nonsense.txt |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/stable_api_nonsense.txt b/Documentation/stable_api_nonsense.txt
> index 847b342..a7c29ad 100644
> --- a/Documentation/stable_api_nonsense.txt
> +++ b/Documentation/stable_api_nonsense.txt
> @@ -19,7 +19,7 @@ Executive Summary
>  You think you want a stable kernel interface, but you really do not, and
>  you don't even know it.  What you want is a stable running driver, and
>  you get that only if your driver is in the main kernel tree.  You also
> -get lots of other good benefits if your driver is in the main kernel
> +get lots of other benefits if your driver is in the main kernel
>  tree, all of which has made Linux into such a strong, stable, and mature
>  operating system which is the reason you are using it in the first
>  place.

That's fine.

> @@ -69,7 +69,7 @@ consider the following facts about the Linux kernel:
>      on another architecture properly.
>  
>  Now a number of these issues can be addressed by simply compiling your
> -module for the exact specific kernel configuration, using the same exact
> +module for the exact same kernel configuration, using the exact same
>  C compiler that the kernel was built with.  This is sufficient if you
>  want to provide a module for a specific release version of a specific
>  Linux distribution.  But multiply that single build by the number of

fine.

> @@ -116,7 +116,7 @@ issues:
>  
>  This is in stark contrast to a number of closed source operating systems
>  which have had to maintain their older USB interfaces over time.  This
> -provides the ability for new developers to accidentally use the old
> +has the risk for new developers to accidentally use the old
>  interfaces and do things in improper ways, causing the stability of the
>  operating system to suffer.
>  

fine.

> @@ -145,6 +145,10 @@ as small as possible, and that all potential interfaces are tested as
>  well as they can be (unused interfaces are pretty much impossible to
>  test for validity.)
>  
> +However, changing an interface can be delicate work and it can take
> +significant amount of developer effort. Therefore, an interface is
> +not changed unless the change is regarded as very important by the
> +developers.
>  
>  What to do
>  ----------

I still don't understand why you want to add these sentances.  Why are
they needed?  Are people thinking that the kernel developers just
randomly change things just because they are bored and have nothing else
to do at the moment?  Do people think that our changes are gratuitous?

Even so, I don't think this needs to be added, we have already stated
many good reasons why changing apis are necessary and good.  Do need to
add another one?

thanks,

greg k-h
