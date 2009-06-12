Return-Path: <linux-kernel-owner+w=401wt.eu-S932865AbZFLJd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932865AbZFLJd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 05:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757712AbZFLJdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 05:33:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:57996 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754420AbZFLJds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 05:33:48 -0400
Subject: Re: linux-next: origin tree build failure
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, paulus@samba.org,
       ppc-dev <linuxppc-dev@lists.ozlabs.org>
In-Reply-To: <20090612092054.GB32052@elte.hu>
References: <20090612102427.32582baa.sfr@canb.auug.org.au>
	 <1244768406.7172.1.camel@pasglop>  <20090612092054.GB32052@elte.hu>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 19:33:17 +1000
Message-Id: <1244799197.7172.106.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Ah - thanks. The bug was caused by me being a bit too optimistic in 
> applying the shiny-new Power7 support patches on the last day. (nice 
> CPU btw.)

In that case paulus tells me it's actually Peter screwing up moving
something from the powerpc code to generic :-)

 .../...

> Such bugs happen, and they are easy enough to fix. What matters 
> arent the 1-2 short-lived bugs that do happen when a new combination 
> of trees is created, but the long-lived combination bugs and 
> conflicts.

I'm not saying -next would fix world hunger ... but in this case we have
two sets of issues, perfctr and the init ordering change which both got
merged totally bypassing -next... We should at least -try- to follow the
process we've defined, don't you think ?

Cheers,
Ben.


