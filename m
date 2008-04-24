Return-Path: <linux-kernel-owner+w=401wt.eu-S1756018AbYDXB6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbYDXB6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 21:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbYDXB6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 21:58:31 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:37555 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbYDXB6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 21:58:30 -0400
Date: Thu, 24 Apr 2008 07:28:14 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, vatsa@in.ibm.com,
       dmitry.adamushko@gmail.com, efault@gmx.de,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/2] sched: higher granularity load on 64bit
	systems
Message-ID: <20080424015814.GA17190@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <1208988476.2849.8.camel@lappy> <20080423.172710.152976766.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080423.172710.152976766.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 05:27:10PM -0700, David Miller wrote:
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Thu, 24 Apr 2008 00:07:56 +0200
> 
> > The below is an RFC because for some reason it regresses kbuild by 5% on
> > my machine (and more on the largesmp that are the reason for it).
> 
> This causes my 64-cpu Niagara2 box to completely hang when I run "make
> clean" on a kernel tree after a fresh bootup.
> 

Any traces? Or anything? It stayed pretty stable on the 128 way I trying
on, (but for the performance regression) and I was able to reproduce
your group scheduler hang (or so i think, it might a separate one
altogether.)

> Can we just revert all of this broken code until it's sorted out? :-/
> 
> We're going on 4 days with unfixed major regressions from the
> scheduler tree merge, and these regressions make systems unusable.
> 
> This is blocking my own work, and I'm starting to lose my patience.

-- 
regards,
Dhaval
