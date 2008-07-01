Return-Path: <linux-kernel-owner+w=401wt.eu-S1758505AbYGAUNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758505AbYGAUNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 16:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755367AbYGAUNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 16:13:13 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:34744 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260AbYGAUNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 16:13:12 -0400
Date: Tue, 1 Jul 2008 13:13:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>, Franck Bui-Huu <fbuihuu@gmail.com>,
       Josh Triplett <josh@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Subject: Re: [PATCH] Introduce rculist.h
Message-ID: <20080701201306.GF7488@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080701125607.c5295759.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701125607.c5295759.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 12:56:07PM +1000, Stephen Rothwell wrote:
> In linux-next there is a commit ("rcu: split list.h and move rcu-protected
> lists into rculist.h") that moved the rcu related list iterators from
> list.h to rculist.h.  Add a trivial version of the file now so that
> various subsystem trees can start using it now for -next changes and so
> reduce the build errors caused by adding uses of the moved functions.

Works for me!

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Cc: Franck Bui-Huu <fbuihuu@gmail.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Josh Triplett <josh@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  include/linux/rculist.h |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>  create mode 100644 include/linux/rculist.h
> 
> Linus, would you consider patches like this for 2.6.26 that have no
> effect on the current tree but help with conflicts in various subsystems
> during the next merge window?  I already have three build fixups for this
> one in particular.
> 
> diff --git a/include/linux/rculist.h b/include/linux/rculist.h
> new file mode 100644
> index 0000000..bde4586
> --- /dev/null
> +++ b/include/linux/rculist.h
> @@ -0,0 +1,6 @@
> +#ifndef _LINUX_RCULIST_H
> +#define _LINUX_RCULIST_H
> +
> +#include <linux/list.h>
> +
> +#endif	/* _LINUX_RCULIST_H */
> -- 
> 1.5.6
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
