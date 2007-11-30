Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbXK3UHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbXK3UHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 15:07:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbXK3UHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 15:07:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42745 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969AbXK3UHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 15:07:06 -0500
Date: Fri, 30 Nov 2007 21:06:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 0/3] Per cpu relocation to ZERO and x86_32 percpu ops
	on x86_64
Message-ID: <20071130200641.GA385@elte.hu>
References: <20071130064305.459255715@sgi.com> <20071130112429.GA3605@elte.hu> <20071130112645.GA7565@elte.hu> <Pine.LNX.4.64.0711300918250.32294@schroedinger.engr.sgi.com> <20071130180002.GB19571@elte.hu> <Pine.LNX.4.64.0711301019590.1743@schroedinger.engr.sgi.com> <20071130183512.GA8985@elte.hu> <Pine.LNX.4.64.0711301043380.1919@schroedinger.engr.sgi.com> <20071130194517.GD9928@elte.hu> <Pine.LNX.4.64.0711301147100.2242@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711301147100.2242@schroedinger.engr.sgi.com>
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
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <clameter@sgi.com> wrote:

> > And btw., -rc3-mm2 seems to have grown a spontaneous reboot problem, 
> > that looks quite similar to what i saw:
> > 
> >   http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc3/2.6.24-rc3-mm2/announce.txt
> 
> Side swipe against mm? ;-) mm2 works fine here. What is so bad about 
> mm?

you snipped out this bit where Andrew wrote:

> | - First bug report: after ten minutes happily compiling kernels my
> |   2.6.24-rc3-mm2 x86_64 box spontaneously rebooted.

which answers your question: i only pointed out that this is very 
similar to what i saw, spontaneous reboots. So why did you call this a 
"side swipe"? I connected up different bugreports. I do not claim that 
Andrew's reboot was necessarily due to the percpu patches, i just 
pointed out the similarity of the symptoms.

	Ingo
