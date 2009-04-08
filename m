Return-Path: <linux-kernel-owner+w=401wt.eu-S1764770AbZDHMXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764770AbZDHMXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759941AbZDHMXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 08:23:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40801 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757986AbZDHMXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 08:23:33 -0400
Date: Wed, 8 Apr 2009 14:23:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PULL] module bogus patch revert
Message-ID: <20090408122307.GC18581@elte.hu>
References: <1239008928.5812.6.camel@marge.simson.net> <200904071722.40781.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904071722.40781.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Monday 06 April 2009 18:38:48 Mike Galbraith wrote:
> > Hi Rusty,
> > 
> > The below rendered modules unloadable, and my bog standard opensuse 11.0
> > x86_64 box became a doorstop.
> ...
> > (nobody else has griped yet and it's already 11:08.  hm)
> 
> Needs MODVERSIONS=y + MODULE_FORCE_UNLOAD=n.
> 
> Thanks for report!
> Rusty.

FYI, this has been in -tip:out-of-tree for two days as 0bcb247, and 
i got no other modules-bustage reports.

	Ingo
