Return-Path: <linux-kernel-owner+w=401wt.eu-S965700AbXBGSKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965700AbXBGSKG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 13:10:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965701AbXBGSKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 13:10:05 -0500
Received: from raven.upol.cz ([158.194.120.4]:43927 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965700AbXBGSKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 13:10:03 -0500
Date: Wed, 7 Feb 2007 19:18:01 +0100
To: Roman Zippel <zippel@linux-m68k.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Horst Schirmeier <horst@schirmeier.com>,
       Jan Beulich <jbeulich@novell.com>, Daniel Drake <dsd@gentoo.org>,
       Andi Kleen <ak@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [patch 2/3, resend] kbuild: improve option checking, Kbuild.include cleanup
Message-ID: <20070207181801.GF1160@flower.upol.cz>
References: <20070206011819.160359000@flower.upol.cz> <20070206012207.925430000@flower.upol.cz> <Pine.LNX.4.64.0702071529390.14457@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702071529390.14457@scrub.home>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 07, 2007 at 03:36:47PM +0100, Roman Zippel wrote:
> Hi,
> 
> On Tue, 6 Feb 2007, Oleg Verych wrote:
> 
> > -- all checks by shell united in one macro -- checker-shell;
> > -- one disposable output sym. link to /dev/null per shell,
> >    thus no racing, `-Z' is removed;
> > -- modules' build output directory is used, if supplied;
> > -- every option checking function calls shell wrapper, acquires probe;
> > -- `echo -e' bashizm substituted (people with sh != bash have distinct
> >    CC options!);
> > -- some spelling and sense added to the comments;
> > -- small shuffle of whitespace.
> 
> This patch is a bit overloaded and it would be better to split it up

OK (i though so, but file is too small)

> to keep functional changes separate and then please drop the symlink,
> it has no advantage to a simple temp file.

Heh, i still can't understand issue with symlinks ;) OK.

> Also please don't add random whitespace, Makefiles are no C files, so
> different rules apply.

I didn't know i did, conversely removed some trailing ones (in
comments) and some multiline assigments. And i've tried to not touch
rules-sections.

As my first ever patch was open/close top Makefile with
emacs, resulting tabify+trailing-whitespace-delete fail on Andrew's
`make'.

Finally i didn't know it will be commited, my will was -mm for
testing. I'm very sorry, Linus, to bother you with reverting.


Thanks.
____
