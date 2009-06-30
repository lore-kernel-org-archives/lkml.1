Return-Path: <linux-kernel-owner+w=401wt.eu-S1753245AbZF3L5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbZF3L5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 07:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbZF3L5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 07:57:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51083 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754962AbZF3L5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 07:57:35 -0400
Date: Tue, 30 Jun 2009 13:57:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf_counter: tools: Make :u and :k exclude
	hypervisor
Message-ID: <20090630115732.GA7611@elte.hu>
References: <19016.41130.429944.316897@cargo.ozlabs.ibm.com> <20090629203443.GH31577@elte.hu> <19017.63611.674927.683004@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19017.63611.674927.683004@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> Ingo Molnar writes:
> 
> > Hm, mind fixing the full range of problems with these flags 
> > please?
> 
> Sure, looking at it now.
> 
> One thing I'd like to do is add complete lists of hardware events 
> for each processor so that perf can tell you the full set of 
> things you can measure, and can let you ask for them without 
> having to know raw event codes. [...]

Excellent.

> [...] I know how to work out which processor we're running on for 
> powerpc; for x86 I assume cpuid or something similar is usable 
> from userspace, is it?

Yeah. /proc/cpuinfo can be read as well.

	Ingo
