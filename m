Return-Path: <linux-kernel-owner+w=401wt.eu-S1758645AbYBGNfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645AbYBGNfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 08:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314AbYBGNfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 08:35:18 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:34822 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799AbYBGNfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 08:35:16 -0500
Message-ID: <47AB0911.3060508@davidnewall.com>
Date: Fri, 08 Feb 2008 00:05:13 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Diego Zuccato <diego@otello.alma.unibo.it>
CC: Greg KH <greg@kroah.com>, Christer Weinigel <christer@weinigel.se>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
References: <20080125180232.GA4613@kroah.com>            <20080202123710.42df1aa0@weinigel.se>            <20080202191930.GA19826@kroah.com>            <47A5D895.20300@davidnewall.com>            <47A6E742.80408@otello.alma.unibo.it> <courier.47A8F072.000079E4@hawking.rebel.net.au> <47AAC1EE.6060101@otello.alma.unibo.it>
In-Reply-To: <47AAC1EE.6060101@otello.alma.unibo.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Diego Zuccato wrote:
> David Newall ha scritto:
>
>> "Of course", because in many parts of the world, a device who's
>> manufacturer fails to take reasonable steps to prevent it from being
>> used outside regulatory limits is illegal.  Providing source code not
>> only is a failure to take those reasonable steps, but is quite the
>> opposite.  It may even be viewed as encouraging users to use it
>> inappropriately.
> If the device is well engineered, there's nothing the sw can do to
> make it work outside regulatory limits.

That's naive, since requirements differ in different jurisdictions, as
I'm sure you are perfectly aware.

> Sometimes there's simply NOTHING the SW can do to *avoid* it. Think
> about a CB radio. International standard is 5W (well, somewhere it's
> 3, IIRC, but that's another story: nobody produces a special model
> with a final amplifier for only 3W, everyone produces the 5W and turns
> down power in some other way).
Precisely: One purpose of the driver is to enforce local compliance.

> But linear amplifiers are commonly sold. And (at least in Italy) it's
> not illegal to buy one, even if it can boost antenna power to 1000W.
> It's illegal just to USE it.
In Australia it's illegal to own them (CB licensee; HAMs are allowed to
use them, although not on 27Mhz.)

> And it's a logical problem, too: why should the *driver* enforce a
> *technical* limit?
That's part of it's purpose.  It permits a manufacturer to make a global
device that operates within local restrictions.
