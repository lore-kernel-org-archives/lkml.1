Return-Path: <linux-kernel-owner+w=401wt.eu-S964959AbXBLQj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964959AbXBLQj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:39:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964961AbXBLQj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:39:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52352 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964959AbXBLQj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:39:27 -0500
Date: Mon, 12 Feb 2007 08:37:59 -0800
From: Greg KH <greg@kroah.com>
To: Rainer Weikusat <rainer.weikusat@sncag.com>
Cc: Rainer Weikusat <rweikusat@sncag.com>, LKML <linux-kernel@vger.kernel.org>,
       Oleg Verych <olecom@flower.upol.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: unfixed regression in 2.6.20-rc6 (since 2.6.19)
Message-ID: <20070212163759.GA15603@kroah.com>
References: <877ivb2kvc.fsf@semtex.sncag.com> <20070125185101.GA26279@kroah.com> <87y7nq131x.fsf@semtex.sncag.com> <20070126174828.GA28890@kroah.com> <87d54z1dhb.fsf@semtex.sncag.com> <slrnerqjit.f71.olecom@flower.upol.cz> <20070129234340.GA6881@kroah.com> <87k5z4za4l.fsf@semtex.sncag.com> <20070204043935.GA8829@kroah.com> <87abzj5tz5.fsf@semtex.sncag.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87abzj5tz5.fsf@semtex.sncag.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 03:30:22PM +0100, Rainer Weikusat wrote:
> Greg KH <greg@kroah.com> writes:
> > On Tue, Jan 30, 2007 at 06:40:10PM +0100, Rainer Weikusat wrote:
> >> Greg KH <greg@kroah.com> writes:
> >> 
> >> [...]
> >> 
> >> > Rainer's problem is a real bug in the USB driver code, which we need to
> >> > work on getting fixed,
> >
> > Ok, here's an updated version, that should tell us where things are
> > going wrong (if they are.)
> >
> > Can you try this out with debugging enabled for the driver:
> > 	modprobe keyspan debug=1
> >
> > and let me know what the output of the kernel log is when you plug your
> > device in?
> 
> I can do all sorts of things, but frankly, I just need my device to
> work (which it does again, courtesy of myself). Apart from that, this
> is still just what a SCO-person would call 'a structural copy' of my
> code with no functional changes, especially none that could result in
> any additional output. I believe it will work as well. Mine does, so
> I am not going to test a different one for the sake of having done so.

Well, as others have reported that this fix works for them, I've sent it
on to Linus and will add it to the 2.6.20-stable tree too.

> If you want to fix it only if you can claim to have written the code,
> fine. If you'll never fix it --- fine as well.

I do not claim I have rewritten the code, if you look, you get full
authorship credit for this fix, I just say I restructured it a bit.

> In either case, I have already put more time into this as I have
> available.

If you still have problems, please let me know.

thanks,

greg k-h
