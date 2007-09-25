Return-Path: <linux-kernel-owner+w=401wt.eu-S1752727AbXIYJVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbXIYJVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 05:21:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbXIYJU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 05:20:57 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51596 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbXIYJU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 05:20:56 -0400
Date: Tue, 25 Sep 2007 10:20:53 +0100
To: Chris Holvenstot <cholvenstot@comcast.net>
Cc: kernel list <linux-kernel@vger.kernel.org>, dwmw2@infradead.org
Subject: Re: Mask Issue?
Message-ID: <20070925092053.GA8076@skynet.ie>
References: <1190242676.16474.6.camel@localhost> <20070924153920.GB32550@skynet.ie> <1190675267.17721.8.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1190675267.17721.8.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (24/09/07 18:07), Chris Holvenstot didst pronounce:
> 
> On Mon, 2007-09-24 at 16:39 +0100, Mel Gorman wrote:
> > On (19/09/07 17:57), Chris Holvenstot didst pronounce:
> > > Still being a little new at this I am not sure if this is an issue at
> > > all or not but I noted that while building the 2.6.23-rc6-git8 kernel
> > > this afternoon I received the following error message: 
> > > 
> > > Building modules, stage 2.
> > >   MODPOST 1670 modules
> > > WARNING: Can't handle masks in drivers/mtd/nand/cafe_nand:FFFF0
> > > 
> > > I have been building each of the kernels in the 2.6.23-rc series and had
> > > not noted this message before.  I apologize if this is a non-issue.
> > > 
> > 
> > I noticed this in a -mm recently and never got around to kicking it
> > properly because I suspected it was a compiler issue. What version
> > of gcc and binutils are you using?
> > 
> > David Woodhouse added to cc in case this is a known problem.
> > 
> 
> Mel - 
> 
> Thank you for the response.  I was a little unsure if this was to
> trivial to report.  
> 

It's never trivial but don't be discouraged if your report appears to
fall between the cracks - it happens from time to time particularly when
the subject is a bit obtuse.

> In any case to answer your question I use version 4.1.2 of GCC and the
> binutils package shows as 2.17.20070103cvs-0ubuntu2
> 

As David says the check will go away in the near future, I reckon it's safe
to ignore the problem (unless David objects) and disable it in your .config
and continue with your testing. As the driver is specific to the One Laptop
Per Child project, I'm guessing you are not affected.

Thanks for testing and reporting.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
