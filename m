Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbZALKlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbZALKlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 05:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbZALKlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 05:41:10 -0500
Received: from mta23.gyao.ne.jp ([125.63.38.249]:13027 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751861AbZALKlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 05:41:08 -0500
Date: Mon, 12 Jan 2009 19:38:20 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "Mark A. Miller" <mark@mirell.org>, Bernd Petrovitsch <bernd@firmix.at>,
       Leon Woestenberg <leon.woestenberg@gmail.com>,
       Rob Landley <rob@landley.net>, "H. Peter Anvin" <hpa@zytor.com>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Message-ID: <20090112103820.GF28564@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Sam Ravnborg <sam@ravnborg.org>, "Mark A. Miller" <mark@mirell.org>,
	Bernd Petrovitsch <bernd@firmix.at>,
	Leon Woestenberg <leon.woestenberg@gmail.com>,
	Rob Landley <rob@landley.net>, "H. Peter Anvin" <hpa@zytor.com>,
	Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <c384c5ea0901031454n451bc899w166bb146c96f6164@mail.gmail.com> <495FEEAF.5020005@zytor.com> <200901032006.47652.rob@landley.net> <20090104030619.GA21466@linux-sh.org> <c384c5ea0901040223l6e53f041s9f7cdea20c9d1d8d@mail.gmail.com> <1231677939.3517.5.camel@gimli.at.home> <31014a580901111928u586e2246uccf370ff941c8a01@mail.gmail.com> <20090112053552.GA9061@uranus.ravnborg.org> <31014a580901112150x57cd715aj5f42ee19bc28c701@mail.gmail.com> <20090112101803.GB10086@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112101803.GB10086@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 11:18:03AM +0100, Sam Ravnborg wrote:
> On Sun, Jan 11, 2009 at 11:50:31PM -0600, Mark A. Miller wrote:
> > On Sun, Jan 11, 2009 at 11:35 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> > >> There are several other packages which are broken for embedded
> > >> architectures, which I will hopefully attempt to fix by submitting patches
> > >> upstream. But this is why we should be cautious about including new tools
> > >> for compiling the kernel. Sam Ravnborg was correct in that a C program to do
> > >> the work would be the proper way. But by not addressing a currently existing
> > >> problem with an adequate replacement with something that does not exist
> > >> currently, seems faulty.
> > >
> > > Why are "make headers_install" such a crucial thing for your
> > > embedded environmnet?
> > 
> > Sanity check. If the environment cannot replicate itself, then
> > something has been faulty in the cross-compiling stage, that was used
> > to propagate a native environment for the target architecture.
> 
> So you actually build your target toolchain on your target?
> 
This happens in a lot of places, like embedded gentoo ports, where almost
all of the work is sent across distcc to a cross-compilation machine. In
systems that use package management, it is done on the host through
emulation, or painfully cross-compiled.
