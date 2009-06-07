Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbZFGSzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbZFGSzZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 14:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754244AbZFGSzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 14:55:14 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:42455 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbZFGSzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 14:55:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=whS2488Mz0ipfocKmwbODxwB1XuK3IknEW8N+AxYo/mKzUbE44n/LRC2hP6hfu4dOt
         4s2UBr8OQ9x9XTwtLE9D+McsED1biYMb1Dcc2OPaUG4lSXG+pLQW+HPxXKfeaCwm5Ml/
         BDCsPZ1AOrYc5DwdCtR3U/zBZXCd36v5tpMXU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [git pull] IDE fixes
Date: Sun, 7 Jun 2009 21:00:10 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc8-next-20090605-07377-g5acd34e; KDE/4.2.3; i686; ; )
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200906071444.33047.bzolnier@gmail.com> <200906071955.42378.bzolnier@gmail.com> <84144f020906071121k34d6d555i6332d49b0db0fac6@mail.gmail.com>
In-Reply-To: <84144f020906071121k34d6d555i6332d49b0db0fac6@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906072100.10649.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 June 2009 20:21:11 Pekka Enberg wrote:
> Hi Bartlomiej,
> 
> On Sun, Jun 7, 2009 at 8:55 PM, Bartlomiej Zolnierkiewicz
> <bzolnier@gmail.com> wrote:
> > On Sunday 07 June 2009 18:54:08 Pekka Enberg wrote:
> >> Hi Bartlomiej,
> >>
> >> On Sun, Jun 7, 2009 at 6:44 PM, Bartlomiej Zolnierkiewicz
> >> <bzolnier@gmail.com> wrote:
> >> > Honestly, this should be solved on technical basis by somebody posting
> >> > needed libata patches instead of attempts to slow down IDE fixes.
> >>
> >> Nobody is "slowing down" IDE fixes here. Linus explicitly said that
> >> -rc8 is the last release candidate and the next one is going to be
> >> -final. There's absolutely _no way_ this series is appropriate at the
> >> very end of a release cycle.
> >
> > My honest opinion is that it is as appropriate now as it will be 2.6.31.
> >
> > [ I'm still amazed by the amount of *completely* bogus reasons given for
> >  not merging it. ]
> 
> I don't consider this a bogus reason at all:
> 
>  10 files changed, 134 insertions(+), 43 deletions(-)

Since when do we validate code quality based solely on LOC changed? :)

I'm yet to see anybody posting a single code chunk in this whole discussion.

> Just search the LKML archives for the amount of crap other subsystem
> maintainers have gotten from Linus when they've tried to sneak
> something like that after -rc4 or so.

How many of those other patches:

* got tested by the maintainer
* re-audited twice by the maintainer
* reviewed by two other subsystem gurus

Moreover there was no sneaking here at all:

I admitted in the pull request that I'm unsure if this is appropriate
that late in the cycle.

I'm fine with delaying those changes but I'm not fine with attempts to do
it using completely "made up" technical arguments (no risky core changes,
no 2K sector devices affected, no relation to alt_size sysfs interface, no
misrepresenting of feature as a bug fix -- to mention just a few).
