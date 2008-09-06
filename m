Return-Path: <linux-kernel-owner+w=401wt.eu-S1754514AbYIFSti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754514AbYIFSti (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 14:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbYIFSta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 14:49:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42432 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752287AbYIFSt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 14:49:29 -0400
Date: Sat, 6 Sep 2008 20:49:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, yhlu.kernel@gmail.com
Subject: Re: [patch 3/3] x86: io-apic - code style cleaning for
	setup_IO_APIC_irqs
Message-ID: <20080906184914.GG21872@elte.hu>
References: <20080904183748.950151853@gmail.com>> <48c02b6a.0637560a.15e9.ffffa39d@mx.google.com> <20080905080447.GC12409@elte.hu> <20080905180126.GA19334@lenovo> <20080905181111.GG27395@elte.hu> <20080905183347.GB19334@lenovo> <20080905183835.GA19215@elte.hu> <20080906101533.GA7273@lenovo> <Pine.LNX.4.55.0809061938250.13851@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0809061938250.13851@cliff.in.clinika.pl>
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


* Maciej W. Rozycki <macro@linux-mips.org> wrote:

> On Sat, 6 Sep 2008, Cyrill Gorcunov wrote:
> 
> > Ingo, how about the following approach? We don't introduce new
> > functions but rather srink the code by new printout form.
> 
>  Honestly, this one should probably use sprintf() or suchlike to avoid the
> mess of printk() calls building a line of output from pieces.  It's quite
> easy to calculate here what the maximum size of the buffer required could
> be and automatic arrays can have variable size, so no need for the hassle
> of heap management.  Calls to printk() without a trailing newline should
> be avoided where possible as it messes up logging priority if a message
> pops up from an interrupt inbetween.

hm, is it worth the trouble? This is during very early init.

	Ingo
