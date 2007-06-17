Return-Path: <linux-kernel-owner+w=401wt.eu-S1751989AbXFQPJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989AbXFQPJA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 11:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbXFQPIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 11:08:51 -0400
Received: from DELFT.AURA.CS.CMU.EDU ([128.2.206.88]:35595 "EHLO
	delft.aura.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbXFQPIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 11:08:50 -0400
Date: Sun, 17 Jun 2007 11:08:19 -0400
To: Alexandre Oliva <aoliva@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Rob Landley <rob@landley.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070617150819.GI14788@delft.aura.cs.cmu.edu>
Mail-Followup-To: Alexandre Oliva <aoliva@redhat.com>,
	Ingo Molnar <mingo@elte.hu>, Rob Landley <rob@landley.net>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Daniel Hazelton <dhazelton@enter.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
	david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <466A3EC6.6030706@netone.net.tr> <20070614122031.4751a52b@the-village.bc.nu> <20070614122546.GB22078@elte.hu> <200706141907.11957.rob@landley.net> <20070615120926.GD6269@elte.hu> <orvedp121p.fsf@oliva.athome.lsd.ic.unicamp.br> <20070615214804.GC4996@elte.hu> <or3b0svjc5.fsf@oliva.athome.lsd.ic.unicamp.br> <20070617073820.GA6267@elte.hu> <ory7ijhu4q.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ory7ijhu4q.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Jan Harkes <jaharkes@cs.cmu.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2007 at 05:17:57AM -0300, Alexandre Oliva wrote:
> Just make the tivoization machinery require two keys: one that the
> vendor keeps, one that the vendor gives to the user (maybe without
> ever knowing it).  Neither one can install modifications alone, but
> the user can approve modifications by the vendor, and the vendor can
> approve modifications by the user.  This is still not ideal, but it at
> least doesn't permit the vendor to remove features from under the
> user.

So what features has Tivo removed (or threatened to remove) from the GPL
licensed parts? I think at some point they disabled the _undocumented_
skip feature in their own proprietary software, and ended up reenabling
it when a lot of customers complained. Even if those customers had the
ability to replace any GPL licensed parts, it would not have reenabled
the feature. And it was an undocumented easter egg type thing at that,
it isn't like they widely announced it in their advertising or as a
selling point.

So Google is using Linux right. What if they remove some feature? (let's
pick a randomg one, i.e. phone number lookup) Should I get a keycard for
their machine room to fix the problem, or maybe we should use some
secret sharing mechanism to prevent them from removing the feature.

> RMS does not want TiVo (or anyone else) to disrespect users' freedoms,
> and installing technical measures to prevent users from adapting the
> software to suit their needs and running their modifications is
> disrespecting users freedoms.

So if Tivo would allow you to boot your own kernel, but keeps the
harddisk encrypted if the booted kernel does not have the right
signature? In such a case you can run your own kernel and if you replace
the harddrive you can install all the applications you might want. You
cannot however use their software, any of the recorded content or obtain
any further guide data/service updates.

And how is that any different from taking an off-the-shelf PC and
booting your own kernel with Tivo's modifications? Or really different
from the current situation.

Tivo complied in as far as they made GPL licensed code available, you
can examine it, modify it, compile it. You just can't use it _in
combination with TiVo's own software and service_. I didn't think the
GPLv2 covered anything related to use and you have retained all the
freedoms the GPL promises.

> That he is not opposed to the idea of TiVo using a GPLv3 kernel is
> easy to see, if you take the time to read the draft instead of
> spreading false assumptions about it:
> 
>   this requirement does not apply if neither you nor any third party
>   retains the ability to install modified object code on the User
>   Product

So they keep the system locked down, but include perl/python/emacs and
distribute updates in the form of scripts/source code which are either
interpreted or compiled to a ramfs filesystem at boot. Time to add
another exception?

Jan

