Return-Path: <linux-kernel-owner+w=401wt.eu-S1758196AbYD2OqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196AbYD2OqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 10:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbYD2Op5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 10:45:57 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:35624 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751188AbYD2Op4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 10:45:56 -0400
X-SourceIP: 80.56.237.116
Subject: Re: [PATCH 3/8] lockdep: fix fib_hash softirq inversion
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: ego@in.ibm.com
Cc: linux-kernel@vger.kernel.org, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20080429130006.GD23562@in.ibm.com>
References: <20080429125659.GA23562@in.ibm.com>
	 <20080429130006.GD23562@in.ibm.com>
Content-Type: text/plain
Date: Tue, 29 Apr 2008 16:45:29 +0200
Message-Id: <1209480329.13978.67.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-29 at 18:30 +0530, Gautham R Shenoy wrote:
> Subject: lockdep: fix fib_hash softirq inversion
> 
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>

This is a false positive, and hence we should not apply this patch.

I think I understand the problem and have an idea on how to fix lockdep,
but I haven't gotten around to actually doing so.

Esp in the light that fixing lockdep isn't a requirement (just a nice to
have) for these other cpu hotplug patches we should drop these patches.

So that is, 1-4 should not be applied to mainline. I'll work on a new
and improved 2 that'll make 3 and 4 unneeded.


