Return-Path: <linux-kernel-owner+w=401wt.eu-S1760136AbZCOVcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760136AbZCOVcd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 17:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759970AbZCOVcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 17:32:15 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:52399 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759021AbZCOVcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 17:32:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=KGqqCeIeo25Tfvlr+jwjIupvEtBzjMCaOXUFsVIlNpZYrPrr1Y17srnTiTl7de0eHz
         Hghn/akFDl9q3rcjK++aGqP8TAVxy4mK5FAUNAQf2RU2SWVG9T417x0EARCWQMq+J1dz
         fiOusUnSrUciLSLvlNSjsaq6IUrTHScD2e+fs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 11/14] block: implement and use [__]blk_end_request_all()
Date: Sun, 15 Mar 2009 22:34:41 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc7-next-20090311; KDE/4.2.0; i686; ; )
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Russell King <rmk@arm.linux.org.uk>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Mike Miller <mike.miller@hp.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jeff Garzik <jgarzik@pobox.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Alex Dubov <oakad@yahoo.com>
References: <1236920578-2179-1-git-send-email-tj@kernel.org> <200903152134.46385.bzolnier@gmail.com> <20090315204802.GH27476@kernel.dk>
In-Reply-To: <20090315204802.GH27476@kernel.dk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903152234.42274.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 March 2009, Jens Axboe wrote:
> On Sun, Mar 15 2009, Bartlomiej Zolnierkiewicz wrote:
> > > > > > Thanks for the hint but it sounds like a major pain once you hit some
> > > > > > changes touching the same code areas that block patches do...
> > > > > > 
> > > > > > Besides this is guaranteed to inrease the workload on my side so it
> > > > > > won't happen simply because of -ENOTIME.
> > > > > 
> > > > > When things collide, it is more work for everyone. But such is life for
> > > > > middle/core layer changes. Rebasing _really_ should not be a lot of
> > > > > work. And you are going to have to do it sooner or later, either upfront
> > > > > or after your patches stop applying because the block changes went
> > > > > upstream.
> > > > 
> > > > The task of running the secondary tree is not merely rebasing of patches
> > > > (which I already do on a daily basis) as it also involves extra coordination,
> > > > testing, updates etc.
> > > 
> > > Coordination with whom? If people develop off your pata tree, then there
> > > should be no difference.
> > 
> > Coordination between trees.
> > 
> > Moreover people often develop against linux-next (this is perfectly
> > fine with the current development model) which after change would mean
> > that their patches could end up being dependent also on block (more
> > work for me to sort it out).
> 
> And the difference being? The block tree is in -next in the first place.
> This changeset is not yet, since I haven't had time to do testing on it
> yet. But the tested stuff is usually there for each iteration.

pata tree is based on Linus' tree _not_ on linux-next and this is very
handy when it comes to preparing pull requests.

It could be that I worry needlessly but with ~170 patches in the tree
currently, lack of time and merge window around the corner there is
no wonder that I'm reluctant to any experiments.  However I completely
agree that we should look into the ways of improving the process in
the longer-term.

Thanks,
Bart
