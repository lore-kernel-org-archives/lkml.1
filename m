Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbYJKMCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbYJKMCS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 08:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbYJKMCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 08:02:01 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:36182 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbYJKMCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 08:02:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=tQCQop7Pb2fYatSIzZKi44T6SLD/2CWjDOgfByU6QgbEaoOxnZdBuBXj0QXQ0/Mwdv
         QH0Z7d1urof+XEGddITkU1Ro4zJlcbeRwXL7QdY2Lo8FpgawqC1JB3ocoNdKV41SGONh
         1RVKgT+BZaVWnbxXHTEdMSqmSezfb+d5SvfC0=
Date: Sat, 11 Oct 2008 14:01:37 +0200
To: Robert Hancock <hancockr@shaw.ca>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] ide: locking improvements
Message-ID: <20081011120137.GA26835@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Robert Hancock <hancockr@shaw.ca>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Jens Axboe <jens.axboe@oracle.com>, linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <fa.Ke90oacfRjgiI4x5LejzjssRBEg@ifi.uio.no> <fa.8TkQ+xA96EhlNKL9gIbVTxVrcUE@ifi.uio.no> <48F010AB.7010009@shaw.ca> <200810111339.44998.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810111339.44998.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Oct 11, 2008 at 01:39:44PM +0200, Bartlomiej Zolnierkiewicz wrote:
> On Saturday 11 October 2008, Robert Hancock wrote:
> > Bartlomiej Zolnierkiewicz wrote:
> > >> Sorry, but I just have to ask 'why'? IDE is seeing a whole lot of churn
> > >> for something that should essentially be a stable code base in
> > >> maintenance mode, and now scalability improvements?
> > > 
> > > It is the stable code but being in "maintenance only mode" has never
> > > been true and as long as there are active users & developers there is
> > > really no reason to change it.
> > 
> > Are there really many active users at this point? I'm not aware of any 
> > new distributions that are using it. The only people I can see that 
> > might still want to be using it would be people with old setups or old 
> > embedded devices.. many of those wouldn't be using newer kernels anyway.
> 
> Like I said before: as long as there are any active users/developers
> there is no real reason to stop IDE improvements (especially since there
> is no complete replacement available).

... and to be completely clear on things, what Bart and other guys are doing
_is_ maintenance - simply keeping the codebase from becoming a big stinking pile
of sh*t which noone can maintain with time. If you do the effort and count what
percentage of the patches have "There should be no functional change resulting
from this patch" in them you'll see that this is the majority and they rather
clean up/simplify/fix code than add anything new, not even mentioning new
features. So yes, this _is_ maintenance on a larger scale and this is a good(tm)
thing.

> I also wouldn't worry that much about what some distros are doing.  They
> are free to make their own decisions based on whatever criteria they like.
> 
> > These kinds of changes only will really help scalability on multi-core 
> > machines which are unlikely to be using this code anyway.. They seem 
> 
> >From my perspective the main gain of these patches is the increased
> maintainability and sanity of the code, scalability improvements are
> just an added bonus.

and better code/improved scalability is a bad thing because... ?!

> > rather like putting makeup on a corpse to me..

so _NOT_ true.

-- 
Regards/Gruss,
    Boris.
