Return-Path: <linux-kernel-owner+w=401wt.eu-S1756864AbYH1AEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864AbYH1AEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 20:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754833AbYH1AE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 20:04:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44846 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312AbYH1AE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 20:04:28 -0400
Date: Wed, 27 Aug 2008 16:48:49 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>, USB list <linux-usb@vger.kernel.org>,
       Stefan Kopp <stefan_kopp@agilent.com>, Marcel Janssen <korgull@home.nl>,
       Felipe Balbi <me@felipebalbi.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: add USB test and measurement class driver - round
	2
Message-ID: <20080827234849.GD31264@kroah.com>
References: <200808272105.50169.oliver@neukum.org> <Pine.LNX.4.44L0.0808271513270.2138-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.44L0.0808271513270.2138-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 03:16:18PM -0400, Alan Stern wrote:
> On Wed, 27 Aug 2008, Oliver Neukum wrote:
> 
> > Am Mittwoch 27 August 2008 20:58:08 schrieb Alan Stern:
> > > > And this rule depends on sharing the USB major or not. This needs
> > > > a big fat mention in Documentation.
> > > 
> > > You mean that the open/disconnect locking rule applies only to drivers 
> > > that call usb_register_dev, i.e, drivers using the USB major.  Right?
> > 
> > Yes. In fact drivers not using the USB major but their own char devices
> > will need such a lock. This is tricky.
> 
> IMO all char-device registration/deregistration routines should use a 
> similar rwsem.  Then device drivers wouldn't need to worry about it.
> 
> > > I agree that it deserves to be mentioned in the documentation 
> > > somewhere.  Where would be a good place?  None of the existing files in 
> > > Documentation/usb seem appropriate.
> > 
> > The USB major merits a file of its own.
> 
> I don't feel competent to start writing such a file.  Greg, what do you 
> think?  Maybe all that's needed to get going is to "borrow" some of the 
> material in LDD3.  :-)

Well, as the USB chapter in LDD3 "borrowed" heavily from the comments in
the usb code itself, that would only be fair :)

That chapter needs to be reworked.  The authors and Oreilly and I are
currently talking about how to do this all in a framework that makes
sense (the current one of a book every few years that quickly gets out
of date doesn't make sense.)

thanks,

greg k-h
