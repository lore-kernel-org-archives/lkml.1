Return-Path: <linux-kernel-owner+w=401wt.eu-S1752900AbXC1VAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbXC1VAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 17:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbXC1VAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 17:00:46 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:47284 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752886AbXC1VAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 17:00:45 -0400
Date: Wed, 28 Mar 2007 14:00:44 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: William Lee Irwin III <wli@holomorphy.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [RFC] i386: Remove page sized slabs for pgds and pmds
In-Reply-To: <20070328205055.GX8915@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0703281356080.13258@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0703281309210.12985@schroedinger.engr.sgi.com>
 <20070328205055.GX8915@holomorphy.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2007, William Lee Irwin III wrote:

> Getting the relevant results without tremendous amounts of noise from
> other kernel activity needs something like lmbench's fault and fork()
> microbenchmarks. Also, /proc/profile and/or oprofile results would be
> useful here to get useful notions of what's happening performancewise,
> in particular oprofile with L2 cache miss performance counters.

The machine had a minimal debian root and it was run on a serial console.

> it's in the noise. PMD and PTE caching are only pertinent to fork()
> anyway, so the vast majority of your workload is unaffected, and it's

I'd be interested to see some numbers here. I still believe the situation 
to be better on IA64 and other platforms due to the larger page sizes 
containing many more cachelines which should make the effect bigger.

