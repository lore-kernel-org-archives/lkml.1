Return-Path: <linux-kernel-owner+w=401wt.eu-S1753926AbXLAMrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbXLAMrV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 07:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbXLAMrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 07:47:10 -0500
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4337 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbXLAMrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 07:47:09 -0500
Message-ID: <475157CA.2040206@xs4all.nl>
Date: Sat, 01 Dec 2007 13:47:06 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: possible BUG: unable to handle kernel NULL pointer dereference
 at virtual address 00000000
References: <47481590.8090009@xs4all.nl> <200711241951.37817.rjw@sisk.pl> <474870F5.4050504@xs4all.nl> <aa79d98a0711270340q5fd6b8a0o5076052a4411e6b2@mail.gmail.com> <474C3659.600@xs4all.nl> <20071127164929.GA7279@cvg> <474C56C8.80206@xs4all.nl> <20071127175503.GC7279@cvg> <47513EE5.30703@xs4all.nl> <20071201121220.GA28875@cvg>
In-Reply-To: <20071201121220.GA28875@cvg>
X-Enigmail-Version: 0.95.5
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> [Udo van den Heuvel - Sat, Dec 01, 2007 at 12:00:53PM +0100]
> | I only had teh bug once, that was the reason for my post.
> | Since then the system has been busy, with intervals, doing kernel
> | compiles and no repeat of the BUG yet...
> | It's a VIA EN12000 with 1GB of RAM. How could I increase the chances of
> | hitting it?
> 
> if my guessing is right - the only chance to hit it faster - is to increase
> files' activity i.e. compiling the kernel involves a lot of file being readed
> thru dcache system. First we have to locate the bug on a pure kernel
> and 'case it's a rare thing to happen... well I don't really know how to
> get it up to known point. So i think you could play with a pure kernel
> by compiling it or run several copies of 'grep' thru kernel searching
> the same pattern like "grep -r -n for ./*" in kernel sources. But Udo,
> I'm not a kernel specialist so my suggestions could be not really usefull ;)

Ok, maybe someone else can improve on this:
I now have 12 screen'ed sessions running in /usr/src/linux with:
while true; do grep -r -n for ./*; done

Every now and then I can check dmesg.

Would that be enough?

Udo
