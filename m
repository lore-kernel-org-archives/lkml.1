Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045AbZCUKic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbZCUKic (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 06:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbZCUKiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 06:38:23 -0400
Received: from woodchuck.wormnet.eu ([77.75.105.223]:45037 "EHLO
	woodchuck.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbZCUKiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 06:38:22 -0400
Date: Sat, 21 Mar 2009 10:38:17 +0000
From: Alexander Clouter <alex@digriz.org.uk>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for March 20 - timeriomem build break on s390
Message-ID: <20090321103817.GL22563@woodchuck>
References: <20090320162800.24b0ad93.sfr@canb.auug.org.au> <20090320100901.45ce2e6f@osiris.boeblingen.de.ibm.com> <20090321061922.GA13990@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090321061922.GA13990@gondor.apana.org.au>
Organization: diGriz
X-URL: http://www.digriz.org.uk/
X-JabberID: jimdigriz@jabber.earth.li
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Herbert Xu <herbert@gondor.apana.org.au> [2009-03-21 14:19:22+0800]:
> 
> On Fri, Mar 20, 2009 at 10:09:01AM +0100, Heiko Carstens wrote:
> > 'hwrng: timeriomem' breaks an allyesconfig build on s390:
> > 
> >   CC      drivers/char/hw_random/timeriomem-rng.o
> > drivers/char/hw_random/timeriomem-rng.c: In function 'timeriomem_rng_data_read':
> > drivers/char/hw_random/timeriomem-rng.c:60: error: implicit declaration of function 'readl'
> > 
> > Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Patch applied.  Thanks Heiko!
>
Yes, thanks for catching this.

Cheers

-- 
Alexander Clouter
.sigmonster says: Don't kiss an elephant on the lips today.
