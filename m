Return-Path: <linux-kernel-owner+w=401wt.eu-S1760787AbXFGI4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760787AbXFGI4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 04:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754130AbXFGI43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 04:56:29 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:18098 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbXFGI42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 04:56:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WKk91RC4MJgkg+QPqs+nuDdS3nARFN6bbZ8HYycroXvfcp7ClDQGnEWmSAO+5py46ME39RK5zNOgr40J8W7Fu/+K6gycMxRhbMmxtajM6jEPajmmbbzvBBkRqYR2SrL2j072HpulT5BFxfkoiyhak8vX9WB7owNqtjYP8FvTkUY=
Message-ID: <5d96567b0706070156g7f94c7a3te022b4ea4cb57c74@mail.gmail.com>
Date: Thu, 7 Jun 2007 11:56:27 +0300
From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
To: "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: kmap_atomic in 2.6.20.x
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070606191729.GE4735@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5d96567b0706061003r462c324i733ad3698ac3d90c@mail.gmail.com>
	 <20070606191729.GE4735@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/6/07, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Wed, Jun 06 2007, Raz Ben-Jehuda(caro) wrote:
> > Hello
> >
> > I am running into some problems with kmap_atomic in my driver.
> > My driver copies some pages coming from
> > user space to "kernel space kmalloc'ed memory".
> > I had this code running from 2.6.5 to 2.6.17 without any problems.
> > I have upgraded to 2.6.20.xx and this code fails to kmap_atomic.
> > I am running a uni processor 2 GRAM machine, 32bit.
> >
> > Basically this is code does:
> >
> > get_user_pages(page,...)
> >
> > kmap_atomic(page,KM_USER0);
> > .. copy and stuff
> > kunmap_atomic(page,KM_USER0)
>
> dst = kmap_atomic(page, KM_USER0);
> ...
> kunmap_atomic(dst, KM_USER0);
>
> Note the subtle difference.
>
> --
> Jens Axboe
>
>

hmm..... hammmm....haaaa
again...  many many thanks Jens.
You are correct.

-- 
Raz
