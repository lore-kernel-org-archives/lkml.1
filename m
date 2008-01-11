Return-Path: <linux-kernel-owner+w=401wt.eu-S1759075AbYAKClP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759075AbYAKClP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 21:41:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885AbYAKCk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 21:40:59 -0500
Received: from hs-out-0708.google.com ([64.233.178.246]:31753 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752521AbYAKCk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 21:40:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tbZ5/mApyrzg8qTeErkFOJ3qC+HixmVeJx4FbbUneqRYmyY+fS71SwDTBBT2wQlmebbJgmlmJ+J61DZcncKzMHfnrORWbum8kF/WJ+zx3vxqh77x2lXGU9EffXZWkDzzdi2Z7zM5a6PFCAqX/Y9HCAXsQtL71zE5D2mkthmrtbA=
Message-ID: <a8e1da0801101840l244047c4o136ee6d71c8f9c45@mail.gmail.com>
Date: Fri, 11 Jan 2008 10:40:57 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
Cc: "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
       a.zummo@towertech.it, peterz@infradead.org, cbou@mail.ru,
       linux-kernel@vger.kernel.org, "David Brownell" <david-b@pacbell.net>,
       krh@redhat.com, stern@rowland.harvard.edu, rtc-linux@googlegroups.com,
       spi-devel-general@lists.sourceforge.net,
       linux1394-devel@lists.sourceforge.net, dwmw2@infradead.org,
       davem@davemloft.net, jarkao2@gmail.com
In-Reply-To: <20080110183917.GA20188@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080107154404.GA10880@suse.de> <20080107172009.GA25943@suse.de>
	 <a8e1da0801072305x3378c195qeb0bb7027030254c@mail.gmail.com>
	 <20080108224837.GA19623@suse.de>
	 <a8e1da0801081732i3677245chef1fda1fea65f7cf@mail.gmail.com>
	 <20080109061316.GA3249@darkstar.te-china.tietoenator.com>
	 <a8e1da0801082237x37d2a56eqee6db19017499dbc@mail.gmail.com>
	 <a8e1da0801082239h198c4d45i5cd7cf183472a166@mail.gmail.com>
	 <20080110094843.GA3014@darkstar.te-china.tietoenator.com>
	 <20080110183917.GA20188@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 11, 2008 2:39 AM, Greg KH <gregkh@suse.de> wrote:
> On Thu, Jan 10, 2008 at 05:48:43PM +0800, Dave Young wrote:
> > The patches are done on my side, please help to check.
>
> Along with all of the other comments from people, I have a few.
>
> > This is the first one of the series about driver core changes.
> > If this one is accepted and there's no other problem I will post the others for maintainer's review (they need your comment and help because I don't know well about the specific driver logic).
> >
> > Thanks a lot in advance.
> > ---
> >
> > 1. convert class semaphore to mutex.
> > 2. add class iterater functions to encapsulate the detail of class devices/children list iterating :
> >       class_for_each_device
> >       class_find_device
> >       class_for_each_child
> >       class_find_child
>
> No, please create 1 patch per type-of-change.
>
> So in this case you would have a series of patches:
>         1) add the class iterator functions
>         2-n) convert the existing places in the kernel using the
>              class->semaphore to use the new iterator functions
>         n+1) convert class semaphore to mutex, which should only touch
>              the driver core

Thanks,  you are quite right. I will do it when I update the patch next time.

>
> That way everything builds along the way, and it's easy to understand
> and review.
>
> Oh, and please start a new thread when you create a new patch like this
> so it doesn't get burried in people's inboxes...

Will do when the new patch available.

>
> thanks,
>
> greg k-h
>
