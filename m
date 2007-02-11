Return-Path: <linux-kernel-owner+w=401wt.eu-S932815AbXBKNxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815AbXBKNxe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 08:53:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932846AbXBKNxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 08:53:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37158 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932815AbXBKNxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 08:53:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH] Re: NAK new drivers without proper power management?
Date: Sun, 11 Feb 2007 14:50:48 +0100
User-Agent: KMail/1.9.5
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Daniel Barkalow <barkalow@iabervon.org>, nigel@nigel.suspend2.net,
       Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.osdl.org>
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no> <20070211131957.GA6039@srcf.ucam.org> <20070211133710.GB1868@1wt.eu>
In-Reply-To: <20070211133710.GB1868@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702111450.49736.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 11 February 2007 14:37, Willy Tarreau wrote:
> On Sun, Feb 11, 2007 at 01:19:57PM +0000, Matthew Garrett wrote:
> > On Sun, Feb 11, 2007 at 02:09:43PM +0100, Willy Tarreau wrote:
> > 
> > > Then change the PCI layer to do the basic PM only for known compatible
> > > drivers, and modify only the known-compatible drivers to mark them
> > > explicitly compatible. IMHO, it generally is a bad idea to require that
> > > any driver explicitly states what it *does not* support. It's the reason
> > > why users encounter problem on new features with old drivers. For instance,
> > > do you know if the old ISA NE2000 driver breaks suspend ? I don't know,
> > > but I would at least expect it not to support it by default. It's best
> > > to announce what *is* supported and consider everything unimplemented
> > > otherwise explicitly stated.
> > 
> > This ignores the reality of the situation, which is that many drivers 
> > support suspend and resume despite the lack of any explicit 
> > implementation. Changing things so they're flagged as broken when 
> > they're not would be a regression.
> 
> Those which are identified as OK should be flagged OK. Only those for
> which we have no idea should be flagged broken.

I think we don't need to flag the drivers identified as OK.  Let's flag only
the suspicious ones.

Whatever we finally come up with, I'd like to avoid modifying drivers that are
known good.

Greetings,
Rafael
