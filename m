Return-Path: <linux-kernel-owner+w=401wt.eu-S1760130AbYBEUDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760130AbYBEUDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 15:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757666AbYBEUDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 15:03:15 -0500
Received: from senator.holtmann.net ([87.106.208.187]:45074 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759855AbYBEUDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 15:03:12 -0500
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
From: Marcel Holtmann <marcel@holtmann.org>
To: David Newall <davidn@davidnewall.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Christer Weinigel <christer@weinigel.se>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <courier.47A84ADB.000047C1@hawking.rebel.net.au>
References: <20080125180232.GA4613@kroah.com>
	 <20080202123710.42df1aa0@weinigel.se> <20080202191930.GA19826@kroah.com>
	 <47A5D9CD.5070001@davidnewall.com>
	 <84144f020802030743j1278ac64j2ee3e2cbc5c3fefc@mail.gmail.com>
	 <47A5E67D.9040804@davidnewall.com> <1202058820.15090.60.camel@violet>
	 <courier.47A84ADB.000047C1@hawking.rebel.net.au>
Content-Type: text/plain
Date: Tue, 05 Feb 2008 21:03:38 +0100
Message-Id: <1202241819.15090.133.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

> > if a new drivers is originally written for Linux, then you are breaking
> > the GPL.
> 
> Completely wrong.  However if the driver is distributed as built-in, then it 
> would need to be licensed under GPL.  This means that a driver can be 
> written and distributed as a module under any licence, proprietary or 
> otherwise, presumably with the restriction that it may NOT be built-in. 

how to do you wanna write a new original Linux driver (modular or
built-in) without creating derivative work. This is not possible and due
to the fact that it is derivative work the driver becomes automatically
licensed under GPL. This is not a gray area.

The gray area that exists if you have code that was written for some
other operating system and licensed under some proprietary license in
the first place. And now that code is used in conjunction with a glue
layer to make it loadable as kernel module.

> > You driver was meant to be
> > running as Linux kernel module and thus it is derivative work.
> 
> It is precisely the fact that it is a loadable module, and does not form 
> part of the kernel, that removes the requirement to distribute it under GPL. 

That is such a nonsense. Stop distributing FUD and start talking to a
lawyer. You are clearly under some weird impression what the GPL means
and what it implies.

> > What are you arguing here. It makes no difference if it is technical or
> > not. The EXPORT_SYMBOL_GPL gives you a clear hint that when using this
> > symbol, you have to obey to the GPL.
> 
> And that "hint" is a lie.

If the developers say that this symbol can only be used in GPL code (and
with EXPORT_SYMBOL_GPL it is quite clear) then you have to obey to that
license or don't use this symbol at all.

If you use that symbol inside non-GPL (meaning you link at runtime) then
you are in violation of the GPL license. We can't make it much clearer.

Regards

Marcel


