Return-Path: <linux-kernel-owner+w=401wt.eu-S1760973AbYBEVMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760973AbYBEVMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 16:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758393AbYBEVML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 16:12:11 -0500
Received: from senator.holtmann.net ([87.106.208.187]:54558 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756810AbYBEVMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 16:12:10 -0500
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
From: Marcel Holtmann <marcel@holtmann.org>
To: Chris Friesen <cfriesen@nortel.com>
Cc: David Newall <davidn@davidnewall.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Christer Weinigel <christer@weinigel.se>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <47A8C893.6000103@nortel.com>
References: <20080125180232.GA4613@kroah.com>
	 <20080202123710.42df1aa0@weinigel.se> <20080202191930.GA19826@kroah.com>
	 <47A5D9CD.5070001@davidnewall.com>
	 <84144f020802030743j1278ac64j2ee3e2cbc5c3fefc@mail.gmail.com>
	 <47A5E67D.9040804@davidnewall.com> <1202058820.15090.60.camel@violet>
	 <courier.47A84ADB.000047C1@hawking.rebel.net.au>
	 <1202241819.15090.133.camel@violet>  <47A8C893.6000103@nortel.com>
Content-Type: text/plain
Date: Tue, 05 Feb 2008 22:12:38 +0100
Message-Id: <1202245958.15090.145.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

> > If the developers say that this symbol can only be used in GPL code (and
> > with EXPORT_SYMBOL_GPL it is quite clear) then you have to obey to that
> > license or don't use this symbol at all.
> > 
> > If you use that symbol inside non-GPL (meaning you link at runtime) then
> > you are in violation of the GPL license. We can't make it much clearer.
> 
> Not necessarily so.  The developers feel that any code using that symbol 
> is necessarily a derivative work, but at the end of the day it would be 
> up to the legal system to decide whether it really is or not.
> 
> If the courts decided that the symbol could be used and the driver 
> wouldn't be a derivative work, it would be perfectly legal to use a 
> GPL'd shim to "re-export" the symbol, essentially stripping off the 
> GPL-only protection for that symbol.

I agree with you that a court can decide that the usage of a
EXPORT_SYMBOL_GPL symbol is not derivative work, but I see the
likelihood of this happening as almost non existent. And even if so then
you still have to deal with the fact that the license of this symbol is
clearly GPL. No questions asked about that, because it says so and due
technical means you can't load a non-GPL kernel module that uses
EXPORT_SYMBOL_GPL symbol without tainting the kernel.

The same fact is valid in userspace where you can't link (not even
runtime) a GPL library into a non-GPL program.

However if anyone wants to fight the license, be my guest and do so :)

> In our group all kernel modules that we write are GPL'd, as it lets us 
> sleep at night, simplifies our lives, and makes the lawyers much 
> happier.  Other people may be willing to take more risks.

All big companies are going this way. And licenses beside, there are
valid technical points in making your driver open source and get it
merged upstream. Just a hint for all these binary-only people :)

Regards

Marcel


