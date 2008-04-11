Return-Path: <linux-kernel-owner+w=401wt.eu-S1759290AbYDKXWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290AbYDKXWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 19:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755946AbYDKXVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 19:21:53 -0400
Received: from mx1.suse.de ([195.135.220.2]:42701 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755879AbYDKXVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 19:21:52 -0400
Date: Fri, 11 Apr 2008 16:06:07 -0700
From: Greg KH <gregkh@suse.de>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Greg KH <greg@kroah.com>, Uwe Kleine-K?nig <Uwe.Kleine-Koenig@digi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4 v2] [RFC] UIO: generic platform driver
Message-ID: <20080411230607.GA12543@suse.de>
References: <1207831023-8583-2-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-3-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-4-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-5-git-send-email-Uwe.Kleine-Koenig@digi.com> <20080410224804.GI3193@local> <20080411062106.GA18096@digi.com> <20080411092158.GB31625@digi.com> <20080411104835.GB19973@digi.com> <20080411214134.GC32522@kroah.com> <20080411225401.GN3185@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080411225401.GN3185@local>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2008 at 12:54:02AM +0200, Hans J. Koch wrote:
> On Fri, Apr 11, 2008 at 02:41:34PM -0700, Greg KH wrote:
> > On Fri, Apr 11, 2008 at 12:48:35PM +0200, Uwe Kleine-K?nig wrote:
> > > Hello,
> > > 
> > > Uwe Kleine-K?nig wrote:
> > > > +			dev_warn(&pdev->dev, "device has more than "
> > > > +					stringify(MAX_UIO_MAPS)
> > > This must read __stringify(MAX_UIO_MAPS).  Sorry, I didn't compile test
> > > that.
> > 
> > Care to send the latest version of this, I'm a bit lost as to what
> > people want me to apply...
> 
> Hi Greg,
> PATCH 4/4 still has a problem. It uses some clock framework functions
> not available on every architecture. E.g. on x86_64 you can select this
> driver in menuconfig, but it won't compile.
> 
> The first three patches are OK in my opinion. Uwe provided a second
> version of PATCH 1/4, PATCH 2/4 and PATCH 3/4 were alright in their
> original version. I added my Signed-off-by to 1-3, but not to 4.

Ok, I grabbed patch 1, 2 and 3 are already in my tree and -mm :)

Let me know if you all come to an agreement on patch 4.

thanks,

greg k-h
