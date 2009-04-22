Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbZDVKTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbZDVKTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 06:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754423AbZDVKTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 06:19:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32907 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036AbZDVKTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 06:19:39 -0400
Date: Wed, 22 Apr 2009 12:19:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Huang Ying <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       linux-kernel@vger.kernel.org,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: Re-implement MCE log ring buffer as per-CPU ring buffer
Message-ID: <20090422101911.GB1115@elte.hu>
References: <1240391484.6842.474.camel@yhuang-dev.sh.intel.com> <20090422092259.GC18226@elte.hu> <20090422101600.GL3226@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090422101600.GL3226@erda.amd.com>
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


* Robert Richter <robert.richter@amd.com> wrote:

> On 22.04.09 11:22:59, Ingo Molnar wrote:
> > 
> > * Huang Ying <ying.huang@intel.com> wrote:
> > 
> > > Re-implement MCE log ring buffer as per-CPU ring buffer for better 
> > > scalability. Basic design is as follow:
> > 
> > Before changing anything substantial in the MCE code it would be 
> > necessary to clean up and then unify the 32-bit and 64-bit side 
> > of the MCE code first. (Which essentially means extending the 
> > 64-bit-only code to 32-bit)
> 
> You may also want to consider to use the in-kernel ring_buffer api 
> (include/linux/ring_buffer.h).

Yeah. I'd have suggested that once cleanups and unification is done 
(which is still a long way out :-).

	Ingo
