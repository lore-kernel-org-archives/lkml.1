Return-Path: <linux-kernel-owner+w=401wt.eu-S1756637AbXKFTk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbXKFTk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 14:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbXKFTkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 14:40:49 -0500
Received: from 1wt.eu ([62.212.114.60]:3724 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754353AbXKFTks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 14:40:48 -0500
Date: Tue, 6 Nov 2007 20:40:09 +0100
From: Willy Tarreau <w@1wt.eu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ray Lee <ray-lk@madrabbit.org>,
       Bo =?iso-8859-1?Q?Brant=E9n?= <bosse@acc.umu.se>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: x86_64 ten times slower than i386
Message-ID: <20071106194009.GC1045@1wt.eu>
References: <Pine.A41.4.64.0711031329490.397338@stalin.acc.umu.se> <20071103162640.GS17536@waste.org> <Pine.A41.4.64.0711032334170.770224@stalin.acc.umu.se> <Pine.A41.4.64.0711051110530.803034@stalin.acc.umu.se> <Pine.A41.4.64.0711051657440.291004@stalin.acc.umu.se> <2c0942db0711050832t5207ea8bib1f75e59e071ade2@mail.gmail.com> <20071106002647.GA27182@one.firstfloor.org> <472FC130.40605@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <472FC130.40605@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2007 at 05:19:44PM -0800, H. Peter Anvin wrote:
> Andi Kleen wrote:
> >>Jesse Barnes (cc:d) wrote a patch to address this, I think (x86: trim
> >>memory not covered by WB MTRRs), but as far as I can tell it hasn't
> >>been merged yet. System is Intel, 4gb of RAM.
> >
> >It wasn't merged because it broke booting on some systems.
> >Besides the memory would be still lost -- all it did was to automate
> >the "mem=XXXX" line.
> 
> There really are only two ways to deal with this -- drop the memory 
> (which should be automated, and a warning printed) or adjust the MTRRs. 
>  The problem is that at some point we run out of MTRRs, partially 
> because they're masks instead of base/limit.

Just out of curiosity, what would be the problem if the MTRRs covered more
than the memory size ? For instance, instead of having 512 MB at 4G, why
not have 1G at 4G ?

regards,
Willy

