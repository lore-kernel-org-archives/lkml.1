Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029Ab0A0Jws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab0A0Jws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 04:52:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753850Ab0A0Jwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 04:52:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45113 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753680Ab0A0Jwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 04:52:47 -0500
Date: Wed, 27 Jan 2010 10:52:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robert Richter <robert.richter@amd.com>,
       LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [GIT PULL] oprofile fixes for v2.6.33
Message-ID: <20100127095229.GB24915@elte.hu>
References: <20100125192922.GQ2014@erda.amd.com>
 <20100125232318.2f68a0ad.akpm@linux-foundation.org>
 <20100126125323.GR2014@erda.amd.com>
 <20100126120526.1950cbcf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100126120526.1950cbcf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 26 Jan 2010 13:53:24 +0100 Robert Richter <robert.richter@amd.com> wrote:
> 
> > On 25.01.10 23:23:18, Andrew Morton wrote:
> > > On Mon, 25 Jan 2010 20:29:22 +0100 Robert Richter <robert.richter@amd.com> wrote:
> > > 
> > > > Suravee Suthikulpanit (1):
> > > >       oprofile/x86: fix crash when profiling more than 28 events
> > > 
> > > Did you consider a cc:stable on this one?
> > 
> > Yes, will send it to the stable tree after I got the upstream commit
> > id.
> 
> You don't need to do that - simply add
> 
> Cc: <stable@kernel.org>
> 
> to the changelog and the -stable guys will later grab the commit by magic.

Yep, that method results in a far more reliable flow of fixes towards -stable.

	Ingo
