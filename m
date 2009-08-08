Return-Path: <linux-kernel-owner+w=401wt.eu-S1757141AbZHHANl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141AbZHHANl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 20:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756865AbZHHANk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 20:13:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:51561 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756790AbZHHANk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 20:13:40 -0400
Date: Sat, 8 Aug 2009 02:13:36 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Markus Heidelberg <markus.heidelberg@web.de>
Subject: Re: linux-next: manual merge of the trivial tree with the  tree
In-Reply-To: <20090731143912.7a6afdbb.sfr@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.0908080212320.25797@wotan.suse.de>
References: <20090731143912.7a6afdbb.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jul 2009, Stephen Rothwell wrote:

> Today's linux-next merge of the trivial tree got a conflict in
> MAINTAINERS between commit 24725d1ecf26ba05d74c1cc3ae7467b61a900421
> ("MAINTAINERS: Update KERNEL JANITORS") from Linus' tree and commit
> 70301b8cc8a23d57d3e6120c012c86569285efcb ("trivial: update the Kernel
> Janitors' web-page URL") from the trivial tree.
> 
> Just context differences.  I fixed it up (see below) and can carry the
> fix as necessary.
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc MAINTAINERS
> index fa86fd5,354cc16..0000000
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@@ -2912,13 -3374,16 +2912,13 @@@ F:	Makefil
>   F:	scripts/Makefile.*
>   
>   KERNEL JANITORS
>  -P:	Several
>   L:	kernel-janitors@vger.kernel.org
> - W:	http://www.kerneljanitors.org/
> + W:	http://janitor.kernelnewbies.org/
>  -S:	Maintained
>  +S:	Odd fixes
>   
>   KERNEL NFSD, SUNRPC, AND LOCKD SERVERS
>  -P:	J. Bruce Fields
>  -M:	bfields@fieldses.org
>  -P:	Neil Brown
>  -M:	neilb@suse.de
>  +M:	"J. Bruce Fields" <bfields@fieldses.org>
>  +M:	Neil Brown <neilb@suse.de>
>   L:	linux-nfs@vger.kernel.org
>   W:	http://nfs.sourceforge.net/
>   S:	Supported

[ sorry for late reply, have been on vacation, totally offline, for two 
  weeks ]

I have fast-forwarded the 'for-next' branch of trivial tree and fixed the 
conflict, so it should be OK the next time you pull.

Thanks,

-- 
Jiri Kosina
SUSE Labs
