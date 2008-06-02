Return-Path: <linux-kernel-owner+w=401wt.eu-S1751996AbYFBJgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbYFBJgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 05:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755865AbYFBJgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 05:36:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44225 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755314AbYFBJgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 05:36:24 -0400
Date: Mon, 2 Jun 2008 11:35:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kevin Hao <kexin.hao@windriver.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Clemens Ladisch <clemens@ladisch.de>, venkatesh.pallipadi@intel.com,
       bob.picco@hp.com, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@gmail.com>
Subject: Re: [PATCH] x86: Get irq for hpet timer
Message-ID: <20080602093559.GC26242@elte.hu>
References: <Pine.LNX.4.55.0805201631010.31790@cliff.in.clinika.pl> <4833DD38.2010702@ladisch.de> <Pine.LNX.4.55.0805220105560.4894@cliff.in.clinika.pl> <1211441231.7323.10.camel@kevin-desktop> <Pine.LNX.4.55.0805221609280.13339@cliff.in.clinika.pl> <1211971330.6085.33.camel@kevin-desktop> <Pine.LNX.4.55.0805290348350.29522@cliff.in.clinika.pl> <1212057664.8343.29.camel@kevin-desktop> <Pine.LNX.4.55.0805291319250.8254@cliff.in.clinika.pl> <1212125525.8050.23.camel@kevin-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212125525.8050.23.camel@kevin-desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0047]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kevin Hao <kexin.hao@windriver.com> wrote:

> >  Anyway, blindly attaching to an IRQ line is not a terribly good 
> > idea as there may be an edge-triggered line from a device wired 
> > there after all.
> 
> Yes, I agree with you. But at present we have not a better way to 
> resolve this problem.

i've applied your patch for more testing to tip/timers/hpet. Thanks,

	Ingo
