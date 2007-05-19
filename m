Return-Path: <linux-kernel-owner+w=401wt.eu-S1763572AbXESQsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763572AbXESQsS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 12:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbXESQsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 12:48:10 -0400
Received: from ee.oulu.fi ([130.231.61.23]:49790 "EHLO ee.oulu.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755181AbXESQsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 12:48:09 -0400
Date: Sat, 19 May 2007 19:48:03 +0300
From: Pekka Pietikainen <pp@ee.oulu.fi>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Philip Pemberton <usenet07@philpem.me.uk>, linux-kernel@vger.kernel.org
Subject: Re: IPv6: 6to4 tunnel randomly cutting out on 2.6.8.1 - any   patches?
Message-ID: <20070519164802.GA10510@ee.oulu.fi>
References: <f2ifnf$ooh$1@sea.gmane.org> <20070517.143409.102123884.davem@davemloft.net> <f2iif3$3u3$1@sea.gmane.org> <Pine.LNX.4.61.0705190950370.9015@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0705190950370.9015@yvahk01.tjqt.qr>
User-Agent: Mutt/1.4.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2007 at 09:52:57AM +0200, Jan Engelhardt wrote:
> >> >   I'm currently trying to set IPv6 up on a Linux-based router. The
> >> > aforementioned router runs kernel 2.6.8.1, and just about all the
> >> > hardware driver modules are binary modules. For the record, I'd love
> >> > to upgrade the router to one of the newer kernels, but AIUI I can't do
> >> > it because I don't have the source to the bmods. But anyway...
> How can you tell? The binary blobs may have a glitch, flaw, bug, that
> makes them write more-or-less random values to random memory locations,
> thereby inadvertently killing the functionality of other modules (such
> as the ipv6 tunnel).
> 
> If the bug happens without the blobs, _then_ one may start figuring out
> what (non-binary) modules may cause interaction problems with the ipv6
> tunnel (or if it's the tunnel module itself).
Then again, IPv6 in < 2.6.can't remember, but .8 is one of them
_was_ pretty awful. I think it started being okish around .14 or .15?

If you feel like spending lots of time, you could try to shoehorn net/*
from the latest rhel4/centos4 kernel (2.6.9-based) into your router, someone
might have spent the effort fixing the relevant bugs in that tree (but maybe
not, until the 4.5 kernel it used to spew Badness in dst_release at
include/net/dst.h:149 every few seconds if your box was on a ipv6 network :D
)

Personally, I'd get a new router without binary blobs, value of time spent
doing the shoehorning > price of new router, I'm sure, but you may value
your free time differently :)

I do know sixxs ipv6 tunnels are rock solid with openwrt (2.4-based) ;)
