Return-Path: <linux-kernel-owner+w=401wt.eu-S1756642AbXG1RcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642AbXG1RcX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 13:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbXG1RcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 13:32:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36349 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754042AbXG1RcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 13:32:14 -0400
Date: Sat, 28 Jul 2007 10:30:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Bob Picco <bob.picco@hp.com>, Andy Whitcroft <apw@shadowen.org>,
       William Irwin <bill.irwin@oracle.com>, Tony Luck <tony.luck@intel.com>
Subject: Re: mm/sparse.c compile error ( Re: 2.6.23-rc1-mm1 )
Message-Id: <20070728103048.24fb782d.akpm@linux-foundation.org>
In-Reply-To: <46AB77CA.1060705@googlemail.com>
References: <20070725040304.111550f4.akpm@linux-foundation.org>
	<46AB77CA.1060705@googlemail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jul 2007 19:07:22 +0200 Gabriel C <nix.or.die@googlemail.com> wrote:

> Hi,
> 
> next randconfig error ( http://194.231.229.228/MM/randconfig-auto-87.mm_sparse.error )
> 
> 
> ...
> 
> mm/sparse.c: In function 'sparse_init':
> mm/sparse.c:482: error: implicit declaration of function 'sparse_early_usemap_alloc'
> mm/sparse.c:482: warning: assignment makes pointer from integer without a cast
> make[1]: *** [mm/sparse.o] Error 1
> make: *** [mm] Error 2
> make: *** Waiting for unfinished jobs....
> 
> ...
> 
> 
> guessing while this patch , but I am not really sure :
> 
> fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
> 

That seems to have been fixed by one of the post-2.6.23-rc1-mm1 patches I merged,
thanks.
