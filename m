Return-Path: <linux-kernel-owner+w=401wt.eu-S1758258AbYFWNVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258AbYFWNVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 09:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755569AbYFWNVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 09:21:33 -0400
Received: from 1wt.eu ([62.212.114.60]:2026 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755197AbYFWNVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 09:21:32 -0400
Date: Mon, 23 Jun 2008 15:21:18 +0200
From: Willy Tarreau <w@1wt.eu>
To: Matthew <jackdachef@gmail.com>
Cc: greg@kroah.com, Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [ANNOUNCE] Position Statement on Linux Kernel Modules
Message-ID: <20080623132118.GC1369@1wt.eu>
References: <e85b9d30806230602m10b5aa06m2f1c83e1a90a7dac@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e85b9d30806230602m10b5aa06m2f1c83e1a90a7dac@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 03:02:58PM +0200, Matthew wrote:
> Hi Greg,
> 
> I largely agree to this statement,
> 
> there are however some downsides if you're preventing driver
> manufacturers (e.g. nvidia, ...) from the possibility to offer their
> customers proprietary drivers:
> 
> 1) One big and important point for me (and more and more future
> linux-users) is powersaving features on GPUs like powermizer (by
> nvidia) and powerplay (by AMD/ATI) or other hardware. I haven't seen
> this working on newer graphics cards models with the opensource
> drivers to the present day :(

I think that's one of the reasons of Greg's post.

(...)
> if those companies can't use their own closed proprietary drivers
> utilizing patented routines they are "forced" to use

You're wrong here. If they have patented routines, they don't need
their drivers to be closed, since there routines are protected by
patents. And even if they are not patented, not releasing the source
will not prevent a competitor from disassembling the code anyway.
So there's really no point in remaining closed. Some of them might
have signed NDAs before using some technologies, but by this time,
they should have sorted that our.

> they might think over it and switch to another operating system ...

Do you know many products with closed Linux drivers which are not
supported by at least one closed OS ? If they chose to support
Linux, it's not for your pleasure, just because they know they will
sell 5-10% more when a penguin is stuck on the box.

> 2) How will this affect performance, if all of those drivers are
> limited to an user-space interface?
> 
> I'm not a kernel hacker and don't have much insight into the kernel
> and kernel-development, so I can only reflect, what I've read:
> much of you kernel hackers are supposed to have said (read that on
> blogs, forums etc.) that nvidia's drivers are hackish and that it uses
> routines which shouldn't be used by this kind of drivers
> 
> other voices are saying nvidia is doing this because the linux-kernel
> lacks a common interface (yet) which disallows effective usage of the
> graphics cards which would result in abysmal bad performance not using
> their hacking ...

That has nothing to do with open/close. They may as well continue to
use their dirty hacks when the sources are public. That just means that
owners of such cards on other platforms (PPC, etc...) might be able to
build the drivers for those platforms. I think that most users don't
care about the fact that a driver is dirty. They want something which
simply builds for their platform. Also, publishing their dirty hacks
will encourage kernel developers to propose some cleaner alternatives
or to extend the kernel in order to ease integration of such drivers.

Willy

