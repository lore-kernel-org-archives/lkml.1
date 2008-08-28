Return-Path: <linux-kernel-owner+w=401wt.eu-S1757584AbYH1WHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584AbYH1WHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 18:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754291AbYH1WHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 18:07:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60429 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbYH1WHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 18:07:24 -0400
Date: Thu, 28 Aug 2008 13:35:57 -0700
From: Greg KH <greg@kroah.com>
To: Marcel Janssen <korgull@home.nl>
Cc: Marcel Janssen <marcel.janssen@admesy.nl>,
       Stefan Kopp <stefan_kopp@agilent.com>,
       Felipe Balbi <me@felipebalbi.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Fwd: Re: [PATCH] USB: add USB test and measurement class driver
Message-ID: <20080828203557.GB20537@kroah.com>
References: <200808272342.38208.korgull@home.nl> <48B671D4.7090509@admesy.nl> <20080828162109.GC18132@kroah.com> <200808282022.54379.korgull@home.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808282022.54379.korgull@home.nl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 08:22:53PM +0200, Marcel Janssen wrote:
> On Thursday 28 August 2008 18:21:09 Greg KH wrote:
> > On Thu, Aug 28, 2008 at 11:37:24AM +0200, Marcel Janssen wrote:
> > > Hello Greg,
> > >
> > > I've got me a bit confused there :-)
> > >
> > > We currently only use the suspend/resume in our device which works on a
> > > received request from the PC.
> > > Basically sending suspend will make the device enter this mode. When the
> > > PC enters this mode, it's also clear it will send a resume when resuming
> > > from standby. But, how is this supposed to work when the PC is not in
> > > sleep mode.....how will the device wake up ?
> >
> > It should "automatically" wake up if something happens to it.  The USB
> > spec calls this out as to how this should work.  If the devices don't
> > support this, we don't have to add support for it :)
> 
> Actually this is a good point.
> 
> The USB spec mentions that the device should suspend when a constant idle 
> state is detected for more than 3.0ms.
> 
> I either have not seen that happening before or I missed something when 
> writing my firmware. I'll keep an eye on my USB analyzer though :-)
> Although it's a good thing to keep to the spec, I also believe that in the 
> case of a test and measurement device suspending the device may be an 
> unwanted behaviour but perhaps I do misinterpret this part of the spec here.
> 
> Anyway, this is no issue for self-powered devices, which is probably the 
> majority in this class because most test & measurement devices need a good 
> power supply and USB just isn't fit for that unless you're able to make a 
> clean power from that (which is possible of course).
> Our device is both USB and self powered, but when in USB powered mode it will 
> only suspend when the host goes in sleep mode.
> 
> To be honest I would put suspend mode far down on the priority list :-)

Ok, thanks for letting us know, if they are self-powered, this shouldn't
be much of an issue.  Let's focus on getting the current driver working
again :)

thanks,

greg k-h
