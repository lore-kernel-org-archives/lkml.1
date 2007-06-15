Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067AbXFOMmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbXFOMmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 08:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbXFOMmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 08:42:12 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:60453 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753838AbXFOMmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 08:42:10 -0400
Date: Fri, 15 Jun 2007 14:42:11 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Alexandre Oliva <aoliva@redhat.com>
Cc: Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sean <seanlkml@sympatico.ca>, Adrian Bunk <bunk@stusta.de>,
       Valdis.Kletnieks@vt.edu, Daniel Hazelton <dhazelton@enter.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070615124211.GA11830@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Alexandre Oliva <aoliva@redhat.com>,
	Jeremy Maitin-Shepard <jbms@cmu.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sean <seanlkml@sympatico.ca>, Adrian Bunk <bunk@stusta.de>,
	Valdis.Kletnieks@vt.edu, Daniel Hazelton <dhazelton@enter.net>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
	debian developer <debiandev@gmail.com>, david@lang.hm,
	Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
References: <alpine.LFD.0.98.0706141153550.14121@woody.linux-foundation.org> <or1wgeco9v.fsf@oliva.athome.lsd.ic.unicamp.br> <alpine.LFD.0.98.0706141311330.14121@woody.linux-foundation.org> <orir9q9rgl.fsf@oliva.athome.lsd.ic.unicamp.br> <alpine.LFD.0.98.0706141424160.14121@woody.linux-foundation.org> <orps3y88ru.fsf@oliva.athome.lsd.ic.unicamp.br> <alpine.LFD.0.98.0706141545470.14121@woody.linux-foundation.org> <orzm326s3w.fsf@oliva.athome.lsd.ic.unicamp.br> <87r6oeytin.fsf@jbms.ath.cx> <orsl8u54pa.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <orsl8u54pa.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 11:31:13PM -0300, Alexandre Oliva wrote:
> I know.  Neither will Linus.  But he says he chose GPLv2 such that he
> could, and the v2 is better than v3 in this regard.  What's wrong with
> this picture?

I'm sure it's a rethorical question - but what is wrong is that
imho the clause that normally is added to any file under the GPL
("... version 2 or higher") is builtin in as a safeguard: If, for
whatever reason, in the future it is discovered that the GPL version
X has a flaw that was not forseen - then it can be 'patched' by
writing a successor, having that released by the FSF and allow
anyone to "upgrade" all GPL-ed software to the new license, as
such having avoided the problems of the said (fictious) flaw.

Therefore, it seems pretty weird to me that LONG before version 3
was written and released, someone purposely would choose to freeze
their software at version 2. Why make it "impossible" to use this
safe-guard? ["impossible" because if you get a signature from every
author where they transfer the authorship rights to you, you can
re-release everything under a different license anyway.  However,
the kernel has so many authors who never signed anything(?) that
this is not possible anymore].

I never knew it was possible to change the "version 2 or higher" into
"only version 2", but I am not a laywer and not into licenses at all,
and I am sure Linus had laywers look into this, so we can take this
as a fact.

The result is simple:

1) A lot of files in the kernel are fixed at version 2.
2) Version 3 is incompatible with version 2 (which I also take
   for granted, having read that in this thread).

Many (or at least important) authors of version-2 files do not
wish to change the license to one that allows it to be transformed
to GPL v3 (ie, add the clause "version 2 or higher". Therefore,
this will not happen.

The result is that it is impossible to accept/add patches that
can not be converted to GPL v2 (ie, which are explicitely version 2
or have the phrase "version 2 or higher").

I think this whole thread has only one purpose:

To "test" if the kernel source is indeed - by LAW - immutable
and fixed to version 2.

Of course, as an unwritten rule, everyone here will respect
Linus' wishes: he is our leader for things like this. But that
is irrelevant when it is about important things like this:
One day he will be gone - and if this license "upgrade" is only
stopped because people see him as a leader, then the discussion
will happen again and again and again - until the software IS
upgraded. This being a one-way lane (once upgraded, you can't
go back) I think it is LOGICAL to do this: 1) Don't upgrade
for as long as possible (possibly forever), 2) Have discussions
like this while Linus is still alive until it is cristal clear that
the kernel can or can not be "upgraded" to version 3 as a result
of the law. And, imho, as I pointed out above - this is already
clear to me (so this thread can end now as far as me is concerned).

Finally - I realize that most people who seem to oppose Linus -
ie Alexandre, and me included, are NOT (perse) in favour of version 3
(I know I am not). The most important purpose of the discussion
is to TEST if someone could force this "upgrade" in the future
when leadership is less clear. So, I think it's good that some
people are willing to take the side of version 3 and try to go
all the way to prove that it's better and/or possible to "upgrade"
etc - as if they REALLY want that.

-- 
Carlo Wood <carlo@alinoe.com>
