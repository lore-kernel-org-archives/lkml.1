Return-Path: <linux-kernel-owner+w=401wt.eu-S1757363AbYJXVoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbYJXVoK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 17:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754739AbYJXVnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 17:43:55 -0400
Received: from kroah.org ([198.145.64.141]:39492 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754680AbYJXVny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 17:43:54 -0400
Date: Fri, 24 Oct 2008 14:30:45 -0700
From: Greg KH <greg@kroah.com>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Mike Isely <isely@pobox.com>, Justin Piszcz <jpiszcz@lucidpixels.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: Bug fix for pvrusb2 driver [was: Re: Kernel 2.6.26.5 ->
	2.6.27.2 [USB REGRESSION] (USB -> D_STATE)]
Message-ID: <20081024213045.GA16003@kroah.com>
References: <Pine.LNX.4.44L0.0810201203530.2719-100000@iolanthe.rowland.org> <Pine.LNX.4.64.0810201134400.12643@cnc.isely.net> <20081020172914.GA9624@kroah.com> <Pine.LNX.4.64.0810231114320.1475@cnc.isely.net> <20081023191543.GA10017@kroah.com> <Pine.LNX.4.64.0810231451080.1475@cnc.isely.net> <37219a840810231504r6a1d7c1eu5b2b05a6258a3597@mail.gmail.com> <alpine.DEB.1.10.0810231810480.16804@p34.internal.lan> <Pine.LNX.4.64.0810240043000.5947@cnc.isely.net> <37219a840810240829jab70eder1e9172e2a1cfcbdd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37219a840810240829jab70eder1e9172e2a1cfcbdd@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 11:29:36AM -0400, Michael Krufky wrote:
> On Fri, Oct 24, 2008 at 1:43 AM, Mike Isely <isely@isely.net> wrote:
> > On Thu, 23 Oct 2008, Justin Piszcz wrote:
> >
> >>
> >>
> >> On Thu, 23 Oct 2008, Michael Krufky wrote:
> >>
> >> > On Thu, Oct 23, 2008 at 3:54 PM, Mike Isely <isely@isely.net> wrote:
> >> > > On Thu, 23 Oct 2008, Greg KH wrote:
> >> > >
> >> > > > On Thu, Oct 23, 2008 at 11:27:11AM -0500, Mike Isely wrote:
> >> > > > > On Mon, 20 Oct 2008, Greg KH wrote:
> >> > > > >
> >> > >
> >> > >   [...]
> >> > >
> >> > > > > >
> >> > > > > > Will this patch be sent to the -stable group, to fix this regression
> >> > > > > > in
> >> > > > > > 2.6.27?  Or should they take Alan's fix instead?
> >> > > > > >
> >> > > > >
> >> > > > > Greg:
> >>
> >> [ .. ]
> >>
> >> > The changeset in Linus tree is: c82732a42896364296599b0f73f01c5e3fd781ae
> >> >
> >> > Reviewed-by: Michael Krufky <mkrufky@linuxtv.org>
> >> >
> >> > Please wait on test results from Mike Isely or I confirming that
> >> > digital mode still works properly before queuing this one.
> >> >
> >> > Thanks,
> >> >
> >> > Mike Krufky
> >> >
> >>
> >> I only tested analog here for the 1950 FYI.
> >>
> >> Justin.
> >
> > Analog and digital HVR-1950 operation are unaffected by the reset fix
> > here.  This is safe.
> >
> >  -Mike
> >
> > --
> >
> > Mike Isely
> > isely @ pobox (dot) com
> > PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
> >
> 
> I concur.  This patch is fine for -stable.  (I tested digital myself
> last night / this morning and its fine)
> 
> Greg -- any chance you can slip this in to 2.6.27.4 ?  The driver is
> entirely broken otherwise.

Yes, I will add it right now.

thanks for your persistance.

greg k-h
