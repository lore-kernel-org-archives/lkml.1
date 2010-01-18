Return-Path: <linux-kernel-owner+w=401wt.eu-S1754356Ab0ARL3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab0ARL3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 06:29:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168Ab0ARL3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 06:29:36 -0500
Received: from mail-qy0-f194.google.com ([209.85.221.194]:47744 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117Ab0ARL3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 06:29:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nXqEopCgQO48PTIKNTCwJkRRQVMapIaz+m1GXONIOyGLwmLOb4dAVsAPFHOaXrILmy
         QFKwNR3ZZAszPZLrtz1gCPT5uhTDV2KhbUAhvjtUKDHqFthO9ncp3d8EcCO3oWJWDflQ
         hex+0oJRpduCvyWtmc5Kzc2b1L1zWsVjudXxw=
Date: Mon, 18 Jan 2010 13:26:22 +0200
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Florian Mickler <florian@mickler.org>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: 2.6.33-rc2: Reported regressions from 2.6.32
Message-ID: <20100118112619.GA8387@redhat.com>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera> <20100116174821.GA18306@redhat.com> <201001162257.16277.rjw@sisk.pl> <alpine.LFD.2.00.1001161402400.13231@localhost.localdomain> <20100117123218.GA3182@redhat.com> <84144f021001170618g708a7c14ob1b222ab1cbdaa20@mail.gmail.com> <20100117161726.5752b181@schatten.dmk.lab> <84144f021001170843s67afae24oaabf09e9b13af8db@mail.gmail.com> <84144f021001170923o30d37becw57ebbd780f63b69e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f021001170923o30d37becw57ebbd780f63b69e@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 17, 2010 at 07:23:35PM +0200, Pekka Enberg wrote:
> On Sun, Jan 17, 2010 at 6:43 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > Hi Florian,
> >
> > (Please don't trim the cc list.)
> >
> > On Sun, Jan 17, 2010 at 5:17 PM, Florian Mickler <florian@mickler.org> wrote:
> >> on which side of the merge? linus or drm?
> >> i.e. it is to be expected to be before the merge, (but on the drm side)
> >> so don't get confused... or did i misunderstood the situation?
> >
> > Like I said, don't read too much into the results but the current
> > situation looks like the regression happened _after_ 2.6.32 but before
> > any of the DRM code was merged to 2.6.33-rc1. I don't think that makes
> > much sense which is why I'm back to testing 2.6.32 more to see if the
> > bug is there already but just harder to trigger for whatever reason.
> 
> OK, confirmed. I can see the "flashing" bug with 2.6.32 as well. It
> just takes more time to trigger than in 2.6.33-rc1. I am going back to
> test 2.6.31 now.


Well, I've been using 2.6.32 day to day since it came out and never saw
this bug there. What do you do to trigger this bug?

-- 
MST
