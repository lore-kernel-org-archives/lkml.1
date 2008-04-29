Return-Path: <linux-kernel-owner+w=401wt.eu-S1761044AbYD2HaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761044AbYD2HaN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 03:30:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760768AbYD2H3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 03:29:48 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:50616 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761275AbYD2H3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 03:29:47 -0400
Date: Tue, 29 Apr 2008 10:29:11 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Willy Tarreau <w@1wt.eu>
Cc: "H. Peter Anvin" <hpa@kernel.org>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
Message-ID: <20080429072911.GA28059@cs181133002.pp.htv.fi>
References: <20080428154023.GU2813@cs181133002.pp.htv.fi> <20080428230524.GK8474@1wt.eu> <48167A07.4000305@kernel.org> <20080429050605.GA27875@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080429050605.GA27875@1wt.eu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 07:06:05AM +0200, Willy Tarreau wrote:
> On Mon, Apr 28, 2008 at 06:29:43PM -0700, H. Peter Anvin wrote:
> > Willy Tarreau wrote:
> > >Is this really needed Adrian ? I mean, everyone reads iso-8859-1, not
> > >everyone reads UTF-8.
> > 
> > "Everyone" who speaks a Western European language, perhaps; and even 
> > then, mostly because a lot of tools still have a "oh, it's not valid 
> > UTF-8, guess iso-8859-1" mode.
> 
> Or simply because people have not migrated all their install, or have
> explicitly disabled UTF-8 a few hours after starting to use it once
> they discovered the mess it caused and the poor support from the
> tools :-/

Non-ancient distributions default to UTF-8 and have tools that handle it 
fine.

If you had bad experiences in the last millenium you should try again.

> > The most common instance of non-ASCII 
> > characters in Linux kernel code are people's names, and there are plenty 
> > of names which aren't representable in either ASCII or iso-8859-1.
> > 
> > The debate on this was years ago, and the consensus was to migrate to 
> > UTF-8; however, the salient information should be expressed in the ASCII 
> > character set unless impossible.
> 
> And do we really consider that people's names in *comments* cannot
> be converted to pure ASCII ? I'm western european and have always
> been against accents in comments (another reason to write comments
> in english BTW).

Accents are very rare in names in the kernel.

Most non-ASCII characters are umlauts and there's no sane way to 
express them in ASCII (and the vowels without umlaut are pronounced 
quite differently and might even make names look very strange).

And that's only within European languages, outside it becomes even 
worse.

> Unix and internet have lived without accents for
> almost 30 years without anyone really bothering. And now we try to
> put them everywhere (even in domain names, implying big security
> issues) and it causes real annoyances. People's names have not
> changed in 30 years, so I guess that the rules used during this
> time to ASCII-fy the names are still usable.

The comments in the kernel have been converted to UTF-8 quite some time 
ago, what I'm fixing with my patch is just some recent non-UTF-8 stuff 
that creeped in.

And names in comments in the kernel were not pure ASCII since very 
early, they were in other charsets.

Mostly iso-8859-1, but not all of them.

I remember that for one name we first guessed which character it was and 
then tried to figure out which charset it was in (no, it was not one 
of iso-8859-*).

So it was not "ASCII -> UTF-8", it was
"several different charsets -> UTF-8".

> Willy

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

