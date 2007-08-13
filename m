Return-Path: <linux-kernel-owner+w=401wt.eu-S1753267AbXHMPyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbXHMPyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S946606AbXHMOP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 10:15:27 -0400
Received: from mx12.go2.pl ([193.17.41.142]:48987 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S939465AbXHMOPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 10:15:25 -0400
Date: Mon, 13 Aug 2007 16:16:08 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Stable Team <stable@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jean-Baptiste Vignaud <vignaud@xandmail.fr>,
       "marcin\.slusarz" <marcin.slusarz@gmail.com>
Subject: Re: [patch 3/3] genirq: mark io_apic level interrupts to avoid resend
Message-ID: <20070813141607.GC4026@ff.dom.local>
References: <20070812152213.551812576@inhelltoy.tec.linutronix.de> <20070812152303.177006193@inhelltoy.tec.linutronix.de> <20070813112821.GA2863@ff.dom.local> <1187006835.12828.112.camel@chaos> <20070813135311.GB4026@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070813135311.GB4026@ff.dom.local>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2007 at 03:53:11PM +0200, Jarek Poplawski wrote:
...
> I've thought e.g. about "fasteoi" for this "Virtual Wire" timer for
> i386: I hope it's OK, but since is it any problem to add some comment
> here, why it's OK with resending here (with POWERPC it's easier to
> think it's something special, but here we have to similar things in
> the same file)?
...
Sorry for these misspellings etc. (a bit in hurry...) Should be:

I've thought e.g. about "fasteoi" for this "Virtual Wire" timer for
i386: I hope it's OK, but is this any problem to add some comment
here: why it's OK with resending here (with POWERPC it's easier to
think it's something special, but here we have to similar things in
the same file)?

Jarek P.
