Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872AbZBRAwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbZBRAwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 19:52:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012AbZBRAwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 19:52:35 -0500
Received: from mga10.intel.com ([192.55.52.92]:10583 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754090AbZBRAwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 19:52:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,225,1233561600"; 
   d="scan'208";a="431800186"
Date: Tue, 17 Feb 2009 16:55:52 -0800
From: mark gross <mgross@linux.intel.com>
To: Brian Swetland <swetland@google.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Uli Luckas <u.luckas@road.de>, Igor Stoppa <igor.stoppa@nokia.com>,
       Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090218005552.GD26292@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com> <13B9B4C6EF24D648824FF11BE896716203771DD01B@dlee02.ent.ti.com> <20090216145948.6fea81c3@infradead.org> <200902170019.40599.rjw@sisk.pl> <20090216232329.GA15678@srcf.ucam.org> <20090217142001.GB12378@bulgaria.corp.google.com> <20090217064630.688bf639@infradead.org> <20090217152811.GA12686@bulgaria.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217152811.GA12686@bulgaria.corp.google.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 07:28:11AM -0800, Brian Swetland wrote:
> [Arjan van de Ven <arjan@infradead.org>]
> > On Tue, 17 Feb 2009 06:20:01 -0800
> > Brian Swetland <swetland@google.com> wrote:
> > 
> > > Of course that still doesn't address userspace.  Aggressively going to
> > > suspend lets us compensate for userspace programs that do somewhat
> > > silly things (I agree that it would be best if they didn't but they
> > > do and getting *everyone* to write their userspace code to avoid
> > > spinning or avoid waking up on short-duration timers to poll is a
> > > losing battle).
> > 
> > actually with powertop... on the open source side things are actually
> > won. It took all of 6 months...
> > I don't see that as a valid excuse. In fact, if this kind of solution
> > makes real userspace scheduled timers to be missed then I consider it a
> > serious functionality misfeature.
> 
> While you can't expect the kernel to solve all the problems of
> userspace, here's the broad situation one could end up in
> (note this specific sequence is generic and not based on any one
> specific product experience):
> 
> - carrier deploys a device 
> - carrier agrees to allow installation of arbitrary third party apps
>   without some horrible certification program requiring app authors
>   to jump through hoops, wait ages for approval, etc
> - users rejoice and install all kinds of apps
> - some apps are poorly written and impact battery life
> - users complain to carrier about battery life

Carrier pushes ISV for fix app, and updates that don't suck are
deployed.

Where is the problem?

--mgross

> 
> You will end up with some crappy apps that do really dumb things.
> However, even if they're badly written users may still install and use
> these apps because hey, they do something the user likes.
> 
> >From the Android standpoint, we're trying to balance protecting the
> system from poorly designed apps and somehow letting the user know "hey
> app X is chewing up a lot of power" (work in progress on this).
> 
> While I'd love for every app developer to actively tune their apps for a
> good mobile experience, I am skeptical that this is going to happen.
> 
> Brian
