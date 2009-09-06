Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbZIFIfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbZIFIfR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 04:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbZIFIfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 04:35:17 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:36520 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbZIFIfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 04:35:16 -0400
Subject: Re: iwlagn: order 2 page allocation failures
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net, Mel Gorman <mel@csn.ul.ie>,
       Andrew Morton <akpm@linux-foundation.org>, cl@linux-foundation.org
In-Reply-To: <200909061028.48442.elendil@planet.nl>
References: <200909060941.01810.elendil@planet.nl>
	 <84144f020909060114s74de2d2y850745dd82ece753@mail.gmail.com>
	 <200909061028.48442.elendil@planet.nl>
Date: Sun, 06 Sep 2009 11:35:16 +0300
Message-Id: <1252226116.11274.10.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-09-06 at 10:28 +0200, Frans Pop wrote:
> On Sunday 06 September 2009, Pekka Enberg wrote:
> > On Sun, Sep 6, 2009 at 10:40 AM, Frans Pop<elendil@planet.nl> wrote:
> > > Got a couple of page allocation failures today while viewing fairly
> > > large images. System was struggling for a bit to reorganize memory
> > > and swap, but nothing really serious. Everything recovered fairly
> > > quickly.
> > >
> > > Anything to look into?
> > >
> > > System: HP 2510p; 2.6.31-rc7-56-g7c0a57d; Debian stable, KDE desktop
> > >
> > > 10:00.0 Network controller [0280]: Intel Corporation PRO/Wireless
> > > 4965 AG or AGN [Kedron] Network Connection [8086:4229] (rev 61)
> >
> > Can you post your .config, please?
> 
> Attached. Thanks.

OK, so SLUB_DEBUG_ON is disabled so it's probably not a SLUB problem.
Mel, there's quite a few page allocation failure reports recently which
makes me wonder if we broke something with the page allocator
optimization patches? Do you think the anti-fragmentation fixlet you did
for nommu would help here?

			Pekka

