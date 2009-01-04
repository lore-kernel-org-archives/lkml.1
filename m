Return-Path: <linux-kernel-owner+w=401wt.eu-S1755766AbZADBf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766AbZADBf1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 20:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbZADBfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 20:35:16 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:41297
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbZADBfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 20:35:14 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Date: Sat, 3 Jan 2009 19:35:10 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; x86_64; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <200901020207.30359.rob@landley.net> <20090102180134.GB5818@uranus.ravnborg.org> <495E6AB1.2060707@zytor.com>
In-Reply-To: <495E6AB1.2060707@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901031935.10968.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 January 2009 13:27:45 H. Peter Anvin wrote:
> Sam Ravnborg wrote:
> > Hi Wookey.
> >
> >> Given the
> >> simplicitly of these patches I can't see any reason not to put them
> >> in
> >
> > Please do NOT do the mistake and think this the same thing.
> >
> > Rob's patch simplyfy the timecost stuff - and will be applied on
> > this merit alone assuming comments will be addressed.
> >
> > But the serie rased anohter topic: shall we ban use of perl
> > for generating a kernel.
> > And this is what primary is discussed and the outcome of
> > that discussion will not prevent patches that stands on their
> > own to be applied.
>
> My personal opinion on this is that this is ridiculous.  Given that you
> need gcc, binutils, make etc. to build the kernel,

I believe Intel's icc builds the kernel, and tinycc previously built a subset 
of the kernel.  The pcc and llvm/clang projects are getting close to being 
able to build the kernel.  Ever since c99 came out, lots of gcc-isms with c99 
equivalents have been swapped over, most of the rest is testing.

> and this is more than
> inherent, you have to have a pretty bloody strangely constrained system
> to disallow Perl, which is as close to a standard Unix utility you can
> get without making it into SuS.

Please show me A) the standard perl implements, B) the second implementation 
of that standard ala IETF guidelines.

> The only *real* motivation I have seen for this is a system that as far
> I can tell is nothing other than a toy, specifically designed to show
> off how little you need to build the kernel.  In other words, it's not a
> practical application, it's a show-off art piece.

I'm glad you think my Firmware Linux project is a work of art, but if you'd 
like to hear directly from my users I can ask them to complain at you in 
person, if you like.  I'm not sure what that would prove, though.

When cross compiling, it's good to have as constrained an environment as 
possible, because otherwise bits of the host system leak into the target 
system.  If you don't tightly control your cross compiling environment, it 
won't work.  That's just about an axiom in embedded development.

I know every single dependency my system has.  I can list them, explicitly.  I 
did this because it's very _USEFUL_ in this context.

Add perl scripts that call cpan, and this is no longer true.

> 	-hpa

Rob
