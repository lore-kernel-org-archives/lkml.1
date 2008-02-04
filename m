Return-Path: <linux-kernel-owner+w=401wt.eu-S1753521AbYBDKqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbYBDKqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 05:46:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751044AbYBDKq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 05:46:26 -0500
Received: from otello.alma.unibo.it ([137.204.24.163]:50367 "EHLO
	otello.alma.unibo.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbYBDKqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 05:46:25 -0500
X-Greylist: delayed 1470 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Feb 2008 05:46:25 EST
Message-ID: <47A6E742.80408@otello.alma.unibo.it>
Date: Mon, 04 Feb 2008 11:21:54 +0100
From: Diego Zuccato <diego@otello.alma.unibo.it>
User-Agent: Thunderbird 2.0.0.9 (X11/20080114)
MIME-Version: 1.0
To: David Newall <davidn@davidnewall.com>
Cc: Greg KH <greg@kroah.com>, Christer Weinigel <christer@weinigel.se>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
References: <20080125180232.GA4613@kroah.com> <20080202123710.42df1aa0@weinigel.se> <20080202191930.GA19826@kroah.com> <47A5D895.20300@davidnewall.com>
In-Reply-To: <47A5D895.20300@davidnewall.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall ha scritto:

> This does, of course,
> disadvantage Linux with respect to many classes of devices, for example
> GSM transceivers when used in those parts of the world^ where regulatory
> requirements prohibit modification of power or frequency settings, which
> effectively prohibits open-source driver.
Why "of course" ?
In the cited example it's illegal to go outside certain parameters 
SOMEWHERE (if it was illegal everywhere, the the hardware shouldn't 
allow it and the sw could do nothing... not considering hw mods).
Another example is WiFi: USA, Europe and Japan allows a different number 
of channels. But every AP I have had simply asks which country the user 
is in, then allows only a limited choice for the channel to use.
If I'm in Europe but tell my AP that I'm in Japan, it lets me choose 
channel 13 (Europe allows up to ch 11). If the "cops" find it out, they 
prosecute ME, not my AP! It's not a TECHNICAL limit, it's a LEGAL one.
So there's no point in keeping a driver closed *just* because else 
someone could hack it to make it work outside the allowed parameters: 
even a closed driver is hackable (just reverse engineer it...).

Think about this scenario: a closed source driver contains:
if(power<100)
	setpower(power);
else
	setpower(100);
to limit tx power and make it legal. Then the user finds this 100 and 
replaces it with 255 (inside the binary-only module), actually allowing 
for more than twice (if power is in mW) the legally permitted power.
Is it legal?
I don't think so (and I doubt you can find any lawyer that does). But 
it's not THE DRIVER that's doing something illegal. It's THE USER.
It would be equally illegal if the driver was open source. Simpler to 
do, but equally illegal.
Another example: how do you detect, from a driver, if the user actually 
got a license/permission from the government (somewhere it's needed, or 
you need to pay an annual fee) to use the device? You can't. Does this 
missing check make the device illegal? Nope. Just its USE.

I stop here cause it's already too OT.

BYtE,
  Diego.

