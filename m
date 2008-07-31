Return-Path: <linux-kernel-owner+w=401wt.eu-S1759040AbYGaWMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759040AbYGaWMf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 18:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbYGaWM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 18:12:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42910 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754626AbYGaWMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 18:12:25 -0400
Date: Fri, 1 Aug 2008 00:12:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Peter Oruba <peter.oruba@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Max Krasnyansky <maxk@qualcomm.com>
Subject: Re: [patch 0/4] x86: AMD microcode patch loading v2 fixes
Message-ID: <20080731221206.GF23801@elte.hu>
References: <20080729154103.007575982@amd.com> <20080731212701.GG2729@elte.hu> <b647ffbd0807311502i48dbe916l41e417e1e3941160@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0807311502i48dbe916l41e417e1e3941160@mail.gmail.com>
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


* Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:

> > Will you take a shot at moving the driver to early init (and early 
> > SMP init) code, as suggested by Dmitry?
> 
> I have another fix for 'microcode' (one place may race vs. 
> sched_setaffinity()) and a few ideas/improvements to try. I would also 
> do this 'move-cpu-hotplug-activities-to-early-init' thing (but 
> perhaps, not earlier than on Saturday-Sunday) if Peter doesn't come up 
> with a patch by this time.
> 
> btw., is tip/x86/microcode a .27 material? I mean, if I do some work, 
> should I do it on top of the current linus-git or -tip (or both)?

it's not really .27 material, it was recently started. So for fixes i'd 
suggest as-small-as-possible patches against -git. We'll sort out the 
x86/microcode impact of that.

	Ingo
