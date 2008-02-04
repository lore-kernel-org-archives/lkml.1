Return-Path: <linux-kernel-owner+w=401wt.eu-S1757898AbYBDTSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898AbYBDTSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 14:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756379AbYBDTSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 14:18:09 -0500
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:51248 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948AbYBDTSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 14:18:07 -0500
Message-ID: <47A764ED.8030605@weinigel.se>
Date: Mon, 04 Feb 2008 20:18:05 +0100
From: Christer Weinigel <christer@weinigel.se>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Diego Zuccato <diego@otello.alma.unibo.it>
CC: David Newall <davidn@davidnewall.com>, Greg KH <greg@kroah.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
References: <20080125180232.GA4613@kroah.com> <20080202123710.42df1aa0@weinigel.se> <20080202191930.GA19826@kroah.com> <47A5D895.20300@davidnewall.com> <47A6E742.80408@otello.alma.unibo.it>
In-Reply-To: <47A6E742.80408@otello.alma.unibo.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Diego Zuccato wrote:
> In the cited example it's illegal to go outside certain parameters 
> SOMEWHERE (if it was illegal everywhere, the the hardware shouldn't 
> allow it and the sw could do nothing... not considering hw mods).
> Another example is WiFi: USA, Europe and Japan allows a different number 
> of channels. But every AP I have had simply asks which country the user 
> is in, then allows only a limited choice for the channel to use.
> If I'm in Europe but tell my AP that I'm in Japan, it lets me choose 
> channel 13 (Europe allows up to ch 11). If the "cops" find it out, they 
> prosecute ME, not my AP! It's not a TECHNICAL limit, it's a LEGAL one.
> So there's no point in keeping a driver closed *just* because else 
> someone could hack it to make it work outside the allowed parameters: 
> even a closed driver is hackable (just reverse engineer it...).
> 
> Think about this scenario: a closed source driver contains:
> if(power<100)
>     setpower(power);
> else
>     setpower(100);
> to limit tx power and make it legal. Then the user finds this 100 and 
> replaces it with 255 (inside the binary-only module), actually allowing 
> for more than twice (if power is in mW) the legally permitted power.
> Is it legal?

> I don't think so (and I doubt you can find any lawyer that does). But 
> it's not THE DRIVER that's doing something illegal. It's THE USER.
> It would be equally illegal if the driver was open source. Simpler to 
> do, but equally illegal.

It isn't that easy.  The "Tamper-Proof Torx" screws on a vacuum cleaner 
or a toaster won't stop anybody from opening up the thing, I mean every 
little hardware store stocks those Torx bits.  But by using a slightly 
odd screw, the company can say "look, we'we done all we can to stop 
them, but the user bypassed our security device, and it's not our 
fault".  Apparently Intel and Atheros are trying to protect themselves 
in a similar way, they Open Source everything except for the regulatory 
daemon (Intel) or HAL object file (Atheros).  Why?  Because they belive 
that if they give away the sources to those parts they do the software 
equivalent of putting a normal Phillips screw in a home appliance. 
(Personally I think what they are doing is ridiculous, but apparently 
those companies' lawyers dont' agree).

It's of course possible to argue that normal users don't compile their 
own drivers, they use a driver from their distribution maker, and 
compiling a hacked driver which allows them to override the limits is 
just as hard as it is for a Windows user to replace the driver binary 
with a hacked binary which overrides the limits, so hiding the source 
really doesn't help.

> Another example: how do you detect, from a driver, if the user actually 
> got a license/permission from the government (somewhere it's needed, or 
> you need to pay an annual fee) to use the device? You can't. Does this 
> missing check make the device illegal? Nope. Just its USE.

Welcome to the modern world, companies spend so much money on protecting 
themselves against potential lawsuit that it is silly.

   /Christer
