Return-Path: <linux-kernel-owner+w=401wt.eu-S1757753AbYDNMWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753AbYDNMWB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 08:22:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753873AbYDNMVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 08:21:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34840 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753571AbYDNMVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 08:21:49 -0400
Date: Mon, 14 Apr 2008 14:21:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Nick Andrew <nick@nick-andrew.net>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       joe@perches.com
Subject: Re: [PATCH 2/2] printk: Remember the message level for multi-line
	output
Message-ID: <20080414122123.GA18160@elte.hu>
References: <20080413115152.29086.37845.stgit@marcab.local.tull.net> <20080413122735.31769.17716.stgit@marcab.local.tull.net> <20080414080351.GL16163@elte.hu> <20080414101200.GH29599@tull.net> <20080414102634.GA20649@elte.hu> <87iqyk7jcf.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87iqyk7jcf.fsf@saeurebad.de>
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


* Johannes Weiner <hannes@saeurebad.de> wrote:

> Hi Ingo,
> 
> Ingo Molnar <mingo@elte.hu> writes:
> 
> > btw., we could also start emitting debug warnings that the printk is not 
> > conform. Something like:
> >
> >   "INFO: the previous printk was done without a KERN_ annotation"
> 
> Urgh, that would become very noisy.  If, at all, I'd suggest a config
> option like CONFIG_DEBUG_PRINTK_USAGE and then add a prefix string to
> each printk()ed line missing a severity level.
> 
> printk("foo\n");
> => "[FIX PRINTK] foo"

yes, of course hidden behind a non-default Kconfig variable, like we do 
it with most debug helpers.

	Ingo
