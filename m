Return-Path: <linux-kernel-owner+w=401wt.eu-S1757339AbXFNXMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339AbXFNXMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 19:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753845AbXFNXMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 19:12:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46732 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbXFNXMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 19:12:31 -0400
Date: Thu, 14 Jun 2007 16:14:02 -0700
From: Greg KH <greg@kroah.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH -mm 4/7] PM: Remove suspend and resume support from
	struct device_type
Message-ID: <20070614231402.GA6317@kroah.com>
References: <200706131551.51336.rjw@sisk.pl> <d120d5000706140559h10461e50q2f30ff423468676e@mail.gmail.com> <20070614174642.GB10378@kroah.com> <200706150032.21103.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706150032.21103.rjw@sisk.pl>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2007 at 12:32:19AM +0200, Rafael J. Wysocki wrote:
> On Thursday, 14 June 2007 19:46, Greg KH wrote:
> > On Thu, Jun 14, 2007 at 08:59:20AM -0400, Dmitry Torokhov wrote:
> > >  On 6/14/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > On Thursday, 14 June 2007 06:10, Dmitry Torokhov wrote:
> > > > > On Wednesday 13 June 2007 18:20, Kay Sievers wrote:
> > > > > > Dmitry, you added this recently, is this used in any code you plan to
> > > > > > merge soon?
> > > > > >
> > > > >
> > > > > Yes, I will need it to implement input device resume (mainly to restore 
> > > > LED
> > > > > state and repeat rate for keyboards).
> > > >
> > > > Would that be a big problem to reintroduce it along with the user?
> > > >
> > > 
> > >  Yes because that part is in Greg's domain so I am trying to set
> > >  infrastructure up before I can commit my patches into my tree so that
> > >  Andrew can safely pull from me into -mm. Greg normally adds such stuff
> > >  during merge window so that means if we remove it now we'd need ~2
> > >  releases to get it and the user back in.
> > 
> > Yes, don't worry, I'm not going to remove this as I know you rely on it.
> 
> Hm, in that case I'd have to rework the patches 5-7.  Perhaps I should resend
> the entire series once again, without the $subject patch?

Ok, yeah, can you rework those three patches and resend them?  I took
patches 1-3 already.

thanks,

greg k-h
