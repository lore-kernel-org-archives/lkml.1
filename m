Return-Path: <linux-kernel-owner+w=401wt.eu-S1756949AbZCBMF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949AbZCBMF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 07:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbZCBMFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 07:05:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48517 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbZCBMFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 07:05:11 -0500
Date: Mon, 2 Mar 2009 13:04:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH] xen: core dom0 support
Message-ID: <20090302120445.GA29015@elte.hu>
References: <1235786365-17744-1-git-send-email-jeremy@goop.org> <20090227212812.26d02f34.akpm@linux-foundation.org> <49A8DF28.4050301@goop.org> <20090228072055.GC9351@elte.hu> <49ABA633.2050903@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49ABA633.2050903@redhat.com>
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


* Gerd Hoffmann <kraxel@redhat.com> wrote:

> Ingo Molnar wrote:
> >>> In three years time, will we regret having merged this?
> >> Its a pretty minor amount of extra stuff on top of what's been 
> >> added over the last 3 years, so I don't think it's going to 
> >> tip the scales on its own.  I wouldn't be comfortable in 
> >> trying to merge something that's very intrusive.
> > 
> > Hm, how can the same code that you call "massive out-of-tree 
> > patches which doesn't make anyone happy" in an out of tree 
> > context suddenly become non-intrusive "minor amount of extra 
> > stuff" in an upstream context?
> 
> The current, out-of-tree xen kernel stuff is based on 2.6.18. 
> [...]

Sure, but what i'm pointing out is the following aspect of 
communication:

>>> [...] At the moment its all running on massive out-of-tree 
>>> patches, which doesn't make anyone happy.  It's best that it 
>>> be in the mainline kernel.  You know, like we argue for 
>>> everything else.

Comparing it to a 2.6.18 base is simply misleading when it comes 
to upstreaming something. Enterprise distros will rebase, and 
their out-of-tree pile of patches will shrink.

	Ingo
