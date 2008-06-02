Return-Path: <linux-kernel-owner+w=401wt.eu-S1754050AbYFBVKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbYFBVKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 17:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbYFBVKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 17:10:34 -0400
Received: from openfortress.nl ([213.189.19.244]:37449 "EHLO fame.vanrein.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751276AbYFBVKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 17:10:32 -0400
Date: Mon, 2 Jun 2008 21:10:27 +0000
From: Rick van Rein <rick@groengemak.nl>
To: Andi Kleen <andi@firstfloor.org>, daniel.blueman@gmail.com, david@lang.hm
Cc: Rick van Rein <rick@groengemak.nl>, linux-kernel@vger.kernel.org
Subject: Re: Future Linux on Bistable Storage
Message-ID: <20080602211027.GB18415@phantom.vanrein.org>
References: <20080602125904.GA15129@phantom.vanrein.org> <87prqzvc17.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87prqzvc17.fsf@basil.nowhere.org>
X-My-Coolest-Hack: http://rick.vanrein.org/linux/badram -> Exploit broken RAM
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Thanks for your responses.  You convinced me I/O initiatilisation cannot
be improved upon.

> unless there has been a breakthrough that I haven't heard about (always
> possible) I seriously doubt that this is the case.

Oh wait... I'm talking of upcoming technologies, not established ones!

> the alternate technologies that I have heard about are either _far_ less
> dense then DRAM (similar to static ram) or require erasing in blocks
> (similar to flash).

NanoRAM for one sounds like it can achieve very high densities and high
speeds in coming years.  A slideshow from a researcher gives numbers:

http://www.imechanica.org/files/Proposal-MNRAM.pdf

100 GHz speeds, 100 T/cm2 -- and it's all bistable so no power is consumed
to keep it going, as is a limitation with DRAM.  With a cm2 of that I don't
think we'd care for a HDD or for DRAM anymore.

> Perhaps one of the more key stepping stones here is execution in place
> (XIP) support [...] Maybe [...] we should consider XIP-for-ramdisk
> (rather than ROM/flash).

That's the sort of thing I was hoping to spark -- I hadn't seen XIP but
it does sound like a limited form of the kind of thing that would integrate
memory/disk into one large bowl of bits.  Thanks for the pointer!

> Anyway, from a mmap() perspective, we'd be logically merging the
> filesystem and pagecache layers and losing a layer of physical
> indirection.

Something like that... a smooth exchange between memory pages and disk
pages, where it would even be possible for a page to be part of both,
a bit like XIP indeed.

> One major difference between disk and RAM is the tradeoffs between size,
> speed, and price. It's highly unlikely that any one technology will ever
> beat all others in both of the usage patterns which are normal for RAM and
> disk in devices considered by their users to be "computers".

I beg to differ.  If the numbers above are anything to go on, that is.
We have a tendency to think of DRAM as something that can grow without
bounds, but its power consumption and consequential dissipation due to
refreshing do limit it, for example when applied in a mobile device.

Refreshes occur ~1000 times a second for all cells in DRAM, AFAIK.
That's rather a lot of data being read and rewritten each second!
No wonder the chips heat up, and consequently cannot be stacked to
form a cubic memory structure.

> I think current ramdisk code skips [buffering disk blocks].

That'd help, but I'm not sure the concepts of memory and ramdisk should
be kept separate if this architecture I am thinking of would come through.


You have helped to answer my question, whether Linux was ready for the
architecture that I talked about: it already contains seedlings for its
support, so it does not seem to conflict with Linux' major architecture.
That's good news!


Thanks,

Rick van Rein
GroenGemak
