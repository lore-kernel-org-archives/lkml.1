Return-Path: <linux-kernel-owner+w=401wt.eu-S933684AbYBUVID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933684AbYBUVID (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 16:08:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759740AbYBUVHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 16:07:51 -0500
Received: from smtp2.wanadoo.co.uk ([193.252.22.157]:18702 "EHLO
	smtp2.freeserve.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759472AbYBUVHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 16:07:49 -0500
X-ME-UUID: 20080221210743979.EEFB17000086@mwinf3108.me.freeserve.com
Subject: Re: [Rt2400-devel] 2.6.25-rc2 regression in rt61pci wireless driver
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>, chris2553@googlemail.com,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       rt2400-devel@lists.sourceforge.net
In-Reply-To: <1203542195.3240.1.camel@boulder.homenet>
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com>
	 <1203523555.693.2.camel@localhost.localdomain>
	 <1203539235.3189.4.camel@boulder.homenet>
	 <200802202150.20303.IvDoorn@gmail.com>
	 <1203542195.3240.1.camel@boulder.homenet>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 21:07:29 +0000
Message-Id: <1203628049.3277.6.camel@boulder.homenet>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-02-20 at 21:16 +0000, Chris Vine wrote: 
> On Wed, 2008-02-20 at 21:50 +0100, Ivo van Doorn wrote:
> [snip]
> > On Wednesday 20 February 2008, Chris Vine wrote:
> > > I did that yesterday and it just reported a kernel panic on the terminal
> > > with the message:
> > > 
> > >   Kernel panic - not syncing: Aiee, killing interrupt handler!
> > 
> > I have an idea, could you try below patch?
> > Note that while applying it will mention something about a line offset, but that can be ignored.
> > 
> > This could perhaps also fix the TX/RX issue mentioned earlier in the thread, but I am not
> > quite sure about that.
> 
> The patch applied OK (with some offsets as you say) but it doesn't help.
> The kernel panic still occurs when association is attempted.

Here's some further information.

I have a fully functioning version of rt2x00-2.0.14 and mac80211 from
wireless-2.6/compat-wireless-2.6 of mid January which works fine on
kernel 2.6.24.  On doing a comparison with the rt2x00 in vanilla kernel
2.6.25-rc2, there are no material differences.  (There was a slight
change in the declaration a variable in rt2x00usb.c but it is
immaterial.)

I compiled up the working mid-January version of rt2x00 and mac80211
under kernel 2.6.25-rc2 and I get exactly the same result as I reported
earlier, namely I get a kernel panic as soon as I try to associate.  It
looks therefore as if something has changed within the remainder of the
kernel which has caused rt2x00 (and possibly mac80211?) to break.

This probably explains the problem another user reported with rt61.

Chris


