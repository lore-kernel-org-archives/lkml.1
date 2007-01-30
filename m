Return-Path: <linux-kernel-owner+w=401wt.eu-S1751595AbXA3ViM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595AbXA3ViM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 16:38:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbXA3ViM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 16:38:12 -0500
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:14354 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbXA3ViL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 16:38:11 -0500
X-IronPort-AV: i="4.13,259,1167638400"; 
   d="scan'208"; a="358533889:sNHT47411472"
To: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
X-Message-Flag: Warning: May contain useful information
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>
	<20070130191020.GF20642@kroah.com> <adaodogqpmx.fsf@cisco.com>
	<45BFA087.6020905@garzik.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 30 Jan 2007 13:38:06 -0800
In-Reply-To: <45BFA087.6020905@garzik.org> (Jeff Garzik's message of "Tue, 30 Jan 2007 14:46:15 -0500")
Message-ID: <ada4pq8qjpd.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Jan 2007 21:38:06.0498 (UTC) FILETIME=[EDA33020:01C744B6]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > Well, we can disagree about the majority of drivers.  My feeling is
 > > that most of the drivers that are really used by lots of people get
 > > support beyond just a dump of docs -- in fact often vendors are
 > > maintaining them, eg e1000, tg3, cciss, etc., to pick some running on
 > > the boxes I have around here.
 > 
 > Check your history...  tg3 was written by me and DaveM, and only after
 > years was it picked up by the vendor as their official Linux
 > driver. You have picked an excellent counter-example to your own
 > argument.

OK, fair enough, I forgot about tg3.  But on the other hand, you wrote
it without docs, actually _in spite of_ Broadcom, right?

Which I think makes my point that documentation is neither necessary
nor sufficient for a good Linux driver.  Documentation helps, but if
no one competent cares about the device then the driver won't get
written.  On the other hand, if the device is important enough, the
driver will get written without documentation or vendor support.

 > > OK, but why isn't your army of volunteers fixing them?
 > 
 > Because nobody has hardware for them?

Greg said hardware wasn't necessary...

 > > And I seem to recall there's more SATA chipset documentation than Jeff
 > > Garzik has time to implement support for.
 > 
 > I seriously doubt you can come up with even a single concrete example here.

Sorry, I thought you said there was interesting stuff to do with the
Promise documentation you got.  I guess Nvidia ADMA is pretty much
done now.

 > What experience?  AFAICS, pretty much all modern hardware in use
 > outside of ATI/NVIDIA graphics is supported by Linux.

Sure, popular hardware support is pretty good.  But there are still
pretty serious gaps, for example Ralink wireless drivers are still not
upstream even with the vendor trying to help (and I think Ralink
wireless is a good example of how we can't really keep the promises
Greg is making).

And there's plenty of stuff in-tree with lots of users that's in
pretty dire shape, like ISDN (and the fact that we still
CONFIG_ISDN_I4L).  OK, it's not "modern" but Greg is also promising
that we'll keep everything up-to-date with any upstream kernel
changes, and there's obviously large chunks of the driver tree where
that doesn't happen.

 - R.
