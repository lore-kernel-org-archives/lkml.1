Return-Path: <linux-kernel-owner+w=401wt.eu-S1754111AbYDNK2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbYDNK2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 06:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757413AbYDNK2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 06:28:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39985 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757313AbYDNK2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:28:40 -0400
Date: Mon, 14 Apr 2008 12:28:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Andrew <nick@nick-andrew.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC] x86: Cleanup prose of Documentation/i386/IO-APIC.txt
Message-ID: <20080414102824.GB20649@elte.hu>
References: <20080411154053.GD18242@tull.net> <20080413084536.GB24429@elte.hu> <20080413112522.GD29599@tull.net> <20080414094603.GB3761@elte.hu> <20080414101747.GI29599@tull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414101747.GI29599@tull.net>
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


* Nick Andrew <nick@nick-andrew.net> wrote:

> On Mon, Apr 14, 2008 at 11:46:03AM +0200, Ingo Molnar wrote:
> > * Nick Andrew <nick@nick-andrew.net> wrote:
> > > I wouldn't know that, but I still have to use 'noapic' to get my AMD 
> > > box to boot :-(
> > 
> > oh. If "noapic" is still necessary with x86/latest:
> > 
> >   http://people.redhat.com/mingo/x86.git/README
> 
> Thanks; I'll retest on latest then. I didn't realise the problem was 
> fixed.

just to make sure: nothing _specific_ was done in this area, this is 
just to make sure we'll both deal with the same codebase. But in 
general, if a box needs "noapic", that signals a bug we should try to 
solve in the kernel automatically (even if it's BIOS inflicted damage).

	Ingo
