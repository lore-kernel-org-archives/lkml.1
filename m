Return-Path: <linux-kernel-owner+w=401wt.eu-S1756843AbYBGIbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbYBGIbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 03:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbYBGIbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 03:31:45 -0500
Received: from otello.alma.unibo.it ([137.204.24.163]:54738 "EHLO
	otello.alma.unibo.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbYBGIbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 03:31:44 -0500
Message-ID: <47AAC1EE.6060101@otello.alma.unibo.it>
Date: Thu, 07 Feb 2008 09:31:42 +0100
From: Diego Zuccato <diego@otello.alma.unibo.it>
User-Agent: Thunderbird 2.0.0.9 (X11/20080114)
MIME-Version: 1.0
To: David Newall <davidn@davidnewall.com>
Cc: Greg KH <greg@kroah.com>, Christer Weinigel <christer@weinigel.se>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
References: <20080125180232.GA4613@kroah.com>            <20080202123710.42df1aa0@weinigel.se>            <20080202191930.GA19826@kroah.com>            <47A5D895.20300@davidnewall.com>            <47A6E742.80408@otello.alma.unibo.it> <courier.47A8F072.000079E4@hawking.rebel.net.au>
In-Reply-To: <courier.47A8F072.000079E4@hawking.rebel.net.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall ha scritto:

> "Of course", because in many parts of the world, a device who's 
> manufacturer fails to take reasonable steps to prevent it from being 
> used outside regulatory limits is illegal.  Providing source code not 
> only is a failure to take those reasonable steps, but is quite the 
> opposite.  It may even be viewed as encouraging users to use it 
> inappropriately.
If the device is well engineered, there's nothing the sw can do to make 
it work outside regulatory limits.
Sometimes there's simply NOTHING the SW can do to *avoid* it. Think 
about a CB radio. International standard is 5W (well, somewhere it's 3, 
IIRC, but that's another story: nobody produces a special model with a 
final amplifier for only 3W, everyone produces the 5W and turns down 
power in some other way). But linear amplifiers are commonly sold. And 
(at least in Italy) it's not illegal to buy one, even if it can boost 
antenna power to 1000W. It's illegal just to USE it.
If a citizen of a country where only 3W are allowed opens his CB and 
removes the limiter, it makes the use of THAT CB illegal, not the use of 
that MODEL: untampered ones are still legal!

And it's a logical problem, too: why should the *driver* enforce a 
*technical* limit? It's up to the device. If the driver tells my WiFi 
device to use 10W, should it fail? I think so! IMO there's no judge that 
can rule out that an open source driver is encouraging users to use a 
device over its regulatory limits: there are easier ways (like lying 
about the configured country, to get more channels or more power) than 
hacking a driver. Else it should be ruled "reasonable" having to sell 
different drivers in different countries (no user-selectable country to 
choose, no lying possible... as long as the user doesn't download an 
updated driver...).

The key is "reasonable". IMVHO enforcing a limit with a driver is not a 
"reasonable step to prevent use outside regulatory limits". There are 
more effective ways to enforce those limits that costs about the same.

BYtE,
  Diego.

