Return-Path: <linux-kernel-owner+w=401wt.eu-S1161049AbXBTW4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161049AbXBTW4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 17:56:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161052AbXBTW4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 17:56:39 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:43221 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161049AbXBTW4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 17:56:38 -0500
Date: Tue, 20 Feb 2007 23:56:22 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Tilman Schmidt <tilman@imap.cc>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Roman Zippel <zippel@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kbuild: Add the code maturity levels DEPRECATED and OBSOLETE.
Message-ID: <20070220225622.GA8347@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0702181203360.5131@CPE00045a9c397f-CM001225dbafb6> <200702181935.07454.bzolnier@gmail.com> <45DB218E.1080106@imap.cc> <Pine.LNX.4.64.0702201746050.11016@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702201746050.11016@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 05:47:43PM -0500, Robert P. J. Day wrote:
> On Tue, 20 Feb 2007, Tilman Schmidt wrote:
> 
> > On Sun, 18 Feb 2007 19:35:07 +0100, Bartlomiej Zolnierkiewicz wrote:
> > > I think that the patch is useful and that the distinction between
> > > DEPRECATED and OBSOLETE options is quite clear:
> > >
> > > * DEPRECATED == new better code is available, old code scheduled for removal
> > >
> > > * OBSOLETE == no replacement yet but the code is broken by design
> > >   and unreliable, not scheduled for removal yet
> >
> > Is that really the consensus on these definitions? I thought it was
> > more or less the opposite:
> >
> > * DEPRECATED == no (complete) replacement available yet, but it has
> >   been decided that this code is less than optimal and alternatives
> >   should be preferred
> >
> > * OBSOLETE == replacement available, no reason to use this code anymore
> 
> those original definitions above are not quite the way i worded it.
> please consult the submitted patch to see how i phrased it.
> 
> in a nutshell, my idea of deprecated is: perhaps still supported,
> still being used, but there is a better alternative available right
> now and you should consider switching at your convenience.
> 
> obsolete means dead/unsupported/use at own risk.  might still work but
> no guarantees and could be removed at any time.

This is also my understanding. In MIB's the terms are sued more-or-less
as defined by Robert.

	Sam (non-native)
