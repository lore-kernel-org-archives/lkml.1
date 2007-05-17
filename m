Return-Path: <linux-kernel-owner+w=401wt.eu-S1759351AbXEQRqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351AbXEQRqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 13:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756634AbXEQRqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 13:46:16 -0400
Received: from hu-out-0506.google.com ([72.14.214.230]:43763 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706AbXEQRqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 13:46:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=kg//06rnKvbA8GJD2FI5eHvKTqeoOdAXxX8ipzGV3Mmv1uUnlBnLnZORqMOojbQvfHLnhoBqM4aB1HV6HhALT27BE9Wxw1cteN8g4yQZIGwOgfgKgviVvKZd8OP6cQXREfhxTeIeoJNSX/f54rqQHhRpvs81WYTZkMe3a2OZ5G0=
Date: Thu, 17 May 2007 19:46:10 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.21-mm1 and now 2.6.21-git: SLUB Crashes on boot - crypto?
Message-ID: <20070517174610.GA7486@dreamland.darkstar.lan>
References: <d1af83620705100410n482f4f9h428b7cab5501d963@mail.gmail.com> <20070514173823.GA7137@dreamland.darkstar.lan> <20070515014344.GA8850@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070515014344.GA8850@gondor.apana.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Il Tue, May 15, 2007 at 11:43:44AM +1000, Herbert Xu ha scritto: 
> On Mon, May 14, 2007 at 07:38:23PM +0200, Luca Tettamanti wrote:
> > I'm running git 705962cc (which is a commit after -rc1) and I still see
> > the OOPS on boot. The patch above is already applied though. Note that
> > I'm using the SLAB allocator:
> > 
> > CONFIG_SLAB=y
> > # CONFIG_SLUB is not set
> > # CONFIG_SLOB is not set
> > 
> > 
> > Ending clean XFS mount for filesystem: dm-4
> > BUG: unable to handle kernel paging request at virtual address 6b6b6ceb
> 
> Please send me your .config file.

It seems that build system was confused... I've checked the timestamps
of *.o files and make didn't rebuild anything, but rebuilding after a
'make clean' did "fix" the problem. Sorry for the noise...

Luca
-- 
Mi piace avere amici rispettabili;
Mi piace essere il peggiore della compagnia.
