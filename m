Return-Path: <linux-kernel-owner+w=401wt.eu-S1759162AbYA2EoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759162AbYA2EoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 23:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbYA2EoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 23:44:04 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39039 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523AbYA2EoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 23:44:03 -0500
Date: Mon, 28 Jan 2008 20:48:05 -0800
From: Greg KH <greg@kroah.com>
To: Heikki Orsila <shdl@zakalwe.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Improve Documentation/stable_api_nonsense.txt
Message-ID: <20080129044805.GA1718@kroah.com>
References: <20080128230959.AA1A32BC98@zakalwe.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128230959.AA1A32BC98@zakalwe.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 01:09:59AM +0200, Heikki Orsila wrote:
> * Make a remark about avoiding unnecessary changes in interfaces
> * Improve wording

Well, "improve" is a bit judgemental :)

> @@ -19,7 +19,7 @@ Executive Summary
>  You think you want a stable kernel interface, but you really do not, and
>  you don't even know it.  What you want is a stable running driver, and
>  you get that only if your driver is in the main kernel tree.  You also
> -get lots of other good benefits if your driver is in the main kernel
> +get lots of other benefits if your driver is in the main kernel
>  tree, all of which has made Linux into such a strong, stable, and mature
>  operating system which is the reason you are using it in the first
>  place.

That change is fine.

> @@ -68,11 +68,11 @@ consider the following facts about the Linux kernel:
>      There is no way that binary drivers from one architecture will run
>      on another architecture properly.
>  
> -Now a number of these issues can be addressed by simply compiling your
> -module for the exact specific kernel configuration, using the same exact
> +Now, a number of these issues can be addressed by simply compiling your
> +module for the same kernel configuration, using the same

No, I want to emphasize the word "exact" here.  It has to be the same.

>  C compiler that the kernel was built with.  This is sufficient if you
>  want to provide a module for a specific release version of a specific
> -Linux distribution.  But multiply that single build by the number of
> +Linux distribution. However, multiply that single build by the number of

You messed with the "two space" rule, and changed the word unecessarily
in my opinion.

>  different Linux distributions and the number of different supported
>  releases of the Linux distribution and you quickly have a nightmare of
>  different build options on different releases.  Also realize that each
> @@ -93,7 +93,7 @@ keep a Linux kernel driver that is not in the main kernel tree up to
>  date over time.
>  
>  Linux kernel development is continuous and at a rapid pace, never
> -stopping to slow down.  As such, the kernel developers find bugs in
> +slowing down.  As such, the kernel developers find bugs in

No, they never stop, I say leave it as is.

> @@ -116,7 +116,7 @@ issues:
>  
>  This is in stark contrast to a number of closed source operating systems
>  which have had to maintain their older USB interfaces over time.  This
> -provides the ability for new developers to accidentally use the old
> +has the risk for new developers to accidentally use the old

It's not so much as a "risk" as it is what always seems to happen.  So I
don't like this change either.

> @@ -145,6 +145,10 @@ as small as possible, and that all potential interfaces are tested as
>  well as they can be (unused interfaces are pretty much impossible to
>  test for validity.)
>  
> +Some complain that kernel interfaces change too often for out-of-the-tree
> +modules, but this claim is false. Changing an interface can be delicate work,
> +and it can take significant amount of developer effort. Therefore, interfaces
> +are not changed without a good reason.

No, their claim is a valid one, it's not "false".  However we are not
going to do anything about it, and as such, we don't need this kind of
wording to get people worried about it even more.

So, care to redo the patch?

Also note, there are other translations of this text already, so if you
want to change phrases like this, you might want to cc: those
maintainers as well to get their input.

thanks,

greg k-h
