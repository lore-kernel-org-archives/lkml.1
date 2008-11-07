Return-Path: <linux-kernel-owner+w=401wt.eu-S1753563AbYKGQjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbYKGQjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 11:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbYKGQjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 11:39:10 -0500
Received: from one.firstfloor.org ([213.235.205.2]:57790 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbYKGQjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 11:39:09 -0500
Date: Fri, 7 Nov 2008 17:47:57 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       Robert Richter <robert.richter@amd.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: linux-2.6.28-rc2 regression : oprofile doesnt work anymore ?
Message-ID: <20081107164757.GS29626@one.firstfloor.org>
References: <84144f020810310721x1d1eccbeica5d10608d7b2e57@mail.gmail.com> <20081104181855.GK9785@erda.amd.com> <Pine.LNX.4.64.0811042118460.1597@melkki.cs.Helsinki.FI> <4910CD65.1010301@cosmosbay.com> <49113894.5040806@cosmosbay.com> <49130694.7000007@cosmosbay.com> <20081107130249.GN29626@one.firstfloor.org> <49145B26.4040701@cosmosbay.com> <20081107160553.GR29626@one.firstfloor.org> <491468F1.8070304@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <491468F1.8070304@cosmosbay.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 05:12:33PM +0100, Eric Dumazet wrote:
> Andi Kleen a écrit :
> >On Fri, Nov 07, 2008 at 04:13:42PM +0100, Eric Dumazet wrote:
> >>Andi Kleen a écrit :
> >>>Can you please test this patch and see if it solves the problem?
> >>>
> >>>Thanks,
> >>>-Andi
> >>>
> >>>---
> >>>
> >>>oprofile: Fix p6 counter overflow check
> >>>
> >>>Fix the counter overflow check for CPUs with counter width > 32
> >>>
> >>>I had a similar change in a different patch that I didn't submit
> >>>and I didn't notice the problem earlier because it was always
> >>>tested together.
> >>>
> >>>Signed-off-by: Andi Kleen <ak@linux.intel.com>
> >>>
> >>Thanks Andi
> >>
> >>Unfortunatly, there is still a freeze of NMIS after a while.
> >
> >How long is the while?
> >
> 
> Less than 20 seconds if fully loaded with "tbench 8" on my 8 cpus machine.

I don't have tbench on the test box, but when I load it with a couple
of while true ; do true ; done loops it also continues sampling.

Are you sure it worked in 2.6.27?

-Andi
