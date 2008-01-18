Return-Path: <linux-kernel-owner+w=401wt.eu-S1765774AbYARUu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765774AbYARUu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 15:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759797AbYARUuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 15:50:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41344 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757005AbYARUuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 15:50:11 -0500
Date: Fri, 18 Jan 2008 21:49:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: travis@sgi.com, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] x86: Add debug of invalid per_cpu map accesses
Message-ID: <20080118204956.GE3079@elte.hu>
References: <20080118183011.354965000@sgi.com> <20080118183012.050317000@sgi.com> <200801181933.05662.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801181933.05662.ak@suse.de>
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


* Andi Kleen <ak@suse.de> wrote:

> On Friday 18 January 2008 19:30:16 travis@sgi.com wrote:
> > Provide a means to trap usages of per_cpu map variables before they 
> > are setup.  Define CONFIG_DEBUG_PER_CPU_MAPS to activate.
> 
> Are you sure that debug option is generally useful enough to merge? It 
> seems very specific to your patchkit, but I'm not sure it would be 
> worth carrying forever in the kernel.

yeah, i think it's simple enough.

	Ingo
