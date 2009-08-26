Return-Path: <linux-kernel-owner+w=401wt.eu-S1756647AbZHZJpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbZHZJpJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 05:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756518AbZHZJpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 05:45:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:55079 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756506AbZHZJpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 05:45:07 -0400
Subject: Re: [tip:timers/core] timekeeping: Increase granularity of
 read_persistent_clock()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, dwalker@fifo99.com,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <20090825135017.GA31340@elte.hu>
References: <20090822153346.GA3313@elte.hu>
	 <19088.47213.327897.703458@cargo.ozlabs.ibm.com>
	 <20090823084740.GA7651@elte.hu>
	 <19090.1800.521794.839576@cargo.ozlabs.ibm.com>
	 <20090824082318.GD2424@elte.hu>
	 <19091.24374.210127.155521@drongo.ozlabs.ibm.com>
	 <20090825082612.GA17692@elte.hu>
	 <19091.46451.893720.573893@cargo.ozlabs.ibm.com>
	 <20090825101742.GA26801@elte.hu>
	 <19091.52205.222449.441072@cargo.ozlabs.ibm.com>
	 <20090825135017.GA31340@elte.hu>
Content-Type: text/plain
Date: Wed, 26 Aug 2009 19:44:23 +1000
Message-Id: <1251279864.1379.62.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 15:50 +0200, Ingo Molnar wrote:
> 
> Well, me pointing out that such measures slow down the critical path 
> of patch submission is a valid concern - and "you are not forced to 
> do that" pretty much defeats you having suggested it, doesnt it? (i 
> hope i'm not misprepresenting your words)
> 
My problem with you is precisely there.

"The critical path of patch submission"

You seem to consider it a holy objective to shove as much stuff into
Linux as can be produced and as fast as possible. Your previous comment
about not slowing down the process is in the similar vein.

That's something that I would hear out of a corporate executive, not a
Linux kernel hacker and especially not one who is a maintainer.

Changes at all cost is not a panacea, nor are we in some kind of "race"
to get the must stuff in as you can manage. We should take the time to
make sure things are done right, and if a patch has a problem, then fix
the patch and rebase before it hits upstream.

This is good and sane process, nothing else.

Cheers,
Ben.


