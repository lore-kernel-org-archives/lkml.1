Return-Path: <linux-kernel-owner+w=401wt.eu-S1757512AbYJXFoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512AbYJXFoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 01:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbYJXFn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 01:43:58 -0400
Received: from cnc.isely.net ([64.81.146.143]:44496 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177AbYJXFn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 01:43:57 -0400
Date: Fri, 24 Oct 2008 00:43:53 -0500 (CDT)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely <isely@pobox.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: Michael Krufky <mkrufky@linuxtv.org>, Greg KH <greg@kroah.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       Mike Isely at pobox <isely@pobox.com>
Subject: Re: Bug fix for pvrusb2 driver [was: Re: Kernel 2.6.26.5 -> 2.6.27.2
 [USB REGRESSION] (USB -> D_STATE)]
In-Reply-To: <alpine.DEB.1.10.0810231810480.16804@p34.internal.lan>
Message-ID: <Pine.LNX.4.64.0810240043000.5947@cnc.isely.net>
References: <Pine.LNX.4.44L0.0810201203530.2719-100000@iolanthe.rowland.org>
  <Pine.LNX.4.64.0810201134400.12643@cnc.isely.net>  <20081020172914.GA9624@kroah.com>
  <Pine.LNX.4.64.0810231114320.1475@cnc.isely.net>  <20081023191543.GA10017@kroah.com>
  <Pine.LNX.4.64.0810231451080.1475@cnc.isely.net>
 <37219a840810231504r6a1d7c1eu5b2b05a6258a3597@mail.gmail.com>
 <alpine.DEB.1.10.0810231810480.16804@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2008, Justin Piszcz wrote:

> 
> 
> On Thu, 23 Oct 2008, Michael Krufky wrote:
> 
> > On Thu, Oct 23, 2008 at 3:54 PM, Mike Isely <isely@isely.net> wrote:
> > > On Thu, 23 Oct 2008, Greg KH wrote:
> > > 
> > > > On Thu, Oct 23, 2008 at 11:27:11AM -0500, Mike Isely wrote:
> > > > > On Mon, 20 Oct 2008, Greg KH wrote:
> > > > > 
> > > 
> > >   [...]
> > > 
> > > > > > 
> > > > > > Will this patch be sent to the -stable group, to fix this regression
> > > > > > in
> > > > > > 2.6.27?  Or should they take Alan's fix instead?
> > > > > > 
> > > > > 
> > > > > Greg:
> 
> [ .. ]
> 
> > The changeset in Linus tree is: c82732a42896364296599b0f73f01c5e3fd781ae
> > 
> > Reviewed-by: Michael Krufky <mkrufky@linuxtv.org>
> > 
> > Please wait on test results from Mike Isely or I confirming that
> > digital mode still works properly before queuing this one.
> > 
> > Thanks,
> > 
> > Mike Krufky
> > 
> 
> I only tested analog here for the 1950 FYI.
> 
> Justin.

Analog and digital HVR-1950 operation are unaffected by the reset fix 
here.  This is safe.

  -Mike

-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
