Return-Path: <linux-kernel-owner+w=401wt.eu-S1755546AbXFOPm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbXFOPm2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 11:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750861AbXFOPmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 11:42:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34332 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbXFOPmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 11:42:20 -0400
Date: Fri, 15 Jun 2007 17:42:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michael Poole <mdpoole@troilus.org>
Cc: Daniel Hazelton <dhazelton@enter.net>, Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070615154200.GA17172@elte.hu>
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm> <200706142246.57583.dhazelton@enter.net> <878xal2a0q.fsf@graviton.dyn.troilus.org> <200706150127.18069.dhazelton@enter.net> <87sl8tzaj1.fsf@graviton.dyn.troilus.org> <20070615124039.GB21120@elte.hu> <87fy4tz8dc.fsf@graviton.dyn.troilus.org> <20070615143003.GA8775@elte.hu> <87zm31xo3q.fsf@graviton.dyn.troilus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zm31xo3q.fsf@graviton.dyn.troilus.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael Poole <mdpoole@troilus.org> wrote:

> > I.e. you cannot just cleverly define "source code" to include 
> > something unrelated and then pretend that it's all in one work. And 
> > that's exactly what the GPLv3 does: it creatively defines the 
> > hardware's key into the 'source code' of the software and then asks 
> > for that to be provided _not_ because somehow the key derives from 
> > the software (it clearly does not), but as a "compensation" for the 
> > right to redistribute! I.e. it's trying to extend its scope to some 
> > item that is not part of the software. See?
> 
> No.  The GPL does not care about the hardware's key, as I pointed out 
> in the part of my email that you cut out.  The GPL cares about the key 
> used to generate an integral part of the executable form of the GPLed 
> work.  The executable does not function properly if it lacks that 
> part. [...]

it is a false statement on your part that the executable "does not 
function properly" if it lacks that part. Try it: take out the harddisk 
from the Tivo (it's a bog standard IDE harddisk), put into a nice Linux 
PC, mount it, modify a bit in the kernel image header and it will likely 
still boot just fine on that PC.

now if you put the harddisk back into the Tivo, the Tivo's bootloader 
will refuse to run that modified kernel. So will it (and any Linux 
bootloader) refuse to load the kernel if you corrupt the compressed 
format and the gunzip function finds a CRC error. You cannot run 
arbitrary binaries on hardware without knowing the properties of that 
hardware. One such property of the hardware might be: "i only run 
applications that use at most 500 MB of RAM" - because ... the hardware 
might only have 512 MB of RAM. Another property of the hardware might 
be: "i will only trust and run applications that match a given 
signature". Dont buy that hardware if you dont like its inherent 
limitations!

The modification the GPL talks about is about modification of the SOURCE 
CODE. But if you have a new binary, you have no expectation of being 
able to run that on a piece of hardware. It might or might not run. (for 
example if you modified the software to include a 1 GB static array then 
the software might not work on a system that has only 512 MB of RAM.)

go download the Tivo Linux kernel from:

  http://dynamic.tivo.com/linux/811/linux-2.4.tar.gz

modify and build it. Boot it on your general purpose PC. It will quite 
likely work just fine!

	Ingo
