Return-Path: <linux-kernel-owner+w=401wt.eu-S1756408AbZCaLty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408AbZCaLty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 07:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbZCaLtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 07:49:43 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:46094 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750923AbZCaLtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 07:49:42 -0400
X-BigFish: VPS-51(zz1432R9370P62a3L98dR936eQ4015M1805M936fKzz1202hzzz32i6bh43j)
X-WSS-ID: 0KHDCUF-03-B7Y-01
Date: Tue, 31 Mar 2009 13:49:26 +0200
From: Robert Richter <robert.richter@amd.com>
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Russell King <rmk@arm.linux.org.uk>, oprofile-list@lists.sf.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] oprofile: Thou shalt not call __exit functions from
	__init functions
Message-ID: <20090331114925.GG3226@erda.amd.com>
References: <20090329161222.GA3601@flint.arm.linux.org.uk> <200903301047.27887.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <200903301047.27887.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 31 Mar 2009 11:49:26.0846 (UTC) FILETIME=[BE3C3DE0:01C9B1F6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.03.09 10:47:27, Rusty Russell wrote:
> On Monday 30 March 2009 02:42:22 Russell King wrote:
> > `buffer_sync_cleanup' referenced in section `.init.text' of arch/arm/oprofile/built-in.o: defined in discarded section `.exit.text' of arch/arm/oprofile/built-in.o
> > 
> > Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

There is patch 4c50d9ea9ca9e46b65aeffed3e0d6f54ff38c8d4 in
tip/cpus4096 that reworks and fixes this code already. It should go
upstream too.

-Robert

> 
> Thanks, I've applied it in case the oprofile people don't get there first.
> 
> Cheers,
> Rusty.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

