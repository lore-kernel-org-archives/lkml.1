Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbXLANL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbXLANL7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 08:11:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbXLANLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 08:11:52 -0500
Received: from mu-out-0910.google.com ([209.85.134.187]:64797 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbXLANLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 08:11:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=TdfquE7m17DeYBoV4s+rYDNxzvxaEDtoT9+mliThgqD+03LEdk++t420SHYCbitnczccuAVTL3Bdw6Ta8Uk6GKEv5LGS9U69Ow5H90ATXvfaQ1zg1r2SfXcD5tzTEl+234X5LJ2NOYJjt2smBHT1vSA4pjFH3KO+0Z956IIMl1M=
Date: Sat, 1 Dec 2007 16:11:40 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: possible BUG: unable to handle kernel NULL pointer dereference
	at virtual address 00000000
Message-ID: <20071201131140.GB28875@cvg>
References: <200711241951.37817.rjw@sisk.pl> <474870F5.4050504@xs4all.nl> <aa79d98a0711270340q5fd6b8a0o5076052a4411e6b2@mail.gmail.com> <474C3659.600@xs4all.nl> <20071127164929.GA7279@cvg> <474C56C8.80206@xs4all.nl> <20071127175503.GC7279@cvg> <47513EE5.30703@xs4all.nl> <20071201121220.GA28875@cvg> <475157CA.2040206@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475157CA.2040206@xs4all.nl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Udo van den Heuvel - Sat, Dec 01, 2007 at 01:47:06PM +0100]
| Cyrill Gorcunov wrote:
| > [Udo van den Heuvel - Sat, Dec 01, 2007 at 12:00:53PM +0100]
| > | I only had teh bug once, that was the reason for my post.
| > | Since then the system has been busy, with intervals, doing kernel
| > | compiles and no repeat of the BUG yet...
| > | It's a VIA EN12000 with 1GB of RAM. How could I increase the chances of
| > | hitting it?
| > 
| > if my guessing is right - the only chance to hit it faster - is to increase
| > files' activity i.e. compiling the kernel involves a lot of file being readed
| > thru dcache system. First we have to locate the bug on a pure kernel
| > and 'case it's a rare thing to happen... well I don't really know how to
| > get it up to known point. So i think you could play with a pure kernel
| > by compiling it or run several copies of 'grep' thru kernel searching
| > the same pattern like "grep -r -n for ./*" in kernel sources. But Udo,
| > I'm not a kernel specialist so my suggestions could be not really usefull ;)
| 
| Ok, maybe someone else can improve on this:
| I now have 12 screen'ed sessions running in /usr/src/linux with:
| while true; do grep -r -n for ./*; done
| 
| Every now and then I can check dmesg.
| 
| Would that be enough?
| 
| Udo
| 

I think yes - it would be enough ;)

		Cyrill

