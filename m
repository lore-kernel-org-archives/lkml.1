Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548AbYEAHFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbYEAHFe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 03:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753859AbYEAHFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 03:05:24 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56425 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbYEAHFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 03:05:23 -0400
Subject: Re: [PATCH 0/1] Embedded Maintainer(s), linux-embedded@vger list
From: David Woodhouse <dwmw2@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tim Bird <tim.bird@am.sony.com>
In-Reply-To: <20080430233431.GL29330@cs181133002.pp.htv.fi>
References: <1209577322.25560.402.camel@pmac.infradead.org>
	 <20080430233431.GL29330@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 01 May 2008 08:04:55 +0100
Message-Id: <1209625495.25560.466.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-1.fc9) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-01 at 02:34 +0300, Adrian Bunk wrote:
> On Wed, Apr 30, 2008 at 06:42:02PM +0100, David Woodhouse wrote:
> > Andrew Morton has been saying recently that we need an 'embedded
> > maintainer', to take responsibility for 'embedded issues' in the core
> > kernel, as well as trying to improve our relationship with those using
> > the Linux kernel for 'embedded' devices -- who have a reputation of
> > not working with us very closely; to their detriment as well as our
> > own.
> > 
> > Various people, including myself, have been doing that kind of thing
> > on and off over the years anyway, but Andrew is probably right that
> > it's worth having someone listed in the MAINTAINERS file who actually
> > considers it their responsibility, and as a point of contact for
> > people seeking advice, review, etc.
> >...
> 
> MAINTAINERS is mostly for finding the right contact for bug reports and 
> patches.
> 
> For what should I Cc you and for what should I Cc you not?

The rôle of 'embedded maintainer' is a little different to other
maintainers -- it's not about owning a certain part of the code. We need
to keep an eye on changes throughout the kernel, for how they affect
embedded systems. That's not just 'bloatwatch', but other things too --
making sure that people don't keep assuming that "all the world's a PC",
for sure, but also feature requests -- talking to those working on XIP
for S390 block devices, and trying to ensure that the infrastructure
work they do is useful for XIP from flash in embedded systems, to pick
an example from the not-so-distant past.

So I can't really give you a simple answer to the question. It's
"anything which could have implications for embedded systems which
normal people might not have thought of". But I'll continue to trawl
linux-kernel with that mindset anyway, so I wouldn't worry _too_ much.

I see the linux-embedded list being mostly useful in bringing developers
"into the fold" from companies who have largely been resistant to being
part of the community. Asking them to join linux-kernel is probably not
a good idea; I see it as a kind of targeted kernelnewbies, in one sense.

-- 
dwmw2

