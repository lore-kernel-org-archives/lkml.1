Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbZGJIwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbZGJIwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 04:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751064AbZGJIwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 04:52:03 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48186 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbZGJIwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 04:52:03 -0400
Subject: Re: [RFC][PATCH] Check write to slab memory which freed already
 using mudflap
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Janboe Ye <yuan-bo.ye@motorola.com>, linux-kernel@vger.kernel.org,
       vegard.nossum@gmail.com, graydon@redhat.com, fche@redhat.com,
       npiggin@suse.de, cl@linux-foundation.org
In-Reply-To: <20090710084745.GA26752@elte.hu>
References: <1247156020.27671.40.camel@debian-nb>
	 <84144f020907090944u51f60cbsc0a4ec2c2cbdcc8c@mail.gmail.com>
	 <20090710084745.GA26752@elte.hu>
Date: Fri, 10 Jul 2009 11:52:00 +0300
Message-Id: <1247215920.32044.3.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Fri, 2009-07-10 at 10:47 +0200, Ingo Molnar wrote:
> > >  arch/arm/include/asm/elf.h |    1 +
> > >  arch/arm/kernel/module.c   |    1 +
> > >  drivers/Makefile           |    4 +-
> > >  include/mf-runtime.h       |   42 ++++++++++++++
> > >  kernel/Makefile            |    2 +-
> > >  kernel/mudflap.c           |  132 ++++++++++++++++++++++++++++++++++++++++++++
> > >  lib/Kconfig.debug          |    7 ++
> > >  mm/slab.c                  |   53 ++++++++++++++++++
> > >  8 files changed, 240 insertions(+), 2 deletions(-)
> > 
> > SLAB is (slowly) going away so you might want to port this to SLUB 
> > as well so we can merge both.
> 
> and SLQB which will replace both? :-/

Well, I cannot really expect people to port patches to SLQB until it's
in mainline. And whether SQLB will replace SLUB remains to be seen.
We're still fixing minor issues here and there in SLUB so I have no
reason to expect SLQB stabilization to happen overnight which means
we're going to have SLUB in the tree for a while anyway.

			Pekka

