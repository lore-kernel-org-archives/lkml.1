Return-Path: <linux-kernel-owner+w=401wt.eu-S1763432AbXG0Svz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763432AbXG0Svz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 14:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758445AbXG0Svs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 14:51:48 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:59930 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757348AbXG0Svr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 14:51:47 -0400
Subject: Re: [PATCH] CodingStyle: proscribe do-while without braces.
From: Josh Triplett <josht@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-sparse@vger.kernel.org
In-Reply-To: <20070727112723.131753f9.akpm@linux-foundation.org>
References: <1185485822.4459.1.camel@josh-work.beaverton.ibm.com>
	 <m3abtir95x.fsf@maximus.localdomain>
	 <20070726173501.9ba466ba.akpm@linux-foundation.org>
	 <m3bqdx6dlq.fsf@maximus.localdomain>
	 <1185555916.2642.8.camel@josh-work.beaverton.ibm.com>
	 <20070727112723.131753f9.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 27 Jul 2007 11:52:10 -0700
Message-Id: <1185562330.2642.13.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-27 at 11:27 -0700, Andrew Morton wrote:
> On Fri, 27 Jul 2007 10:05:16 -0700
> Josh Triplett <josht@linux.vnet.ibm.com> wrote:
> 
> > > Sparse warnings... I think it shouldn't complain either, unless
> > > called with extra parameter.
> > 
> > Good point; Sparse shouldn't warn about this by default.  I've turned
> > that off in latest Sparse from Git, so you need to give -Wdo-while or
> > -Wall to get warnings about that.  However, the kernel gives -Wall, so
> > you'll still see the warnings there.
> 
> I believe reeducating sparse was the best fix here.  I think I'll now
> have a quiet accident with codingstyle-proscribe-do-while-without-braces.patch

I didn't just submit the patch because Sparse warns about it.  I
submitted the patch because of the coding style preference that led to
the Sparse warning.

Also, if this really *shouldn't* form part of the kernel style, then the
kernel should use -Wno-do-while with -Wall, or should stop using -Wall.

That said, I don't care all that much about the patch, so I won't push
further for it one way or another.

- Josh Triplett


