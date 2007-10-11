Return-Path: <linux-kernel-owner+w=401wt.eu-S1759224AbXJKVvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759224AbXJKVvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 17:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755464AbXJKVvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 17:51:16 -0400
Received: from pat.uio.no ([129.240.10.15]:36536 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754905AbXJKVvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 17:51:15 -0400
Subject: Re: [PATCH] Documentation/patch-tags v3
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <470E93D3.5050707@s5r6.in-berlin.de>
References: <30616.1192133818@lwn.net>
	 <1192135811.7899.25.camel@heimdal.trondhjem.org>
	 <470E93D3.5050707@s5r6.in-berlin.de>
Content-Type: text/plain
Date: Thu, 11 Oct 2007 17:51:07 -0400
Message-Id: <1192139467.7899.55.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.8, required=12.0, autolearn=disabled, AWL=-0.800)
X-UiO-Scanned: 744D119C2B409C7500D3EF4580E5555715CAA6F7
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -7 maxlevel 200 minaction 2 bait 0 mail/h: 535 total 4441977 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-10-11 at 23:21 +0200, Stefan Richter wrote:
> Trond Myklebust wrote:
> > Does 'Reviewed-by' also imply 'Signed-off-by'?
> 
> Does a technical review include a review of licensing and copyright
> issues?  (It doesn't seem to be a big issue though if the submitter
> signed off on it, like he should.)
> 
> > In other words, who is actually supposed to add this tag?
> > 
> > Is it the reviewer who passes on an officially 'reviewed' patch to the
> > maintainer, or is it the patch author him/herself who is responsible for
> > soliciting reviews and adding the tag?
> 
> Anybody in the patch forwarding chain (author, maintainers... usually
> the latter) can add Acked-by and Tested-by, based on incoming feedback.
> The feedback may have explicitly stated an Acked-by or Tested-by or may
> have said something equivalent.  (In case of Tested-by, an appropriate
> description of how was tested should have been sent.  An explicit
> Tested-by from the tester himself is moot then.)
> 
> Reviewed-by is a different beast.  If Jon's definition of Reviewed-by
> (or another definition) is "officially" adopted, people in the patch
> forwarding chain should only add this tag if the reviewer sent it
> explicitly in his response.  Unlike with Acked-by and Tested-by, we must
> not guess whether a reviewer wants to have his Reviewed-by added.

In that case the reviewer should be made part of the forwarding chain,
and it should be made clear to whoever is upstream that this is a patch
that has not been modified since it was reviewed.

> [...]
> >> + (c) While there may be things that could be improved with this submission,
> >> +     I believe that it is, at this time, (1) a worthwhile modification to
> >> +     the kernel, and (2) free of known issues which would argue against its
> >> +     inclusion.
> >> +
> >> + (d) While I have reviewed the patch and believe it to be sound, I do not
> >> +     (unless explicitly stated elsewhere) make any warranties or guarantees
> >> +     that it will achieve its stated purpose or function properly in any
> >> +     given situation.
> > 
> > I'm confused about how to reconcile (c) and (d) here. If you are not
> > sure about whether or not the patch will achieve its stated purpose, why
> > would you be arguing that it is a worthwhile modification?
> 
> Being sure of something and making guarantees are different things.

To a lawyer, yes. To everyone else, no, and the GPL already tells you
that you are given no warranties.

The reviewed-by tag has, as far as I understand, no legal standing:
unlike the DCE, we're not expecting anyone to be able to sue over this.
So we should at least be trying to ensure that reviewers are 'reasonably
sure' that the patch works. Otherwise, reviews will turn into yet
another coding standards witch hunt of zero value.

Trond

