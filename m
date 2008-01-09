Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbYAIP1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbYAIP1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 10:27:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbYAIP1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 10:27:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53603 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbYAIP1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 10:27:02 -0500
Date: Wed, 9 Jan 2008 16:26:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: Arjan van de Ven <arjan@infradead.org>, Dave Airlie <airlied@linux.ie>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, hch@lst.de, pq@iki.fi,
       jbeulich@novell.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "x86: optimize page faults like all other
	achitectures and kill notifier cruft"
Message-ID: <20080109152640.GA21909@elte.hu>
References: <alpine.DEB.0.82.0801090226240.9570@skynet.skynet.ie> <20080108190611.3b9c0760.akpm@linux-foundation.org> <alpine.DEB.0.82.0801090308230.9570@skynet.skynet.ie> <20080109071846.5c672a5c@laptopd505.fenrus.org> <20080109152115.GJ25945@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109152115.GJ25945@bingen.suse.de>
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

> On Wed, Jan 09, 2008 at 07:18:46AM -0800, Arjan van de Ven wrote:
> > On Wed, 9 Jan 2008 03:17:37 +0000 (GMT)
> > Dave Airlie <airlied@linux.ie> wrote:
> > 
> > > So all distros with 2.6.24 kernels are useless to mmiotrace I don't
> > > see why leaving things as is until a suitable replacement mechanism
> > > can be used.. 
> > 
> > you work for a distro.. surely you can convince your own distro to 
> > carry this patch for one release? Maybe if it's this important.. so 
> > can the others...
> 
> But if it's good for a major distribution why is it not good for 
> mainline?

it's a bit too late to get the out-of-tree module into v2.6.24, and the 
revert makes little sense without the extra out-of-tree module. We at a 
minimum need a clear explanation of why this functionality cannot be 
provided via kprobes/systemtap.

> We had this discussion at last kernel summit and the answer was clear.

it's a clear answer 1 week after the merge window opens, but not 1 week 
before the next stable kernel is released.

	Ingo
