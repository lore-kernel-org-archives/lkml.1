Return-Path: <linux-kernel-owner+w=401wt.eu-S1760423AbYD2Jo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760423AbYD2Jo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 05:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbYD2JoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 05:44:19 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:57010 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbYD2JoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 05:44:18 -0400
Date: Tue, 29 Apr 2008 12:43:41 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Willy Tarreau <w@1wt.eu>
Cc: "H. Peter Anvin" <hpa@kernel.org>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
Message-ID: <20080429094341.GB19269@cs181133002.pp.htv.fi>
References: <20080428154023.GU2813@cs181133002.pp.htv.fi> <20080428230524.GK8474@1wt.eu> <48167A07.4000305@kernel.org> <20080429050605.GA27875@1wt.eu> <20080429072911.GA28059@cs181133002.pp.htv.fi> <20080429081423.GD30507@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080429081423.GD30507@1wt.eu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 10:14:23AM +0200, Willy Tarreau wrote:
> On Tue, Apr 29, 2008 at 10:29:11AM +0300, Adrian Bunk wrote:
> > On Tue, Apr 29, 2008 at 07:06:05AM +0200, Willy Tarreau wrote:
> > > On Mon, Apr 28, 2008 at 06:29:43PM -0700, H. Peter Anvin wrote:
> > > > Willy Tarreau wrote:
> > > > >Is this really needed Adrian ? I mean, everyone reads iso-8859-1, not
> > > > >everyone reads UTF-8.
> > > > 
> > > > "Everyone" who speaks a Western European language, perhaps; and even 
> > > > then, mostly because a lot of tools still have a "oh, it's not valid 
> > > > UTF-8, guess iso-8859-1" mode.
> > > 
> > > Or simply because people have not migrated all their install, or have
> > > explicitly disabled UTF-8 a few hours after starting to use it once
> > > they discovered the mess it caused and the poor support from the
> > > tools :-/
> > 
> > Non-ancient distributions default to UTF-8 and have tools that handle it 
> > fine.
> > 
> > If you had bad experiences in the last millenium you should try again.
> 
> Well, I accidentally used a freshly installed laptop running mandriva 2008.
> I was typing in a terminal inside KDE (I don't know the program name, sort
> of an xterm, but with huge borders all around). I made a typo in a word and
> typed in a "é" (e acute). Pressing backspace to fix it showed me that I
> remove more chars than typed. I tried again. Pressing this letter 5 times,
> then 10 times backspace. I removed 5 chars from the prompt. I suspect that
> if I had used some chars with wider encoding (eg 4 bytes), I could have
> removed as many... Clearly those tools are not ready.
>...

This sounds as if you had UTF-8 characters in a non UTF-8 environment.

If you did your "explicitly disabled UTF-8" then this is what triggered it.

> > > > The most common instance of non-ASCII 
> > > > characters in Linux kernel code are people's names, and there are plenty 
> > > > of names which aren't representable in either ASCII or iso-8859-1.
> > > > 
> > > > The debate on this was years ago, and the consensus was to migrate to 
> > > > UTF-8; however, the salient information should be expressed in the ASCII 
> > > > character set unless impossible.
> > > 
> > > And do we really consider that people's names in *comments* cannot
> > > be converted to pure ASCII ? I'm western european and have always
> > > been against accents in comments (another reason to write comments
> > > in english BTW).
> > 
> > Accents are very rare in names in the kernel.
> > 
> > Most non-ASCII characters are umlauts and there's no sane way to 
> > express them in ASCII (and the vowels without umlaut are pronounced 
> > quite differently and might even make names look very strange).
> 
> Agreed, but it's been done for *years*. I received mails from people
> spelled "jorn" or "jurgen" and they had no trouble using that spelling
> in their names or mail addresses.

Email addresses are a different topic.

But it's not right in names, and if someone then pronounces their name 
according to the wrong writing the result is also wrong.

> > And that's only within European languages, outside it becomes even 
> > worse.
> > 
> > > Unix and internet have lived without accents for
> > > almost 30 years without anyone really bothering. And now we try to
> > > put them everywhere (even in domain names, implying big security
> > > issues) and it causes real annoyances. People's names have not
> > > changed in 30 years, so I guess that the rules used during this
> > > time to ASCII-fy the names are still usable.
> > 
> > The comments in the kernel have been converted to UTF-8 quite some time 
> > ago, what I'm fixing with my patch is just some recent non-UTF-8 stuff 
> > that creeped in.
> 
> Well, if that had already begun, at least you're standardizing.
>...
> Willy

cu
Adrian

--

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

