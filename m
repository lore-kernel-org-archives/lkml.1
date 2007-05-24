Return-Path: <linux-kernel-owner+w=401wt.eu-S1756823AbXEXJz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbXEXJz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 05:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755635AbXEXJzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 05:55:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51315 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755578AbXEXJzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 05:55:17 -0400
Date: Thu, 24 May 2007 11:55:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: righiandr@users.sourceforge.net, Bernd Eckenfels <ecki@lina.inka.de>,
       linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
       linux-mm@kvack.org
Subject: Re: [PATCH 1/2] limit print_fatal_signal() rate (was: [RFC] log out-of-virtual-memory events)
Message-ID: <20070524095503.GA14783@elte.hu>
References: <E1Hp5PV-0001Bn-00@calista.eckenfels.net> <464ED258.2010903@users.sourceforge.net> <20070520203123.5cde3224.akpm@linux-foundation.org> <20070524075835.GC21138@elte.hu> <20070524011551.3d72a6e8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070524011551.3d72a6e8.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 24 May 2007 09:58:35 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > Well OK.  But vdso-print-fatal-signals.patch is designated 
> > > not-for-mainline anyway.
> > 
> > btw., why?
> 
> err, because that's what I decided a year ago.  I wonder why ;)
> 
> Perhaps because of the DoS thing, but it has a /proc knob and defaults 
> to off, so it should be OK.

yeah. There's also a boot option. To address the DoS angle, should i 
make it optionally printk_ratelimit() perhaps? (although often the 
messages come in streams and skipping a message can be annoying)

> > It's very, very useful to distro, early-boot-userspace and glibc 
> > development. The only add-on change should be to not print SIGKILL 
> > events. Otherwise it's very much a keeper. Hm?
> 
> <promotes it>

thanks :-)

	Ingo
