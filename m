Return-Path: <linux-kernel-owner+w=401wt.eu-S964944AbXBLOcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964944AbXBLOcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 09:32:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964942AbXBLOcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 09:32:00 -0500
Received: from [217.111.56.2] ([217.111.56.2]:22671 "EHLO semtex.sncag.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S964946AbXBLOcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 09:32:00 -0500
To: Greg KH <greg@kroah.com>
Cc: Rainer Weikusat <rweikusat@sncag.com>, LKML <linux-kernel@vger.kernel.org>,
       Oleg Verych <olecom@flower.upol.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: unfixed regression in 2.6.20-rc6 (since 2.6.19)
In-Reply-To: <20070204043935.GA8829@kroah.com> (Greg KH's message of "Sat, 3 Feb 2007 20:39:36 -0800")
References: <877ivb2kvc.fsf@semtex.sncag.com>
	<20070125185101.GA26279@kroah.com> <87y7nq131x.fsf@semtex.sncag.com>
	<20070126174828.GA28890@kroah.com> <87d54z1dhb.fsf@semtex.sncag.com>
	<slrnerqjit.f71.olecom@flower.upol.cz>
	<20070129234340.GA6881@kroah.com> <87k5z4za4l.fsf@semtex.sncag.com>
	<20070204043935.GA8829@kroah.com>
From: Rainer Weikusat <rainer.weikusat@sncag.com>
Date: Mon, 12 Feb 2007 15:30:22 +0100
Message-ID: <87abzj5tz5.fsf@semtex.sncag.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:
> On Tue, Jan 30, 2007 at 06:40:10PM +0100, Rainer Weikusat wrote:
>> Greg KH <greg@kroah.com> writes:
>> 
>> [...]
>> 
>> > Rainer's problem is a real bug in the USB driver code, which we need to
>> > work on getting fixed,
>
> Ok, here's an updated version, that should tell us where things are
> going wrong (if they are.)
>
> Can you try this out with debugging enabled for the driver:
> 	modprobe keyspan debug=1
>
> and let me know what the output of the kernel log is when you plug your
> device in?

I can do all sorts of things, but frankly, I just need my device to
work (which it does again, courtesy of myself). Apart from that, this
is still just what a SCO-person would call 'a structural copy' of my
code with no functional changes, especially none that could result in
any additional output. I believe it will work as well. Mine does, so
I am not going to test a different one for the sake of having done so.

If you want to fix it only if you can claim to have written the code,
fine. If you'll never fix it --- fine as well. In either case, I have
already put more time into this as I have available.



