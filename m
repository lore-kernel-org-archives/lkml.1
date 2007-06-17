Return-Path: <linux-kernel-owner+w=401wt.eu-S1759443AbXFQFPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759443AbXFQFPS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 01:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbXFQFPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 01:15:06 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37712 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517AbXFQFPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 01:15:05 -0400
Date: Sun, 17 Jun 2007 06:14:51 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Alexandre Oliva <aoliva@redhat.com>
Cc: Daniel Hazelton <dhazelton@enter.net>, Bron Gondwana <brong@fastmail.fm>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070617051451.GD21478@ftp.linux.org.uk>
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br> <200706161817.36657.dhazelton@enter.net> <orodjfmjsr.fsf@oliva.athome.lsd.ic.unicamp.br> <200706162306.14516.dhazelton@enter.net> <orwsy3l0jv.fsf@oliva.athome.lsd.ic.unicamp.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <orwsy3l0jv.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2007 at 12:31:00AM -0300, Alexandre Oliva wrote:
 
> I'm not trying to say why Linus and others chose the GPLv2.
> 
> I'm not trying to determine what their motivations were.
> 
> I'm not trying to force them to change to GPLv3.
> 
> I'm not trying to convince them that tivozation is a bad thing.
> 
> I'm only trying to show that anti-tivozation is in line with the
> spirit of the GPL.
 
... and anti-tivoization section shows all symptoms of going in wrong
direction, *whether* *tivo* *is* *good* *or* *not*.  It's full of
kludges exactly because it tries to carve out a notion that can only
be determined on case-to-case basis and not by generic definition.
And no, that's not a matter of bad wording in that section.

I don't _care_ whether it breaks spirit, etc. - it's a fundamentally bad
idea for completely independent reasons.  Even if one thinks that tivo
in particular ought to be sued into the ground at some point.

Besides, it's fscking *pointless* for userland stuff.  If you insist that
e.g. glibc will infect by linking, you've just created a huge problem for
any GPLv2 userland code, which will make all bad blood about kernel look
trivial in comparison.  If you do not, then you've lost all leverage anyway;
kernel won't switch, libraries are OK, toolchain is obviously OK for building
code with any license... what's left?  The glorious /bin/cp?  Sorry, it would
work as usual, subject to open(2) not returning EACCES.  Just as on any
system.  Just what is it going to prevent?  Hell, they can slap selinux on
the box, protect what they want to protect, use crypto-loop to prevent offline
modifications of filesystem and hide the key in firmware.

Either GPLv2 is sufficient in given case (and e.g. Alan decides to go
after company in question), or you've at most created a moderate amount
of work rewriting the checks they are doing into a different form (if
that).  Good job.  In the meanwhile, you've got a load of ill-defined
verbiage around installation instructions.  I.e. a lovely fodder for
potential abusers.

Sod it.  GPLv3, with your involvement in its development or not, sucks
rocks, thanks to what you call anti-tivoization section.

-- 
How many GPL spirits can dance on the end of a pin?
