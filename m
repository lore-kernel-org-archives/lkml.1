Return-Path: <linux-kernel-owner+w=401wt.eu-S934297AbYBGXUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934297AbYBGXUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 18:20:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759908AbYBGXTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 18:19:53 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56877 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759054AbYBGXTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 18:19:51 -0500
Date: Thu, 7 Feb 2008 15:17:41 -0800
From: Greg KH <greg@kroah.com>
To: Hannu Savolainen <hannu@opensound.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Newall <davidn@davidnewall.com>,
       Chris Friesen <cfriesen@nortel.com>,
       Christer Weinigel <christer@weinigel.se>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Message-ID: <20080207231741.GB19002@kroah.com>
References: <20080202191930.GA19826@kroah.com> <20080203124849.0226560f@weinigel.se> <84144f020802030635h3a9c4304n943d117e936f1c2d@mail.gmail.com> <47A5F418.6030104@weinigel.se> <20080203231530.GB15692@kroah.com> <courier.47A8EDDC.0000785F@hawking.rebel.net.au> <47A8F27F.3060504@nortel.com> <47AB0238.5030400@davidnewall.com> <20080207141227.51193a12@core> <47AB8B6A.7020404@opensound.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AB8B6A.7020404@opensound.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 12:51:22AM +0200, Hannu Savolainen wrote:
> Alan Cox kirjoitti:
>>> doesn't mean it's derived from Linux.  In the case of user-space code
>>> it's widely understood that no licence restrictions are conferred.  The
>>>     
>>
>> Actually that is also questionable. The only reason it is fairly certain
>> in Linux is Linus went to the trouble of stating that interpretation was
>> intended in the COPYING file and saying he sees it that way.
>>
>>   
>>> No.  Holders of Linux copyrights would have to prove that the
>>> proprietary code is derived from the kernel.  They have the burden of
>>> proof, and defence needs merely show that their arguments are wrong.
>>>     
>>
>> Wrong again. In civil law in the USA and most of europe the test is
>> "balance of probability".
>>   
> What is the "propability" that drivers using the interfaces now declared as 
> "EXPORT_SYMBOL_GPL" are derived from the Linux kernel source code instead 
> of some definitive documentation?
>
> As you all (should) know there is a book called "Linux Device Drivers, 3rd 
> Edition" published by O'Reilly (ISBN 0-596-00590-3)". All the USB kernel 
> interfaces are documented there. One of the authors is Greg Kroah-Hartman 
> which makes this book "definite" source of information on Linux USB driver 
> programming. I assume Greg is the author of the USB related sections.

Yes, I wrote that, and if you look at that chapter, it states it is
based on the GPL licensed documentation that comes from the kernel
itself, which was written by a lot of other people as well.

> The "legal" question is what is that which one is license the one that 
> applies? Is it the licecense of the kernel (GPL) or is it the license of 
> the documentation (no restrictions on usage)?

There is no such license on that documentation.

> The "moral" question is that why did Greg author a book that declares these 
> USB interfaces as "free to use" and soon after that made a decision that 
> they are no longer "free to use"?

Where did I ever declare these interfaces as "free to use in violation
of the GPL" anywhere?  If you look at the examples that I wrote for that
book, they are all licensed under the GPLv2 only.

Same goes for the Windows Driver book.  You can use the Windows driver
development kit and API, as long as you follow their license.  And that
license explicitly forbids using it in code that is under an open source
license.  Is describing those interfaces in a book somehow also
"immoral"?

geesh, this thread is just insane, time to just ignore it...

greg k-h
