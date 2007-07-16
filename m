Return-Path: <linux-kernel-owner+w=401wt.eu-S932582AbXGPX2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582AbXGPX2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 19:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbXGPX2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 19:28:12 -0400
Received: from waste.org ([66.93.16.53]:40264 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755330AbXGPX2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 19:28:11 -0400
Date: Mon, 16 Jul 2007 18:27:55 -0500
From: Matt Mackall <mpm@selenic.com>
To: Rene Herman <rene.herman@gmail.com>
Cc: Ray Lee <ray-lk@madrabbit.org>, Bodo Eggert <7eggert@gmx.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Message-ID: <20070716232755.GD11115@waste.org>
References: <8GtnN-7TG-23@gated-at.bofh.it> <8GVjY-PL-25@gated-at.bofh.it> <E1IA7j1-0000j9-I3@be1.lrz> <469A5D7C.5010904@gmail.com> <Pine.LNX.4.58.0707161523500.25779@be1.lrz> <469BF104.1040703@gmail.com> <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com> <469BF768.6040200@gmail.com> <20070716230719.GC11115@waste.org> <469BFB73.3070105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469BFB73.3070105@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 01:12:51AM +0200, Rene Herman wrote:
> On 07/17/2007 01:07 AM, Matt Mackall wrote:
> 
> >On Tue, Jul 17, 2007 at 12:55:36AM +0200, Rene Herman wrote:
> 
> >>I'm still waiting for larger soft-pages... does anyone in this thread
> >>have a clue on their status?
> >
> >Given that most x86 users won't want anything to do with them, it's not
> >going to help us at all here.
> 
> No idea why not? Is this something you expect, or know, or... ? (and who 
> are users in this context?)

Larger soft pages waste tremendous amounts of memory (mostly in page
cache) for minimal benefit on, say, the typical desktop. While there
are workloads where it's a win, it's probably on a small percentage of
machines.

So it's absolutely no help in fixing our order-1 allocation problem
because we don't want to force large pages on people.

-- 
Mathematics is the supreme nostalgia of our time.
