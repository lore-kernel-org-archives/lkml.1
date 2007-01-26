Return-Path: <linux-kernel-owner+w=401wt.eu-S1030226AbXA0AoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030226AbXA0AoE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 19:44:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030264AbXA0Ani
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 19:43:38 -0500
Received: from smtp102.sbc.mail.mud.yahoo.com ([68.142.198.201]:23656 "HELO
	smtp102.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965575AbXA0AnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 19:43:03 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=H+mG5ZU8bNEQRzypV64Ru8hZj+2Y9CuMKti1ZZSy18jhyk8V7ZC+DO2Ep/aKMB3pTKSONDHrGeo590ix2z2ZKSLq24evuY+b6Kq32oZtPNgCSW4GRc1vmJ54WruN1b/G6NJgfvW3HXqPfTojXLHL/bw1dLWdspnSW5ahrPaEaKA=  ;
X-YMail-OSG: Atb7rnIVM1li6wx4cgoqFmqdU4.FapGbJLJuYhljCrJbnHq2tVOEW9tfQH_4N6KUlJT8t.rEnxMbPi.sFEQkl20ymH6CUP2xrF6pvve9b_4Sp7f6JgGyPKgi
From: David Brownell <david-b@pacbell.net>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Subject: Re: [PATCH] 4/5: Updates to SPI and mmc_spi: mmc_spi updated, kernel 2.6.19
Date: Fri, 26 Jan 2007 15:38:58 -0800
User-Agent: KMail/1.7.1
Cc: Hans-Peter Nilsson <hans-peter.nilsson@axis.com>,
       dbrownell@users.sourceforge.net, mikael.starvik@axis.com,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <200701250453.l0P4rjHN017189@ignucius.se.axis.com> <45BA3112.503@drzeus.cx>
In-Reply-To: <45BA3112.503@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701261538.59439.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 January 2007 8:49 am, Pierre Ossman wrote:
> Hans-Peter Nilsson wrote:
> > 
> > Future improvements:
> > A rewrite.  Not only for the new MMC framework (I haven't looked
> > at it so I don't know what's involved) but also because this
> > code seems a little too, um, experimental to fit my taste.
> > Functions go behind each other's back and look at and change
> > data; they seem to "fix up" the result of each others work.

(Like the MMC layer's retry mechanism ...)


> > It doesn't help maintenance.
> 
> Right, this isn't getting merged anywhere near its current state. It
> should be implemented as a host driver and we'll modify the mmc core
> where needed to cover the differences when doing spi.
> 
> As for my "new framework", it's mostly reorganising the stuff already
> there. But any patches will have to be reworked after that change. So
> I'd suggest holding off on this for a while.

That goes without saying, since this driver currently needs some
updates to the SPI framework (grabbing the whole bus, locking out
other devices) that aren't yet mergeable.

However I'm glad to see that, courtesy of Hans-Peter, we now seem
to have enough of the MMC-over-SPI behaving that we can start to
fill in those missing pieces ... and explore just what changes
would be needed in the MMC/SD core!

- Dave

