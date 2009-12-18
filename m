Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491AbZLRTlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbZLRTlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 14:41:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751203AbZLRTlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 14:41:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51503 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946AbZLRTlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 14:41:47 -0500
Date: Fri, 18 Dec 2009 20:41:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steve Rago <sar@nec-labs.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, Trond.Myklebust@netapp.com,
       Wu Fengguang <fengguang.wu@intel.com>,
       "jens.axboe" <jens.axboe@oracle.com>
Subject: Re: [PATCH] improve the performance of large sequential write NFS
 workloads
Message-ID: <20091218194129.GB6153@elte.hu>
References: <1261015420.1947.54.camel@serenity>
 <1261037877.27920.36.camel@laptop>
 <1261164799.1947.123.camel@serenity>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261164799.1947.123.camel@serenity>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steve Rago <sar@nec-labs.com> wrote:

> > Also, I don't think this needs to have a sysctl, it should just work.
> 
> The sysctl is a *good thing* in that it allows the eager writeback behavior 
> to be tuned and shut off if need be.  I can only test the changes on a 
> finite set of systems, so better safe than sorry.

This issue has been settled many years ago and that's not what we do in the 
Linux kernel. We prefer patches to core code where we are reasonably sure they 
result in good behavior - and then we fix bugs in the new behavior, if any. 

(Otherwise odd sysctls would mushroom quickly and the system would become 
untestable in practice.)

	Ingo
