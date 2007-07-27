Return-Path: <linux-kernel-owner+w=401wt.eu-S934988AbXG0TnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934988AbXG0TnG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 15:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932944AbXG0Tmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 15:42:55 -0400
Received: from [212.12.190.8] ([212.12.190.8]:33191 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932975AbXG0Tmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 15:42:55 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: swap-prefetch:  A smart way to make good use of idle resources (was: updatedb)
Date: Fri, 27 Jul 2007 22:43:02 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707272243.02336.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

People wrote:
> >> I believe the users who say their apps really do get paged back in
> >> though, so suspect that's not the case.
> >
> > Stopping the bush-circumference beating, I do not. -ck (and gentoo) have
> > this massive Calimero thing going among their users where people are
> > much less interested in technology than in how the nasty big kernel
> > meanies are keeping them down (*).
>
> I think the problem is elsewhere. Users don't say: "My apps get paged
> back in." They say: "My system is more responsive". They really don't
> care *why* the reaction to a mouse click that takes three seconds with
> a mainline kernel is instantaneous with -ck. Nasty big kernel meanies,
> OTOH, want to understand *why* a patch helps in order to decide whether
> it is really a good idea to merge it. So you've got a bunch of patches
> (aka -ck) which visibly improve the overall responsiveness of a desktop
> system, but apparently no one can conclusively explain why or how they
> achieve that, and therefore they cannot be merged into mainline.
>
> I don't have a solution to that dilemma either.

IMHO, what everybody agrees on, is that swap-prefetch has a positive effect 
in some cases, and nobody can prove an adverse effect (excluding power 
consumption).  The reason for this positive effect is also crystal clear:  
It prefetches from swap on idle into free memory, ie: it doesn't force 
anybody out, and they are the first to be dropped without further swap-out, 
which sounds really smart.

Conclusion:  Either prove swap-prefetch is broken, or get this merged quick.


Thanks!

--
Al

