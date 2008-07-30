Return-Path: <linux-kernel-owner+w=401wt.eu-S1758650AbYG3HV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650AbYG3HV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 03:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbYG3HVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 03:21:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:38461 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbYG3HVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 03:21:18 -0400
Subject: Re: combinatorial explosion in lockdep
From: Peter Zijlstra <peterz@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20080729.235623.211977761.davem@davemloft.net>
References: <20080728235133.GA7956@elte.hu>
	 <20080728.174415.154327359.davem@davemloft.net>
	 <20080729.214503.126934382.davem@davemloft.net>
	 <20080729.235623.211977761.davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 30 Jul 2008 09:21:07 +0200
Message-Id: <1217402467.6364.9.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-29 at 23:56 -0700, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Tue, 29 Jul 2008 21:45:03 -0700 (PDT)
> 
> > If we can agree on this as a fix, it should definitely be backported
> > and submitted for -stable :-)
> > 
> > ----------------------------------------
> > 
> > lockdep: Fix combinatorial explosion in lock subgraph traversal.
> 
> So the next problem I run into is that 8192 is not a large
> enough MAX_LOCKDEP_ENTRIES for this larger cpu count boxes.
> 8192 isn't even big enough for my 64 cpu box.
> 
> It needs to be scaled by NR_CPUS, or something like that.

Or something like that indeed - if distro kernels are going to be build
using NR_CPUS=4096, then these tables might explode - then again,
lockdep is only enabled on -debug kernels anyway...

So yeah.

