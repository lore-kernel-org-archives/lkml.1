Return-Path: <linux-kernel-owner+w=401wt.eu-S1758591AbXFFQeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591AbXFFQeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 12:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753808AbXFFQeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 12:34:44 -0400
Received: from holomorphy.com ([66.93.40.71]:34859 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753203AbXFFQen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 12:34:43 -0400
Date: Wed, 6 Jun 2007 09:35:38 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Mel Gorman <mel@skynet.ie>
Cc: Cedric Le Goater <clg@fr.ibm.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>, aaw@google.com, a.p.zijlstra@chello.nl
Subject: Re: 2.6.22-rc4-mm1
Message-ID: <20070606163538.GN6909@holomorphy.com>
References: <20070606020737.4663d686.akpm@linux-foundation.org> <4666ABD4.8050402@fr.ibm.com> <4666D050.7010603@googlemail.com> <4666DA55.5090405@fr.ibm.com> <20070606162649.GA9932@skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606162649.GA9932@skynet.ie>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 05:26:49PM +0100, Mel Gorman wrote:
> I do not believe this is Nick's problem. I encountered the same issue and
> the bisect ended up here;
> # BISECT HERE
> mm-variable-length-argument-support.patch
> mm-variable-length-argument-support-fix.patch
> # BISECT BAD
> Reverting those two patches boots ok on my standalone x86 laptop.
> Patch authors cc'd. I have not read the patches yet to see what might
> be the problem.

I found this a while ago and peterz already has a tentative fix for it at
http://programming.kicks-ass.net/kernel-patches/max_arg_pages/move_anon_vma.patch
I'm sure he himself will chime in with more/better code when he returns.


-- wli
