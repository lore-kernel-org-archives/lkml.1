Return-Path: <linux-kernel-owner+w=401wt.eu-S1759777AbYARMJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759777AbYARMJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 07:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756388AbYARMJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 07:09:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44997 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756468AbYARMJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 07:09:03 -0500
Date: Fri, 18 Jan 2008 13:08:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: travis@sgi.com, Andi Kleen <ak@suse.de>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86: Fixup NR-CPUS patch for numa
Message-ID: <20080118120840.GE11044@elte.hu>
References: <20080116183438.506737000@sgi.com> <20080116183438.636758000@sgi.com> <20080117103000.5e97dcd2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117103000.5e97dcd2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > Also, the mem -> node hash lookup is fixed.
> > 
> > Based on 2.6.24-rc6-mm1 + change-NR_CPUS-V3 patchset
> 
> hm, I've been hiding from those patches.
> 
> Are they ready?

i'm carrying them in x86.git, and they are pretty robust, with one 
outstanding build failure.

( and i've asked Mike for a CONFIG_SMP_MAX debug option that selects the
  baddest high-end features we have with 1024 or 4096 CPUs, etc. - this 
  way allyesconfig bootups will show us any problems on that scale of 
  the spectrum. )

	Ingo
