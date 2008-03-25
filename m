Return-Path: <linux-kernel-owner+w=401wt.eu-S1759264AbYCYUIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264AbYCYUIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 16:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754171AbYCYUIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 16:08:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44675 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753791AbYCYUIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 16:08:48 -0400
Date: Tue, 25 Mar 2008 21:08:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       kernel list <linux-kernel@vger.kernel.org>, suresh.b.siddha@intel.com
Subject: Re: [PATCH] x86: pat cpu feature bit setting for known cpus
Message-ID: <20080325200830.GB15330@elte.hu>
References: <200803242324.35357.yhlu.kernel@gmail.com> <47E9003B.5010002@zytor.com> <86802c440803251103taf4c8f2mb674c3d17f3c2345@mail.gmail.com> <20080325190851.GC30998@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080325190851.GC30998@linux-os.sc.intel.com>
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


* Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:

> > >  OK, note previous question: what is the motivation for having 
> > >  this as a whitelist (as opposed to a blacklist)?
> > 
> > Venkatesh could tell?
> 
> Main reason for white-list at this point is not to be side-tracked by 
> real or potential erratas on older CPUs. Focussing on getting the 
> support for this feature on current and future CPUs. If older CPUs 
> have survived all these days without this feature, they should be 
> doing OK.

well, the upside would be that since most testing of Linux kernels is 
done on _old_ hardware (people tend to risk their old hw first ;-), we'd 
get faster convergence of the codebase, even though we have the risk of 
erratas (known and unknown ones alike). Code that artificially limits 
its utility is almost always slow to stabilize.

	Ingo
