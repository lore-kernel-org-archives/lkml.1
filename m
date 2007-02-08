Return-Path: <linux-kernel-owner+w=401wt.eu-S1161391AbXBHCuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161391AbXBHCuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 21:50:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965678AbXBHCuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 21:50:52 -0500
Received: from raven.upol.cz ([158.194.120.4]:39127 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965650AbXBHCuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 21:50:51 -0500
Date: Thu, 8 Feb 2007 03:59:35 +0100
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, torvalds@osdl.org,
       sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: Re: discussion of Kbuild fixes (kbuild: Kbuild.include avoid using spaces in call arguments)
Message-ID: <20070208025934.GH22699@flower.upol.cz>
References: <20070207165204.GA5537@martell.zuzino.mipt.ru> <Pine.LNX.4.64.0702071846180.14457@scrub.home> <20070207220435.GC22699@flower.upol.cz> <Pine.LNX.4.64.0702080029030.14457@scrub.home> <20070207153848.e02d355d.randy.dunlap@oracle.com> <Pine.LNX.4.64.0702080051520.14457@scrub.home> <20070208012049.GE22699@flower.upol.cz> <Pine.LNX.4.64.0702080301590.14457@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702080301590.14457@scrub.home>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 03:05:41AM +0100, Roman Zippel wrote:
> Hi,
> 
> On Thu, 8 Feb 2007, Oleg Verych wrote:
> 
> > -- `find | sort' in localversion (i insist on split between paths and
> >     files)
> 
> make has dedicated functions for this.

I think, "make" (even whatever shiny new) that particular problem can't
handle. Regexp on *file name* is needed, while PATH must be untouched.
That what i meant with spliting tasks. Stripping strings of wildcards
by "make dedicated functions" is ugly, IMHO. 

Also, what do you think, if someone (very unlikely) will add port of build
system to something different? Clear logic for a "rule" is there, one can
easily make whole `include/config/kernel.release' with that.

> > -- symlinks to /dev/null in option checking -- isn't it better to not
> >    have any (though cached) access to files on filesystem, instead of to
> >    /dev/null? cont.:
> 
> symlinks are not much else than special files.

IMHO, cheap I/O. Yes, that isn't a big benefit, but i don't see anything
against, except, probably, filesystems without support of symlinks.

> > I wish to have more people to work on this (even with just comments),
> > because "Kbuild.include" was only first step to reduce bloated top
> > Makefile. Since then, it seems, Sam have more important things to do.
> 
> The problem is that you mix multiple changes into a single patch,

Yes, from whitespace-issue point of view, that was a huge change (:,

> but since kbuild is very central part that puts everything together,

and patch set didn't make a single release of -mm tree (:

> I don't think it's bad idea to be more conservative, especially if you
> just start to work on it.

.... alone. I think it will be OK, Linus is with us!


Thanks, Roman.

____
