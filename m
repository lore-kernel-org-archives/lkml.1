Return-Path: <linux-kernel-owner+w=401wt.eu-S1755238AbYJTUes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbYJTUes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 16:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753593AbYJTUeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 16:34:07 -0400
Received: from kroah.org ([198.145.64.141]:59293 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753497AbYJTUeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 16:34:04 -0400
Date: Mon, 20 Oct 2008 13:21:47 -0700
From: Greg KH <greg@kroah.com>
To: Alex Howells <alex@bytemark.co.uk>
Cc: Alexandre Oliva <oliva@lsd.ic.unicamp.br>,
       "H. Peter Anvin" <hpa@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Message-ID: <20081020202147.GA20788@kroah.com>
References: <20081016153053.GJ5834@nostromo.devel.redhat.com> <20081016154726.GA6331@kroah.com> <20081016171626.GB22554@cs181140183.pp.htv.fi> <20081017040239.GB28188@kroah.com> <20081017103138.1ca68d17@lxorguk.ukuu.org.uk> <48F8C000.8030003@kernel.org> <20081017174226.GF2221@kroah.com> <48F98DE2.8030205@kernel.org> <ortzb89bak.fsf@oliva.athome.lsd.ic.unicamp.br> <48FCD421.2010208@bytemark.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FCD421.2010208@bytemark.co.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 07:55:29PM +0100, Alex Howells wrote:
> Alexandre Oliva wrote:
>> Not that I care one way or the other.  It's just that I don't see how
>> your response bears any relationship with the point Greg made.  It's
>> just a distraction.  We're talking about how to label releases, not
>> about guessing the release date of a kernel months ahead.  One you
>> label it, it stays that way.
>
> Greg,
>
> I do agree with you that kernel numbering is becoming increasingly 
> cumbersome now the numbers are becoming larger, and a spreadsheet is 
> becoming a handy tool for tracking all this release information.
>
> I'm honestly not sold on any of the naming schemes proposed thusfar, but 
> since I can't come up with a magic solution, I'll shut up about that!
>
> What I'd love to see any changes integrate would be a simple way to spot 
> -stable releases in the version number (ie: 2.6.16, 2.6.27, those 
> maintained for a "long" time and hopefully by 2.6.16.50+ quite 'bug free') 
> versus the rest of releases sent out on a more regular basis.

What do you mean?  The .y marking of releases right now doesn't show you
this?

The "longevity" of a release series has no real correlation to it's "bug
free"ness of it in any strict sense of the word.  Just look at the
percentage of fixes in any normal release for "bugs" to get a concrete
feel for that (hint, it's in the thousands).

> I'll immediately concede this is probably of minimal benefit to 
> distribution maintainers who're actively following LKML and development in 
> general, but there is a big community of folks out there using vanilla 
> kernel.org sources for their own needs who, like me, probably find it 
> difficult/frustrating to pick a kernel version these days.

What is frustrating about it right now?  It is _strongly_ recommended
that if you are following the kernel.org tree, for you to rely on the
-stable releases.  It is best if you can upgrade to the latest branch of
the stable releases when they come out, moving to the latest major
release when possible, as you usually only have a month or so when they
start up before the previous branch's stable tree stops being
maintained.

Some times I think I need to put up a big .SVG drawing of all of the
releases, showing which ones are currently being maintained, and which
ones aren't just to make it easier.  I wonder if firefox could show it
properly, would that help out?

thanks,

greg k-h
