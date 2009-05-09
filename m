Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbZEIKou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbZEIKou (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 06:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbZEIKol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 06:44:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49340 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbZEIKok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 06:44:40 -0400
Date: Sat, 9 May 2009 12:44:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: fengguang.wu@intel.com, fweisbec@gmail.com, rostedt@goodmis.org,
       a.p.zijlstra@chello.nl, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com,
       andi@firstfloor.org, mpm@selenic.com, adobriyan@gmail.com,
       linux-mm@kvack.org
Subject: Re: [PATCH 4/8] proc: export more page flags in /proc/kpageflags
Message-ID: <20090509104409.GB16138@elte.hu>
References: <20090508105320.316173813@intel.com> <20090508111031.020574236@intel.com> <20090508114742.GB17129@elte.hu> <20090508132452.bafa287a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090508132452.bafa287a.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 8 May 2009 13:47:42 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Wu Fengguang <fengguang.wu@intel.com> wrote:
> > 
> > > Export all page flags faithfully in /proc/kpageflags.
> > 
> > Ongoing objection and NAK against extended haphazard exporting of 
> > kernel internals via an ad-hoc ABI via ad-hoc, privatized 
> > instrumentation that only helps the MM code and nothing else.
> 
> You're a year too late.  The pagemap interface is useful.

My NAK is against the extension of this mistake.

So is your answer to my NAK in essence:

 " We merged crappy MM instrumentation a short year ago, too bad.
   And because it was so crappy to be in /proc we are now also
   treating it as a hard ABI, not as a debugfs interface - for that 
   single app that is using it. Furthermore, we are now going to 
   make the API and ABI even more crappy via patches queued up in 
   -mm, and we are ignoring NAKs. We are also going to make it even 
   harder to have sane, generic instrumentation in the upstream 
   kernel. Deal with it, this is our code and we can mess it up the 
   way we wish to, it's none of your business."

right?

	Ingo
