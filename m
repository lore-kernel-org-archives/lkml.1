Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbZE0Bd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbZE0Bd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 21:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbZE0BdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 21:33:20 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:55609 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317AbZE0BdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 21:33:19 -0400
Date: Wed, 27 May 2009 10:33:03 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Joe Perches <joe@perches.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/18] MAINTAINERS - Remove L: linux-kernel@vger.kernel.org from all but "THE REST"
Message-ID: <20090527013303.GB8979@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Grant Likely <grant.likely@secretlab.ca>,
	Joe Perches <joe@perches.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <cover.1243131992.git.joe@perches.com> <9f55522f7ab56afcf16d936d06ab2f3a7e699ed5.1243131992.git.joe@perches.com> <fa686aa40905232018x5e6d1d1aofef790dee2e3bfae@mail.gmail.com> <1243135358.3560.1.camel@Joe-Laptop.home> <fa686aa40905232128x475ea76dh861bf4d0fd3e1aef@mail.gmail.com> <1243139947.3560.7.camel@Joe-Laptop.home> <fa686aa40905232151g5ed5bcc8t2f19d63ace2277e7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa686aa40905232151g5ed5bcc8t2f19d63ace2277e7@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 23, 2009 at 10:51:24PM -0600, Grant Likely wrote:
> On Sat, May 23, 2009 at 10:39 PM, Joe Perches <joe@perches.com> wrote:
> > On Sat, 2009-05-23 at 22:28 -0600, Grant Likely wrote:
> >> On Sat, May 23, 2009 at 9:22 PM, Joe Perches <joe@perches.com> wrote:
> >> > On Sat, 2009-05-23 at 21:18 -0600, Grant Likely wrote:
> >> >> Really? ?That makes the assumption that lack of an "L:" tag is
> >> >> equivalent to an "L:linux-kernel" tag, which IMNSHO I don't believe is
> >> >> true.
> >> > Documentation/SubmittingPatches
> >> > 6) Select your CC (e-mail carbon copy) list.
> >> > Unless you have a reason NOT to do so, CC linux-kernel@vger.kernel.org.
> >> Is that actually true in practice? ?At least on linuxppc-dev, very few
> >> patches are cc'd to lkml. ?I don't remember ever being prompted to cc
> >> lkml on all patches, and I haven't been prompting others to do so.
> >
> > Hi Grant.
> >
> > I think cc:ing lkml should be the default for patches.
> 
> Do subsystem maintainers think so?  Unless they do (and tell others
> so), I don't think it will actually happen.  Until that point, I don't
> think the L:linux-kernel lines should be removed.
> 
Ultimately it should come to common sense. If you are only touching
subsystem or architecture-specific code and it's unlikely anyone on l-k
is going to care, or have much to add to it, then there really isn't a
lot of point in mindlessly Cc-ing the list on every change.

The signal to noise ratio on l-k is already limping along without
encouraging people to submit every random patch for review. If you are
told to resubmit and add the list and random people to the Cc, or if you
are at all in doubt over a patch submission, then naturally cc'ing l-k is
the way to go.

In practice we are well beyond the stage of monitoring every single
patch that is going in anyways, these days you are more likely to find an
obscure change in git than you are on the list. If a process problem
arises, it is usually quite easily corrected.

People might disagree, but at least based on the architecture lists, it
is more the exception than the norm that l-k is CCed, and it's only the
odd times when a discussion carries over and someone has to either
summarize or point at archives.

Conversely, if you need to read SubmittingPatches to figure out how to
submit a patch, yes, you are probably better off CCing l-k just to be on
the safe side. As a blanket policy though it makes no sense.
