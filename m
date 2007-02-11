Return-Path: <linux-kernel-owner+w=401wt.eu-S1750923AbXBKXMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750923AbXBKXMv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 18:12:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750926AbXBKXMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 18:12:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39343 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbXBKXMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 18:12:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@nigel.suspend2.net
Subject: Re: [PATCH] Re: NAK new drivers without proper power management?
Date: Mon, 12 Feb 2007 00:10:11 +0100
User-Agent: KMail/1.9.5
Cc: Daniel Barkalow <barkalow@iabervon.org>, Willy Tarreau <w@1wt.eu>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.osdl.org>
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no> <200702111953.02229.rjw@sisk.pl> <1171235166.4493.100.camel@nigel.suspend2.net>
In-Reply-To: <1171235166.4493.100.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702120010.13996.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 12 February 2007 00:06, Nigel Cunningham wrote:
> Hi.
> 
> On Sun, 2007-02-11 at 19:53 +0100, Rafael J. Wysocki wrote:
> > > Having drivers explicitly marked as to whether they are safe is a good kernel
> > > feature; what to do if they're not is policy.
> > 
> > That's true, but I assume that the people who opt for doing that are also
> > willing to take part in the review of the drivers. :-)
> 
> Absolutely :)
> 
> > Well, I don't think so.  Let's estimate the number of drivers that define
> > .resume() right now:
> > 
> > $ grep -I -l -r '.resume =' linux-2.6.20/drivers/ | wc
> >     102     102    4169
> 
> I think the '.resume =' doesn't help - some have tabs. I ran '\.resume'
> and got 351.

Ah, good catch.  I have searched for ".resume" only and got 612, but this
is the number of files, not the number of drivers.  And it is not exactly
large. ;-)

> It would be interesting to see how many struct pci_driver etc instances
> lack resume methods.

Yes, I'll try to invent a test.

Greetings,
Rafael
