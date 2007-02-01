Return-Path: <linux-kernel-owner+w=401wt.eu-S932918AbXBAWjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932918AbXBAWjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 17:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932944AbXBAWjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 17:39:40 -0500
Received: from dtp.xs4all.nl ([80.126.206.180]:63118 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932918AbXBAWjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 17:39:39 -0500
Date: Thu, 1 Feb 2007 23:39:35 +0100
From: Erik Mouw <erik@harddisk-recovery.nl>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Jeff Garzik <jeff@garzik.org>, Roland Dreier <rdreier@cisco.com>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Message-ID: <20070201223934.GA32665@harddisk-recovery.nl>
References: <20070130191020.GF20642@kroah.com> <adaodogqpmx.fsf@cisco.com> <45BFA087.6020905@garzik.org> <ada4pq8qjpd.fsf@cisco.com> <20070130214759.GA12477@kroah.com> <adar6tcp43r.fsf@cisco.com> <45BFC2CF.8010603@garzik.org> <20070130222344.GF7584@csclub.uwaterloo.ca> <20070201135903.GE29212@harddisk-recovery.com> <20070201144506.GD7582@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070201144506.GD7582@csclub.uwaterloo.ca>
Organization: Harddisk-recovery.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 09:45:06AM -0500, Lennart Sorensen wrote:
> On Thu, Feb 01, 2007 at 02:59:03PM +0100, Erik Mouw wrote:
> > I can't remember that kind of corruption ever being reported to the
> > bcm43xx-dev mailing list.
> 
> Well I assumed it messed up the eeprom settings, since we had to go into
> the advanced driver settings and change it from 802.11b only back to
> auto mode and I would think those settings are stored in the eeprom if
> booting a 2.6.18 kernel and loading the bcm43xx driver can cause it to
> stop working, then it has to be an eeprom setting.
> 
> Actually I suppose the other posibility is that you simply have to power
> cycle before booting windows after linux to avoid any left over settings
> in the chip from being a problem.  That may be what I did.  Given I
> couldn't get the card to connect using the bcm43xx driver anyhow, I
> didn't spend too much time trying (I am fairly sure I set the AP to
> 802.11g only though which may have been a problem).

That's what my laptop needs. Not for the wireless card, but somehow
windows locks up if I just reboot the machine. Of course no nice Oops
message or so.

> Excellent.  Is the bcm43xx planning to get 802.11g mode working at some
> point?

Most certainly, the plans are there for quite some time, but...

>  Is broadcom ever going to help out with any specs for their
> hardware or do they still mistakenly believe that end users are not
> their customers?

... the documentation isn't. Right now the only available documentation
comes from reverse engineering. It's actually rather amazing that the
authors came this far, no vendor documentation yet still a lot of
supported cards.

>  Given the behaviour of broadcom over the years I know
> I don't intend to buy anything with a broadcom chip in it again, which
> means broadcom's behaviour directly means they will get less sales to the
> laptop makers, since some people will actively avoid anything with
> broadcom's hardware in it. :)

That's my take as well. They already lost us on the Gig ethernet cards.
A couple of years ago we considered Broadcom based cards, but given the
lack of vendor driver support, we got Intel E1000 based cards instead.
We also considered NatSemi gigE cards, but the Intels were much faster.
Right now we use about 15 E1000's with probably more to come (they go
in every new machine). Not a high figure but still a lost sale for
Broadcom.

As for wireless, for personal use I needed a wireless PCMCIA/CardBus
card and a Linksys bcm4318 based card was the only reasonably supported
card I could get. It works but still has its peculiarities.


Erik

-- 
+-- Erik Mouw -- www.harddisk-recovery.nl -- 0800 220 20 20 --
| Eigen lab: Delftechpark 26, 2628 XH, Delft, Nederland
| Files foetsie, bestanden kwijt, alle data weg?!
| Blijf kalm en neem contact op met Harddisk-recovery.nl!
