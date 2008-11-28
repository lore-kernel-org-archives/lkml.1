Return-Path: <linux-kernel-owner+w=401wt.eu-S1754041AbYK1Pso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbYK1Pso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 10:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbYK1Psd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 10:48:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57315 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbYK1Psb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 10:48:31 -0500
Date: Fri, 28 Nov 2008 16:47:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH] markers: comment marker_synchronize_unregister() on
	data dependency
Message-ID: <20081128154759.GH28138@elte.hu>
References: <20081126123652.GA9446@localhost> <20081126124608.GA22504@Krystal> <20081126130847.GA20988@localhost> <20081127010553.GA11182@localhost> <492DF67A.8090006@cn.fujitsu.com> <20081127013655.GA11866@localhost> <20081127080003.GB25072@Krystal> <20081127081444.GA27642@localhost> <20081127184403.GA15907@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081127184403.GA15907@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> * Wu Fengguang (fengguang.wu@intel.com) wrote:
> > On Thu, Nov 27, 2008 at 10:00:03AM +0200, Mathieu Desnoyers wrote:
> > > * Wu Fengguang (fengguang.wu@intel.com) wrote:
> > > > +
> > > > +marker_synchronize_unregister() must be called before the first occurrence of
> > > 
> > > 
> > > You should probably say 
> > > 
> > > ".. must be called between probe unregistration and the first occurence
> > > of..."
> > > 
> > > Mathieu
> > 
> > That's much better!
> > 
> > With your comments I'd assume you reviewed this patch ;-)
> > 
> > Thanks,
> > Fengguang
> > ---
> > markers: comment marker_synchronize_unregister() on data dependency
> > 
> > Add document and comments on marker_synchronize_unregister(): it
> > should be called before freeing resources that the probes depend on.
> > 
> > Based on comments from Lai Jiangshan and Mathieu Desnoyers.
> > 
> > Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > Signed-off-by: Wu Fengguang <wfg@linux.intel.com>
> 
> It looks good to me, thanks!
> 
> Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

applied to tip/tracing/markers, thanks guys!

	Ingo
