Return-Path: <linux-kernel-owner+w=401wt.eu-S1752748AbYBQSPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbYBQSPF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 13:15:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750927AbYBQSOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 13:14:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56734 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbYBQSOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 13:14:52 -0500
Date: Sun, 17 Feb 2008 19:14:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Matt Mackall <mpm@selenic.com>,
       Linux-tiny@selenic.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] [PATCH] x86: Use ELF section to list CPU vendor specific
	code (Linux Tiny)
Message-ID: <20080217181434.GX6006@elte.hu>
References: <200802082347.25364.michael-lists@free-electrons.com> <20080208231130.GA10511@elte.hu> <200802112342.23493.michael-lists@free-electrons.com> <1202770566.12383.59.camel@cinder.waste.org> <47B0D3B7.6070308@zytor.com> <1202772532.12383.67.camel@cinder.waste.org> <47B0EE46.6050208@zytor.com> <20080215120023.252647bd@crazy>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080215120023.252647bd@crazy>
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


* Thomas Petazzoni <thomas.petazzoni@free-electrons.com> wrote:

> Le Mon, 11 Feb 2008 16:54:30 -0800,
> "H. Peter Anvin" <hpa@zytor.com> a écrit :
> 
> > b) would be my first choice, and yes, it would be a good thing to
> > have a generalized mechanism for this.  For the registrant, it's
> > pretty easy: just add a macro that adds a pointer to a named
> > section.  We then need a way to get the base address and length of
> > each such section in order to be able to execute each function in
> > sequence.
> 
> You'll find below a tentative patch that implements this. Tuple 
> (vendor, pointer to cpu_dev structure) are stored in a 
> x86cpuvendor.init section of the kernel, which is then read by the 
> generic CPU code in arch/x86/kernel/cpu/common.c to fill the 
> cpu_devs[] function.

thanks, i've picked this up into x86.git. It all looks much cleaner and 
much more maintainable now. Peter, any objections?

	Ingo
