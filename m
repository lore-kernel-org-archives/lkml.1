Return-Path: <linux-kernel-owner+w=401wt.eu-S1758800AbYCUO6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800AbYCUO6J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 10:58:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758620AbYCUO5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 10:57:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57950 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758609AbYCUO5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 10:57:47 -0400
Date: Fri, 21 Mar 2008 15:57:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: ak@suse.de, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] - Allow NODES_SHIFT to be a config option on x86_64
Message-ID: <20080321145736.GC1545@elte.hu>
References: <20080321133425.GA11095@sgi.com> <20080321142648.GB31719@elte.hu> <20080321145401.GA10303@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080321145401.GA10303@sgi.com>
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


* Jack Steiner <steiner@sgi.com> wrote:

> On Fri, Mar 21, 2008 at 03:26:49PM +0100, Ingo Molnar wrote:
> > 
> > * Jack Steiner <steiner@sgi.com> wrote:
> > 
> > > Allow the maximum number of nodes in an x86_64 system to be 
> > > configurable. This patch does NOT change the default value but allows 
> > > the value to be a config option.
> > 
> > i've applied your patch - but i'm wondering, shouldnt we auto-scale the 
> > default according to max number of CPUs? (with some sensible scaling 
> > that happens to meet your expected large-system needs as well ;-) All 
> > the current manual configuration of nodes shift is ugly.
> 
> I would prefer to auto-scale, too, but our hardware platform allows 
> too many options to make it easy. The current system configs will 
> support from 0 to 32 cpus per node (some nodes have memory only).
> 
> However, I'm open to suggestions if you have any ideas....

how about scaling for the worst case, and allowing distros to tune down 
if they really want? What's the cost of a too large NODE_SHIFT?

	Ingo
