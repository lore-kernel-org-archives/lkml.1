Return-Path: <linux-kernel-owner+w=401wt.eu-S1754611AbXFOHR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbXFOHR5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 03:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbXFOHRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 03:17:50 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:60680
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbXFOHRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 03:17:49 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Fri, 15 Jun 2007 03:16:52 -0400
User-Agent: KMail/1.9.6
Cc: Florin Malita <fmalita@gmail.com>, Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
References: <466A3EC6.6030706@netone.net.tr> <20070614234507.GA3860@nostromo.devel.redhat.com> <or1wge6jii.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <or1wge6jii.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706150316.56556.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 June 2007 22:25:57 Alexandre Oliva wrote:
> On Jun 14, 2007, Bill Nottingham <notting@redhat.com> wrote:
> > Alexandre Oliva (aoliva@redhat.com) said:
> >> And since the specific implementation involves creating a derived work
> >> of the GPLed kernel (the signature, or the signed image, or what have
> >> you)
> >
> > Wait, a signed filesystem image that happens to contain GPL code
> > is now a derived work? Under what sort of interpretation does *that*
> > occur?
>
> Is the signature not derived from the bits in the GPLed component, as
> much as it is derived from the key?

Actually, you can't copyright, trademark, or patent a number.  In order to 
copyright something it has to have some creative element.  You also can't 
copyright (or trademark) book titles.  So no, last I checked you can't 
copyright an MD5sum or SHA1sum.

I vaguely recall somebody dredging around for the smallest thing there was a 
legal precedent explicitly affirming you could copyright it, and it was a 
haiku.  So they put an uncompressed ascii haiku in their protocol...

Now if you sign the executable binary, then the binary (as a whole) is a 
derivative work of your copyrighted code etc. ad nauseum pluribus unum and so 
on.  And THAT is due to Apple vs Franklin in 1983:
  http://www.internetlegal.com/impactof.htm
Before which copyright was only guaranteed to apply to source code, not to 
binaries (which are basically big numbers).  That's why everybody distributed 
source code before then: it was the only thing they knew you could enforce a 
copyright on...

IBM's "Object code only" initiative happened around the same time...
  http://landley.net/history/mirror/ibm/oco.html
Along with the AT&T breakup commercializing Unix, the launch of the GNU 
project, and the general rise of "shrinkwrap" software.

(There's this marvelous book called "Legal battles that shaped the computer 
industry" by Lawrence D. Graham, devotes a few pages to Apple vs Franklin.  
Franklin honestly didn't think Apple's binary ROMs were copyrightable.  Just 
as in a 1980 interview with Bill Gates, he couldn't stop somebody from 
printing a book with an annotated printout of the TRS-80 ROMs Microsoft had a 
copyright to.  He sounded kind of pissed about it, actually.  Also young and 
whiny:
Transcript:
  http://slashdot.org/features/00/01/20/1316236.shtml
Audio:
  http://landley.net/history/mirror/ms/gates.mp3
)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
