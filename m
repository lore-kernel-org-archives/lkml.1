Return-Path: <linux-kernel-owner+w=401wt.eu-S1751840AbXA3VsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbXA3VsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 16:48:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbXA3VsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 16:48:14 -0500
Received: from mail.kroah.org ([69.55.234.183]:41659 "EHLO perch.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbXA3VsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 16:48:13 -0500
Date: Tue, 30 Jan 2007 13:47:59 -0800
From: Greg KH <greg@kroah.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Message-ID: <20070130214759.GA12477@kroah.com>
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com> <20070130191020.GF20642@kroah.com> <adaodogqpmx.fsf@cisco.com> <45BFA087.6020905@garzik.org> <ada4pq8qjpd.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada4pq8qjpd.fsf@cisco.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 01:38:06PM -0800, Roland Dreier wrote:
>  > > OK, but why isn't your army of volunteers fixing them?
>  > 
>  > Because nobody has hardware for them?
> 
> Greg said hardware wasn't necessary...

Someone has to have the hardware to test with.  Hence my "debug by
email" comment.

> Sure, popular hardware support is pretty good.  But there are still
> pretty serious gaps, for example Ralink wireless drivers are still not
> upstream even with the vendor trying to help (and I think Ralink
> wireless is a good example of how we can't really keep the promises
> Greg is making).

The Ralink wireless drivers are working to get their stuff upstream.  I
think there is only some wireless infrastructure needed to complete
before it gets into mainline, but you will have to ask them about this.

There was a wireless-mini-summit a week or so ago, so those developers
all know what is going on in that space right now.  They are facing a
number of different regulatory issues, combined with lack of
specifications from some vendors.  I don't think that the developers who
actually have specs are complaining about anything right now.

> And there's plenty of stuff in-tree with lots of users that's in
> pretty dire shape, like ISDN (and the fact that we still
> CONFIG_ISDN_I4L).  OK, it's not "modern" but Greg is also promising
> that we'll keep everything up-to-date with any upstream kernel
> changes, and there's obviously large chunks of the driver tree where
> that doesn't happen.

The ISDN maintainer has a large rewrite almost done, and anyone is
welcome to help him out if they are still using and needing that old
hardware.  As almost no one objects to the current code, I'm guessing
that there is no such real need :)

thanks,

greg k-h
