Return-Path: <linux-kernel-owner+w=401wt.eu-S1762238AbYDUOGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762238AbYDUOGt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 10:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755006AbYDUOGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 10:06:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53213 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754741AbYDUOGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 10:06:40 -0400
Date: Mon, 21 Apr 2008 16:06:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Wessel <jason.wessel@windriver.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: kgdb: allow static kgdbts boot configuration
Message-ID: <20080421140625.GQ9554@elte.hu>
References: <200804181900.m3IJ0v3v011787@hera.kernel.org> <20080418152609.c849fb7d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080418152609.c849fb7d.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > +config KGDB_TESTS_ON_BOOT
> > +	bool "KGDB: Run tests on boot"
> > +	depends on KGDB_TESTS
> > +	default n
> > +	help
> > +	  Run the kgdb tests on boot up automatically without the need
> > +	  to pass in a kernel parameter
> > +
> > +config KGDB_TESTS_BOOT_STRING
> > +	string "KGDB: which internal kgdb tests to run"
> > +	depends on KGDB_TESTS_ON_BOOT
> > +	default "V1F100"
> > +	help
> > +	  This is the command string to send the kgdb test suite on
> > +	  boot.  See the drivers/misc/kgdbts.c for detailed
> > +	  information about other strings you could use beyond the
> > +	  default of V1F100.
> 
> I dunno.  Do we *really* need this feature?  I mean, if you want to 
> run the tests, you provide the boot parameter and that's it.  Adding 
> this Kconfig-time stuff on top seems excessive.

yes, i believe we really need this - this is what caught the recent 
regression in kgdb. It should all be default-off.

	Ingo
