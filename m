Return-Path: <linux-kernel-owner+w=401wt.eu-S1753874AbYHTHXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbYHTHXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 03:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbYHTHXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 03:23:06 -0400
Received: from pruts.nl ([82.94.235.106]:36656 "EHLO iron.pruts.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbYHTHXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 03:23:05 -0400
Date: Wed, 20 Aug 2008 09:22:55 +0200
From: Ico Doornekamp <lkml@zevv.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: TIOCGWINSZ retuns old pty size after receiving SIGWINCH
Message-ID: <20080820072255.GL29842@pruts.nl>
References: <20080810150859.GO3653@pruts.nl> <20080819004026.2dac3ba6.akpm@linux-foundation.org> <20080819075414.GV29842@pruts.nl> <20080819010702.c5300420.akpm@linux-foundation.org> <20080819114423.GB29842@pruts.nl> <20080819175639.GI29842@pruts.nl> <20080819120300.91cc6b08.akpm@linux-foundation.org> <20080819201311.GK29842@pruts.nl> <20080819134906.8fe9002e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080819134906.8fe9002e.akpm@linux-foundation.org>
X-Prutser: true
X-PGP-key: 4202FA2F
X-PGP-KeyServer: subkeys.pgp.net
X-PGP-Fingerprint: F042 F5CD B0A6 EC6A CB80  A829 CACD A4B5 4202 FA2F
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



* On 2008-08-19 Andrew Morton <akpm@linux-foundation.org> wrote  :

> On Tue, 19 Aug 2008 22:13:11 +0200 Ico Doornekamp <lkml@zevv.nl> wrote:
> > 
> > > 
> > > This bug may have been present in released kernels for some time - I
> > > think I read in another thread that CPU scheduler changes might have
> > > caused it to surface.  Doesn't matter really - we don't want
> > > user-visible races like this affecting desktop applications in stable
> > > kernels!
> > > 
> > > Can you please help us to complete this list?
> > 
> > 2.6.25.9:	good
> > 2.6.26-rc1	bad ( +/- 10% of the resizes)
> > 2.6.26.2:	still bad ( +/- 10% of the resizes )
> > 2.6.27-rc3:	ugly bad ( > 75% of the resizes )
> > linux-next	good
> > 
> > Any other versions to test ?
> 
> Current Linus mainline has
> 
> commit 8c9a9dd0fa3a269d380eaae2dc1bee39e865fae1
> Author: Alan Cox <alan@redhat.com>
> Date:   Fri Aug 15 10:39:38 2008 +0100
> 
>     tty: remove resize window special case
> 
> which might have fixed this after 2.6.27-rc3, so testing
> ftp://ftp.kernel.org/pub/linux/kernel/v2.6/snapshots/patch-2.6.27-rc3-git6.gz
> would be most interesting.

Still very broken.

-- 
:wq
^X^Cy^K^X^C^C^C^C
