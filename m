Return-Path: <linux-kernel-owner+w=401wt.eu-S1756766AbZEDTxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbZEDTxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 15:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbZEDTxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 15:53:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43766 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386AbZEDTxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 15:53:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 0/4] PM: Drop shrink_all_memory (rev. 2) (was: Re: [PATCH 3/3] PM/Hibernate: Use memory allocations to free memory)
Date: Mon, 4 May 2009 21:53:36 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905031830.49690.rjw@sisk.pl> <20090504093310.GC30306@elf.ucw.cz>
In-Reply-To: <20090504093310.GC30306@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905042153.37069.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 May 2009, Pavel Machek wrote:
> Hi!
> 
> > I know that swsusp_shrink_memory() has problems, that's why I'd like to get rid
> > of it.
> > 
> > > I wonder if it's possible to free up the memory within 1s at all.
> > 
> > I'm not sure.
> > 
> > Apparently, the counting of saveable pages takes substantial time (0.5 s each
> > iteration on my 64-bit test box), so we can improve that by limiting the number
> > of iterations.
> 
> We could increase step size after each step. Free in 40MB step, then
> 80MB step, then 160MB step, ...

Why not just one step?  It doesn't seem to hurt performance AFAICS.

Thanks,
Rafael
