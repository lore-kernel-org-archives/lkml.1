Return-Path: <linux-kernel-owner+w=401wt.eu-S1759178AbYBGQuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759178AbYBGQuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 11:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254AbYBGQub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 11:50:31 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:34952 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187AbYBGQua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 11:50:30 -0500
Message-ID: <47AB36D2.5050602@davidnewall.com>
Date: Fri, 08 Feb 2008 03:20:26 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
CC: Christer Weinigel <christer@weinigel.se>,
       Marcel Holtmann <marcel@holtmann.org>,
       Diego Zuccato <diego@otello.alma.unibo.it>, Greg KH <greg@kroah.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
References: <20080125180232.GA4613@kroah.com>	<20080202123710.42df1aa0@weinigel.se>	<20080202191930.GA19826@kroah.com>	<47A5D895.20300@davidnewall.com>	<47A6E742.80408@otello.alma.unibo.it>	<47A764ED.8030605@weinigel.se>	<1202161091.15090.84.camel@violet>	<20080206213449.6614efea@weinigel.se>	<20080206215442.63c94cf3@dilbert.local>	<47AB056E.70802@davidnewall.com>	<20080207150612.21ba60df@dilbert.local>	<47AB163C.5070107@davidnewall.com> <20080207171322.40eb7c95@dilbert.local>
In-Reply-To: <20080207171322.40eb7c95@dilbert.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans-Jürgen Koch wrote:
> Am Fri, 08 Feb 2008 01:01:24 +1030
> schrieb David Newall <davidn@davidnewall.com>:
>   
>>> It is not legally meaningless if copyright holders publicly state
>>> how they interpret the license and what they consider a license
>>> violation. 
>>>       
>> Copyright-holders' opinions mean nothing.  In the particular case of
>> EXPORT_SYMBOL_GPL, copyright-holders' opinions are clearly flawed
>> because they make a statement about code that they do not even know
>> of. 
>>     
>
> What are you talking about? That's what every GPL-licensed library
> does. By putting a library under the GPL, the copyright-holder clearly
> states that he considers all programs that link against that library a
> derived work. And that he therefor requires these programs to be GPL,
> too, no matter if these programs already exist or not.
>   

Your last sentence, above: That is what EXPORT_SYMBOL_GPL attempts to
do.  The place to state such a requirement is in the licence, not in the
source code.  That is what I am talking about.  I can't provide you with
software under a licence that says, "you are free to use this software
in any way you want," and later say, "oh, but in the source code is
tells you that you must take a break every two hours of use."


>> Less there be further confusion: I am not an advocate for binary
>> drivers.  
>>     
>
> Nice to hear. So, if you're an advocate for open source drivers, why do
> you have problems making them GPL?
>   

I don't, but EXPORT_SYMBOL_GPL doesn't do that.  It makes an ambit
claim, that might coerce an author into making a driver GPL, but might
also cause them to exit the Linux market.  I have a problem with driving
manufacturers away from Linux.

> Using a symbol from a library means linking to it, and that creates a
> derived work. Why should it be different when using kernel symbols?
I don't agree with your claim, but I'm going to explain something else:
The GPL doesn't require software that *uses* GPL code to itself be GPL. 
It requires software that is *distributed* as part of a GPL work to
itself be GPL.  At time of distribution, a kernel module is neither
using nor linked to the kernel.
