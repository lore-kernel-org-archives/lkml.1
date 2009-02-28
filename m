Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbZB1Igv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbZB1Igv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 03:36:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbZB1Ign
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 03:36:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34076 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbZB1Igm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 03:36:42 -0500
Date: Sat, 28 Feb 2009 09:36:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH] xen: core dom0 support
Message-ID: <20090228083621.GC11425@elte.hu>
References: <1235786365-17744-1-git-send-email-jeremy@goop.org> <20090227212812.26d02f34.akpm@linux-foundation.org> <49A8DF28.4050301@goop.org> <20090228072055.GC9351@elte.hu> <49A8F04D.4090409@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A8F04D.4090409@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>> Hm, how can the same code that you call "massive out-of-tree patches 
>> which doesn't make anyone happy" in an out of tree context suddenly 
>> become non-intrusive "minor amount of extra stuff" in an upstream 
>> context?
>>
>> I wish the upstream kernel was able to do such magic, but i'm afraid it 
>> is not.
>
> No, but I am ;) The current out of tree Xen patches are very 
> intrusive because there hasn't been much incentive to reduce 
> their impact.  I've going through it all and very carefully 
> rewriting it 1) be cleaner, 2) enable/disable itself at 
> runtime, 3) have clean interfaces and interactions with the 
> rest of the kernel, and 4) address any concerns that others 
> have.  In other words, make Xen a first-class kernel citizen.
>
> Most of the intrusive stuff has already been merged (and 
> merged for some time now), but without dom0 support its only 
> half done; as it stands people are using mainline Linux for 
> their domUs, but are still limited to patched up (old) kernels 
> for dom0.  This is a real problem because all the drivers for 
> interesting new devices are in the new kernels, so there's an 
> additional burden of backporting device support into old 
> kernels.

This means that the "massive out-of-tree patches which doesn't 
make anyone happy" argument above is really ... a hiperbole and 
should be replaced with: "small, unintrusive out-of-tree patch"?

	Ingo
