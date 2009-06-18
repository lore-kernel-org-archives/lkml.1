Return-Path: <linux-kernel-owner+w=401wt.eu-S1759447AbZFRXDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759447AbZFRXDs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 19:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756261AbZFRXDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 19:03:41 -0400
Received: from gate.crashing.org ([63.228.1.57]:43215 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204AbZFRXDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 19:03:40 -0400
Subject: Re: [PATCH 1/6] perf_counter: powerpc: Enable use of software
 counters on 32-bit powerpc
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kumar Gala <galak@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090617142719.GC6846@elte.hu>
References: <19000.55404.103840.393470@cargo.ozlabs.ibm.com>
	 <20090617142151.GB6846@elte.hu>
	 <8C6954A9-BE4C-47F5-AD87-A1D0EAF43F8A@kernel.crashing.org>
	 <20090617142719.GC6846@elte.hu>
Content-Type: text/plain
Date: Fri, 19 Jun 2009 09:03:24 +1000
Message-Id: <1245366204.8693.11.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-17 at 16:27 +0200, Ingo Molnar wrote:
> I think it would be nice to have more platform support in .31. 
> Perfcounters is a brand-new feature so there's no risk of 
> regression. In the end it will depend on Linus to pull of course, 
> and BenH can veto it too if he'd like no more PowerPC changes in 
> this cycle. Worst-case it's all .32 material.

There have been little PowerPC changes in this cycle and I agree
with you on that it's a nice feature to have with little risk of
regression.

In fact, I also have an up-to-date (and hopefully working)
irqtrace/lockdep patch for 32-bit powerpc (we only do 64-bit right now)
that I'm considering merging this time around, the benefit it brings is
worth the risk I believe.

Cheers,
Ben.

