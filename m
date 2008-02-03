Return-Path: <linux-kernel-owner+w=401wt.eu-S1761324AbYBCQGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761324AbYBCQGV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 11:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754614AbYBCQGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 11:06:10 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:33944 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085AbYBCQGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 11:06:07 -0500
Message-ID: <47A5E67D.9040804@davidnewall.com>
Date: Mon, 04 Feb 2008 02:36:21 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Greg KH <greg@kroah.com>, Christer Weinigel <christer@weinigel.se>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
References: <20080125180232.GA4613@kroah.com>	 <20080202123710.42df1aa0@weinigel.se>	 <20080202191930.GA19826@kroah.com> <47A5D9CD.5070001@davidnewall.com> <84144f020802030743j1278ac64j2ee3e2cbc5c3fefc@mail.gmail.com>
In-Reply-To: <84144f020802030743j1278ac64j2ee3e2cbc5c3fefc@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> Hi David,
>
> On Feb 3, 2008 5:12 PM, David Newall <davidn@davidnewall.com> wrote:
>   
>> By the way, I'm almost certain that the COPYING file is the first, last
>> and only document specifying licence conditions, and nothing in that
>> prevents a proprietary driver from including a patch that, for example,
>> globally replaces ALL GPL-only symbols by the less restrictive ones.
>>     
>
> So I am going to assume you're not trolling here (although some of
> your snarky remarks make that bit hard).
>   

Thanks.  I'm not trolling.  Perhaps I was a bit snarky; it's an issue I
feel strongly about.  (I'm sure others feel just as strongly, but
differently.)

> And, _if_ you're distributing a derived work that is not under the
> GPLv2, you're breaking the law. I think we can agree on this?
>   

Agreed.

> As there is some controversy over the definition of derived work
> (think Linus' comments on porting a driver or a filesystem from
> another operating system here), we use the EXPORT_SYMBOL_GPL
> annotations as a big warning sign that what you're doing is likely to
> be considered as a derived work.
Let's consider a totally original USB driver.  There are an infinite
number of them, some still to be written.


> If the USB developers want to
> annotate their code with EXPORT_SYMBOL_GPL, why the hell do you want
> to argue about it?
Have I the wrong end of the stick?  Isn't that mark restricting an
interface to GPL _callers_?    Isn't it a technical switch that means,
"Don't use my software if yours isn't (also) GPL"?  As such it's mere
political rhetoric, devoid of any binding power.


> If you want to
> develop for Linux, you're most certainly better off always
> distributing your code under the GPLv2

I agree; but let's not disadvantage applications where regulatory
requirements prohibit GPL code, nor applications where the proprietor
simply chooses to keep the work proprietary.  A proprietary module is
simply a piece of software.  Many people couldn't use Linux if they
couldn't run proprietary software on it.


> But what I don't understand
> is why people insist using the Linux kernel for something it clearly
> can never really properly support (proprietary code)?
>   

That's defeatist.  Of course the Linux kernel can properly support
("run") proprietary code.  It would be a miserable excuse for an
operating system if it couldn't.
