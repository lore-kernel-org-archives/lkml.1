Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbYKGQ1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbYKGQ1m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 11:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbYKGQ1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 11:27:33 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:24561 "EHLO
	WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbYKGQ1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 11:27:32 -0500
X-BigFish: VPS-55(z21eWz1432R62a3L98dR936eQ4015M1805Mzzzzz32i6bh43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0K9Z1PF-01-18P-01
Date: Fri, 7 Nov 2008 17:26:53 +0100
From: Robert Richter <robert.richter@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: Eric Dumazet <dada1@cosmosbay.com>, Ingo Molnar <mingo@elte.hu>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: linux-2.6.28-rc2 regression : oprofile doesnt work anymore ?
Message-ID: <20081107162651.GP9785@erda.amd.com>
References: <4909F690.9090208@cosmosbay.com> <84144f020810310721x1d1eccbeica5d10608d7b2e57@mail.gmail.com> <20081104181855.GK9785@erda.amd.com> <Pine.LNX.4.64.0811042118460.1597@melkki.cs.Helsinki.FI> <4910CD65.1010301@cosmosbay.com> <49113894.5040806@cosmosbay.com> <49130694.7000007@cosmosbay.com> <20081107130249.GN29626@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081107130249.GN29626@one.firstfloor.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 07 Nov 2008 16:27:18.0249 (UTC) FILETIME=[B3AE7590:01C940F5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.11.08 14:02:49, Andi Kleen wrote:
> 
> Can you please test this patch and see if it solves the problem?
> 
> Thanks,
> -Andi
> 
> ---
> 
> oprofile: Fix p6 counter overflow check
> 
> Fix the counter overflow check for CPUs with counter width > 32
> 
> I had a similar change in a different patch that I didn't submit
> and I didn't notice the problem earlier because it was always
> tested together.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Andi,

your patch fixes the initial bug that stops sampling immediately after
starting. The issue Eric mentions seems to be a different problem. I
am also not able to reproduce this. Your patch on top of rc3 continues
sampling at least for several minutes.

I will apply your fix.

Thanks Andi,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

