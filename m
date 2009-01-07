Return-Path: <linux-kernel-owner+w=401wt.eu-S1753352AbZAGLUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbZAGLUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 06:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbZAGLUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 06:20:43 -0500
Received: from brick.kernel.dk ([93.163.65.50]:13368 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbZAGLUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 06:20:42 -0500
Date: Wed, 7 Jan 2009 12:19:36 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] block: export SSD/non-rotational queue flag through sysfs
Message-ID: <20090107111936.GL32491@kernel.dk>
References: <200901051952.58029.bzolnier@gmail.com> <20090105185428.GS32491@kernel.dk> <ac3eb2510901051347r6593d0fmd64702b1689716c1@mail.gmail.com> <20090106073515.GY32491@kernel.dk> <4964866D.8010503@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4964866D.8010503@msgid.tls.msk.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07 2009, Michael Tokarev wrote:
> Jens Axboe wrote:
> > On Mon, Jan 05 2009, Kay Sievers wrote:
> >> On Mon, Jan 5, 2009 at 19:54, Jens Axboe <jens.axboe@oracle.com> wrote:
> >>> On Mon, Jan 05 2009, Bartlomiej Zolnierkiewicz wrote:
> >>>> +static struct queue_sysfs_entry queue_nonrot_entry = {
> >>>> +     .attr = {.name = "nonrot", .mode = S_IRUGO | S_IWUSR },
> >>>> +     .show = queue_nonrot_show,
> >>>> +     .store = queue_nonrot_store,
> >>>> +};
> >>>> +
> >>> Lets please use a better name for export reasons, non-rotational is a
> >>> lot better. Nobody will know what nonrot means :-)
> >> What's that negation good for? Can't we just have "rotational", like
> >> we have "removable" and not "non-removable"? :)
> > 
> > Non-rotational is the term typically used, since rotational is the norm
> > (still). So I think the negation actually makes sense in this case :-)
> 
> You used the word "still" yourself.  I mean, in 5 years SSD will be more
> common than rotational media, and "the norm" will be !rotational..
> So let's name them correctly and uniformly from the beginning.. ;)

Not sure I agree with your SSD adoption rate, but that's beside the
point :-)

But I'm inclined to agree with you and Kay after all, lets just call it
'rotational'. I think alternatives like 'cheapseek' are truly horrible,
nobody will know what that means - how cheap is cheap?

I'll fixup the patch.

-- 
Jens Axboe

