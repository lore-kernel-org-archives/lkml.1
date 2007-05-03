Return-Path: <linux-kernel-owner+w=401wt.eu-S1030942AbXECKri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030942AbXECKri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 06:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031141AbXECKri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 06:47:38 -0400
Received: from opal.biophys.uni-duesseldorf.de ([134.99.176.7]:59605 "EHLO
	opal.biophys.uni-duesseldorf.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030942AbXECKrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 06:47:37 -0400
Date: Thu, 3 May 2007 12:47:12 +0200 (CEST)
From: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>
To: Christoph Hellwig <hch@infradead.org>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Michael Schmitz <schmitz@debian.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch 04/33] m68k: Atari keyboard and mouse support.
In-Reply-To: <20070501205740.GC21080@infradead.org>
Message-ID: <Pine.LNX.4.58.0705031236150.8342@xplor.biophys.uni-duesseldorf.de>
References: <20070501203234.252205858@mail.of.borg> <20070501203330.172479999@mail.of.borg>
 <20070501205740.GC21080@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007, Christoph Hellwig wrote:

> What's the reason for splitting this up?  Things would be a quite a bit
> simpler if all the code was directly in atakeyb.c.

Simple: I assumed that keeping the input driver code with the other input
stuff was the Right Thing. I can move everything back to atakeyb.c if
that's preferred.

> > +/*
> > + * linux/atari/atakeyb.c

Shall I update that path, then? :-)

Honestly - no one had worked on the Atari code for years, and my number
one priority was to get it back into functional state. I'll keep your
suggestions in mind when merging the low-level and input parts.

	Michael
