Return-Path: <linux-kernel-owner+w=401wt.eu-S1753177AbZALKQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbZALKQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 05:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbZALKQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 05:16:23 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:60059 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbZALKQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 05:16:21 -0500
Date: Mon, 12 Jan 2009 11:18:03 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "Mark A. Miller" <mark@mirell.org>
Cc: Bernd Petrovitsch <bernd@firmix.at>,
       Leon Woestenberg <leon.woestenberg@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>, Rob Landley <rob@landley.net>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Message-ID: <20090112101803.GB10086@uranus.ravnborg.org>
References: <200901020207.30359.rob@landley.net> <c384c5ea0901031454n451bc899w166bb146c96f6164@mail.gmail.com> <495FEEAF.5020005@zytor.com> <200901032006.47652.rob@landley.net> <20090104030619.GA21466@linux-sh.org> <c384c5ea0901040223l6e53f041s9f7cdea20c9d1d8d@mail.gmail.com> <1231677939.3517.5.camel@gimli.at.home> <31014a580901111928u586e2246uccf370ff941c8a01@mail.gmail.com> <20090112053552.GA9061@uranus.ravnborg.org> <31014a580901112150x57cd715aj5f42ee19bc28c701@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31014a580901112150x57cd715aj5f42ee19bc28c701@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 11:50:31PM -0600, Mark A. Miller wrote:
> On Sun, Jan 11, 2009 at 11:35 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> >> There are several other packages which are broken for embedded
> >> architectures, which I will hopefully attempt to fix by submitting patches
> >> upstream. But this is why we should be cautious about including new tools
> >> for compiling the kernel. Sam Ravnborg was correct in that a C program to do
> >> the work would be the proper way. But by not addressing a currently existing
> >> problem with an adequate replacement with something that does not exist
> >> currently, seems faulty.
> >
> > Why are "make headers_install" such a crucial thing for your
> > embedded environmnet?
> 
> Sanity check. If the environment cannot replicate itself, then
> something has been faulty in the cross-compiling stage, that was used
> to propagate a native environment for the target architecture.

So you actually build your target toolchain on your target?

	Sam
