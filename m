Return-Path: <linux-kernel-owner+w=401wt.eu-S1759567AbYBEUgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759567AbYBEUgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 15:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754695AbYBEUgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 15:36:10 -0500
Received: from zcars04f.nortel.com ([47.129.242.57]:42417 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933AbYBEUgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 15:36:09 -0500
Message-ID: <47A8C893.6000103@nortel.com>
Date: Tue, 05 Feb 2008 14:35:31 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: David Newall <davidn@davidnewall.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Christer Weinigel <christer@weinigel.se>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
References: <20080125180232.GA4613@kroah.com> <20080202123710.42df1aa0@weinigel.se> <20080202191930.GA19826@kroah.com> <47A5D9CD.5070001@davidnewall.com> <84144f020802030743j1278ac64j2ee3e2cbc5c3fefc@mail.gmail.com> <47A5E67D.9040804@davidnewall.com> <1202058820.15090.60.camel@violet> <courier.47A84ADB.000047C1@hawking.rebel.net.au> <1202241819.15090.133.camel@violet>
In-Reply-To: <1202241819.15090.133.camel@violet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Feb 2008 20:35:34.0933 (UTC) FILETIME=[A8C90C50:01C86836]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcel Holtmann wrote:

> If the developers say that this symbol can only be used in GPL code (and
> with EXPORT_SYMBOL_GPL it is quite clear) then you have to obey to that
> license or don't use this symbol at all.
> 
> If you use that symbol inside non-GPL (meaning you link at runtime) then
> you are in violation of the GPL license. We can't make it much clearer.

Not necessarily so.  The developers feel that any code using that symbol 
is necessarily a derivative work, but at the end of the day it would be 
up to the legal system to decide whether it really is or not.

If the courts decided that the symbol could be used and the driver 
wouldn't be a derivative work, it would be perfectly legal to use a 
GPL'd shim to "re-export" the symbol, essentially stripping off the 
GPL-only protection for that symbol.

In our group all kernel modules that we write are GPL'd, as it lets us 
sleep at night, simplifies our lives, and makes the lawyers much 
happier.  Other people may be willing to take more risks.

Chris
