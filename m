Return-Path: <linux-kernel-owner+w=401wt.eu-S934394AbZAPNYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934394AbZAPNYd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 08:24:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761453AbZAPNYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 08:24:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40511 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778AbZAPNYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 08:24:19 -0500
Date: Fri, 16 Jan 2009 14:23:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       roel kluin <roel.kluin@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Brian Gerst <brgerst@gmail.com>, ebiederm@xmission.com,
       rusty@rustcorp.com.au, travis@sgi.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, steiner@sgi.com, hugh@veritas.com
Subject: Re: [patch] add optimized generic percpu accessors
Message-ID: <20090116132344.GB20593@elte.hu>
References: <496C9FB7.9050907@kernel.org> <496D8CEB.5060402@zytor.com> <20090114093834.GA19799@elte.hu> <25e057c00901150204x61c54d9fl91afe23477d1f12f@mail.gmail.com> <496F0F5E.3080404@kernel.org> <20090115113230.GH22850@elte.hu> <496F1FA6.6050204@kernel.org> <20090115122222.GI22850@elte.hu> <Pine.LNX.4.64.0901151430470.28153@quilx.com> <4970564F.8030004@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4970564F.8030004@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Christoph Lameter wrote:
> > On Thu, 15 Jan 2009, Ingo Molnar wrote:
> > 
> >>  - i standardized the commit logs to the usual x86 style and added
> >>    Original-From: Mike Travis tags to those patches that were derived from
> >>    Mike's patches.
> > 
> > Most of that is based on earlier patches by me.
> 
> Sorry, I didn't know that.  Ingo, please feel free to re-base the tree 
> with updated credits.

Sure, i've rebased it and added this to the front of every affected patch:

[ Based on original patch from Christoph Lameter and Mike Travis. ]

I've also first pulled your latest tree, please base new changes and new 
pull requests on the tip/x86/percpu tree i just pushed out.

I also merged tip/x86/percpu into tip/master and resumed testing it.

I suspect the next step will be to integrate Brian's "get rid of the rest 
of the PDA" patches?

	Ingo
