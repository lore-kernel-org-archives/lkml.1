Return-Path: <linux-kernel-owner+w=401wt.eu-S1759908AbZDBJKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759908AbZDBJKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 05:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755772AbZDBJKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 05:10:24 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:32942 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755606AbZDBJKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 05:10:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18900.33013.359312.694434@cargo.ozlabs.ibm.com>
Date: Thu, 2 Apr 2009 20:10:13 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] perf_counter: provide generic callchain bits
In-Reply-To: <1238658096.8530.5480.camel@twins>
References: <20090330170701.856843742@chello.nl>
	<20090330171024.254266860@chello.nl>
	<18897.46177.528910.51044@cargo.ozlabs.ibm.com>
	<1238481552.28248.1384.camel@twins>
	<49D1C544.7020403@linux.vnet.ibm.com>
	<18897.56973.324304.995540@cargo.ozlabs.ibm.com>
	<1238508032.8530.278.camel@twins>
	<18898.58399.957182.181124@drongo.ozlabs.ibm.com>
	<1238572744.8530.2541.camel@twins>
	<49D3F7E4.7010308@linux.vnet.ibm.com>
	<1238654631.8530.5361.camel@twins>
	<1238658096.8530.5480.camel@twins>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> Hmm, another idea:
> 
> struct perf_callchain_entry {
>   __u32 total, hv, kernel, user;

That should work - and they could be u16's in fact.

>   __u64 ips[total];
> };

Paul.
