Return-Path: <linux-kernel-owner+w=401wt.eu-S1758544AbXFNWZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544AbXFNWZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 18:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbXFNWZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 18:25:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53125 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbXFNWZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 18:25:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH -mm 4/7] PM: Remove suspend and resume support from struct device_type
Date: Fri, 15 Jun 2007 00:32:19 +0200
User-Agent: KMail/1.9.5
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <200706131551.51336.rjw@sisk.pl> <d120d5000706140559h10461e50q2f30ff423468676e@mail.gmail.com> <20070614174642.GB10378@kroah.com>
In-Reply-To: <20070614174642.GB10378@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706150032.21103.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 14 June 2007 19:46, Greg KH wrote:
> On Thu, Jun 14, 2007 at 08:59:20AM -0400, Dmitry Torokhov wrote:
> >  On 6/14/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > On Thursday, 14 June 2007 06:10, Dmitry Torokhov wrote:
> > > > On Wednesday 13 June 2007 18:20, Kay Sievers wrote:
> > > > > Dmitry, you added this recently, is this used in any code you plan to
> > > > > merge soon?
> > > > >
> > > >
> > > > Yes, I will need it to implement input device resume (mainly to restore 
> > > LED
> > > > state and repeat rate for keyboards).
> > >
> > > Would that be a big problem to reintroduce it along with the user?
> > >
> > 
> >  Yes because that part is in Greg's domain so I am trying to set
> >  infrastructure up before I can commit my patches into my tree so that
> >  Andrew can safely pull from me into -mm. Greg normally adds such stuff
> >  during merge window so that means if we remove it now we'd need ~2
> >  releases to get it and the user back in.
> 
> Yes, don't worry, I'm not going to remove this as I know you rely on it.

Hm, in that case I'd have to rework the patches 5-7.  Perhaps I should resend
the entire series once again, without the $subject patch?

> Sorry for the delay in getting to these patches, I'm in meetings down in
> CA for the rest of the week...

No big deal. :-)

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
