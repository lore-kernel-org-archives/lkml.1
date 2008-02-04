Return-Path: <linux-kernel-owner+w=401wt.eu-S1755460AbYBDVh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbYBDVh4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 16:37:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752925AbYBDVhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 16:37:47 -0500
Received: from senator.holtmann.net ([87.106.208.187]:44724 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbYBDVhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 16:37:46 -0500
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
From: Marcel Holtmann <marcel@holtmann.org>
To: Christer Weinigel <christer@weinigel.se>
Cc: Diego Zuccato <diego@otello.alma.unibo.it>,
       David Newall <davidn@davidnewall.com>, Greg KH <greg@kroah.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <47A764ED.8030605@weinigel.se>
References: <20080125180232.GA4613@kroah.com>
	 <20080202123710.42df1aa0@weinigel.se> <20080202191930.GA19826@kroah.com>
	 <47A5D895.20300@davidnewall.com> <47A6E742.80408@otello.alma.unibo.it>
	 <47A764ED.8030605@weinigel.se>
Content-Type: text/plain
Date: Mon, 04 Feb 2008 22:38:11 +0100
Message-Id: <1202161091.15090.84.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christer,

> > In the cited example it's illegal to go outside certain parameters 
> > SOMEWHERE (if it was illegal everywhere, the the hardware shouldn't 
> > allow it and the sw could do nothing... not considering hw mods).
> > Another example is WiFi: USA, Europe and Japan allows a different number 
> > of channels. But every AP I have had simply asks which country the user 
> > is in, then allows only a limited choice for the channel to use.
> > If I'm in Europe but tell my AP that I'm in Japan, it lets me choose 
> > channel 13 (Europe allows up to ch 11). If the "cops" find it out, they 
> > prosecute ME, not my AP! It's not a TECHNICAL limit, it's a LEGAL one.
> > So there's no point in keeping a driver closed *just* because else 
> > someone could hack it to make it work outside the allowed parameters: 
> > even a closed driver is hackable (just reverse engineer it...).
> > 
> > Think about this scenario: a closed source driver contains:
> > if(power<100)
> >     setpower(power);
> > else
> >     setpower(100);
> > to limit tx power and make it legal. Then the user finds this 100 and 
> > replaces it with 255 (inside the binary-only module), actually allowing 
> > for more than twice (if power is in mW) the legally permitted power.
> > Is it legal?
> 
> > I don't think so (and I doubt you can find any lawyer that does). But 
> > it's not THE DRIVER that's doing something illegal. It's THE USER.
> > It would be equally illegal if the driver was open source. Simpler to 
> > do, but equally illegal.
> 
> It isn't that easy.  The "Tamper-Proof Torx" screws on a vacuum cleaner 
> or a toaster won't stop anybody from opening up the thing, I mean every 
> little hardware store stocks those Torx bits.  But by using a slightly 
> odd screw, the company can say "look, we'we done all we can to stop 
> them, but the user bypassed our security device, and it's not our 
> fault".  Apparently Intel and Atheros are trying to protect themselves 
> in a similar way, they Open Source everything except for the regulatory 
> daemon (Intel) or HAL object file (Atheros).  Why?  Because they belive 
> that if they give away the sources to those parts they do the software 
> equivalent of putting a normal Phillips screw in a home appliance. 
> (Personally I think what they are doing is ridiculous, but apparently 
> those companies' lawyers dont' agree).

while the HAL case of Atheros might be still true despite the fact that
an OpenHAL has been around for a long time now. The Intel argument is
out of the picture since quite some time. The regulatory daemon was an
interim solution and has been replaced by a proper firmware solution. So
please get your examples up-to-date.

You might wanna now point to hiding something in firmware, but the
hardware, firmware, driver separation (with being hardware and firmware
closed source) is an accepted solution. It is a clean separation.
Interface wise and license wise. Remember that nobody inside the
community ever asked for any kind of IP or trade secrets. We only want
specifications so we can write the drivers under an appropriate open
source license. If the specification describes an API exposed via
firmware then that is perfectly fine.

Regards

Marcel


