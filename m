Return-Path: <linux-kernel-owner+w=401wt.eu-S1761626AbYBCREg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761626AbYBCREg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 12:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756664AbYBCRE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 12:04:27 -0500
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:58654 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756637AbYBCRE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 12:04:26 -0500
Message-ID: <47A5F418.6030104@weinigel.se>
Date: Sun, 03 Feb 2008 18:04:24 +0100
From: Christer Weinigel <christer@weinigel.se>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
References: <20080125180232.GA4613@kroah.com>	 <20080202123710.42df1aa0@weinigel.se>	 <20080202191930.GA19826@kroah.com>	 <20080203124849.0226560f@weinigel.se> <84144f020802030635h3a9c4304n943d117e936f1c2d@mail.gmail.com>
In-Reply-To: <84144f020802030635h3a9c4304n943d117e936f1c2d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> Why are we discussing this again? The Linux kernel is distributed
> under the GPLv2 and even though there are some legal gray areas
> regarding derived work (think nvidia and ati binary blobs here), the
> license is not friendly towards proprietary drivers at all.

Why?  Because it is a gray area.  I still have my reservations about the 
GPL being as viral as FSF says it is.  Greg KH's lawyer says one thing, 
some legal departments I've talked to say something else (or they 
express it in laywerese, but it boils down to "you can probably get away 
with it") and apparently both nvidia's and ati's legal departmens think 
so too.

And because I belive it's very important not to scare away Linux users 
unneccesarily.  Yes, the kernel does not, and should not be friendly 
towards proprietary drivers, but there is a difference between not being 
friendly and being actively hostile.

> Furthermore, many of the _kernel developers_ do not support
> proprietary drivers, so why do you insist on using Linux for that
> purpose?

You did read the rest of the mail you commented I hope?

> Seriously, you really really want to look at the BSDs or proprietary
> operating systems because they support your needs much better.

So you'd rather have the Nokia 770 use BSD because Nokia couldn't find a 
low power WLAN chip with a GPLed driver?  You'd rather see Nokia spend 
man-years on improving the support for the TI OMAP CPU's somewhere else 
than Linux?  Yes, it sucks that the on WLAN Nokia 770 doesn't have an 
open driver, but I'm very happy that Nokia has spent all that effort on 
getting Linux to run well on the 770 and has given 99% of that work back 
to the Linux community.  (Actually, I think there is a GPLed driver for 
the WLAN now, but that driver would most probably not have been written 
unless the Nokia 770 hardware had been out there so that frustrated 
Linux hackers decided to do something about it).

And why is it ok for nvidia and ati to have proprietary drivers?  Is it 
ok just because people are afraid to alienate them if they push too 
hard?  Having no 3D graphics at all on Linux is a nightmare scenario for 
the distro makers, so I guess that's why people try not to rock the boat 
too much.  So why don't you send in a patch that makes all EXPORTS into 
EXPORT_GPL?  That would be the only honest course of action according to 
you, wouldn't it?

   /Christer
