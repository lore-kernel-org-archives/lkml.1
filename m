Return-Path: <linux-kernel-owner+w=401wt.eu-S1757132AbZAVRlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132AbZAVRlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 12:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754233AbZAVRlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 12:41:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36481 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070AbZAVRlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 12:41:07 -0500
Date: Thu, 22 Jan 2009 18:40:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Robert Richter <robert.richter@amd.com>, Tony Luck <tony.luck@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] cpumask: modifiy oprofile initialization
Message-ID: <20090122174045.GA22992@elte.hu>
References: <20090122131153.GP21604@erda.amd.com> <1232630055-32451-1-git-send-email-robert.richter@amd.com> <20090122133729.GB26529@elte.hu> <4978AAE5.60803@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4978AAE5.60803@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Ingo Molnar wrote:
> > * Robert Richter <robert.richter@amd.com> wrote:
> > 
> >> Delta patch to f7df8ed164996cd2c6aca9674388be6ef78d8b37 for
> >> tip/cpus4096.
> >>
> >> Moved initialization to sync_start()/sync_stop(). No changes needed in
> >> buffer_sync.h and oprof.c anymore.
> >>
> >> Cc: Rusty Russell <rusty@rustcorp.com.au>
> >> Cc: Mike Travis <travis@sgi.com>
> >> Signed-off-by: Robert Richter <robert.richter@amd.com>
> >> ---
> >>  drivers/oprofile/buffer_sync.c |   20 ++++++--------------
> >>  drivers/oprofile/buffer_sync.h |    4 ----
> >>  drivers/oprofile/oprof.c       |    9 +--------
> >>  3 files changed, 7 insertions(+), 26 deletions(-)
> > 
> > applied to tip/cpus4096, thanks Robert!
> > 
> > 	Ingo
> 
> Hi Ingo,
> 
> Doesn't this need to be pushed upstream as the error was discovered in 
> linux-next on ia64?

no, upstream -git does not have these changes yet, they came into 
linux-next via tip:cpus4096.

	Ingo
