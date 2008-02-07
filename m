Return-Path: <linux-kernel-owner+w=401wt.eu-S1760053AbYBGNhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760053AbYBGNhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 08:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbYBGNhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 08:37:10 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:34829 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbYBGNhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 08:37:08 -0500
Message-ID: <47AB0981.3090907@davidnewall.com>
Date: Fri, 08 Feb 2008 00:07:05 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: Marcel Holtmann <marcel@holtmann.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Christer Weinigel <christer@weinigel.se>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
References: <20080125180232.GA4613@kroah.com> <20080202123710.42df1aa0@weinigel.se> <20080202191930.GA19826@kroah.com> <47A5D9CD.5070001@davidnewall.com> <84144f020802030743j1278ac64j2ee3e2cbc5c3fefc@mail.gmail.com> <47A5E67D.9040804@davidnewall.com> <1202058820.15090.60.camel@violet> <courier.47A84ADB.000047C1@hawking.rebel.net.au> <1202241819.15090.133.camel@violet> <47A8C893.6000103@nortel.com>
In-Reply-To: <47A8C893.6000103@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> Marcel Holtmann wrote:
>
>> If the developers say that this symbol can only be used in GPL code (and
>> with EXPORT_SYMBOL_GPL it is quite clear) then you have to obey to that
>> license or don't use this symbol at all.
>>
>> If you use that symbol inside non-GPL (meaning you link at runtime) then
>> you are in violation of the GPL license. We can't make it much clearer.
>
> Not necessarily so.  The developers feel that any code using that
> symbol is necessarily a derivative work,

The problem with that is this: To be derivative, a work has to be
derived from another work.  That's what "derivative" means.  Is it by
prescience that those marking symbols as EXPORT_SYMBOL_GPL know that
only things derived from something else are capable of using them? 
Derived from what?  The use of a separate module does not make something
derivative.  It makes it a client.  Any binding between the two modules
occurs only at runtime, and is purely ephemeral.

I make this charge: Some, perhaps much, of the GPL-exported symbols have
been mislabelled.  There is no prescience, and those who labelled them
such are really trying (and failing) to claim an additional licence
condition.

I further make this claim: an attempt to add a licence condition in that
fashion is illegal, at least it is under various Australian laws, but I
expect it's a similar story elsewhere.  For a start, it's an attempt to
vary licence conditions after the contract is made, and also without due
notice.  It also attempts to unfairly restrict trade.  It's probably
fraud, in that it purports to be a work provided under GPL, while
silently claiming a different (and largely unstated) licence.

The EXPORT_SYMBOL_GPL should be removed, because it's based on a lie. 
You cannot know that only GPL works are capable of using the symbol; you
cannot know that all works that do use it are derivative of something;
you cannot even say, a priori, what they are derived from.
