Return-Path: <linux-kernel-owner+w=401wt.eu-S1754571AbYGIGON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbYGIGON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 02:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224AbYGIGNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 02:13:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33323 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbYGIGNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 02:13:55 -0400
Date: Wed, 9 Jul 2008 08:13:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alok Kataria <akataria@vmware.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       Dan Hecht <dhecht@vmware.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/05] x86: Rename paravirtualized TSC functions
Message-ID: <20080709061336.GG9760@elte.hu>
References: <1214937816.20191.34.camel@promb-2n-dhcp368.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214937816.20191.34.camel@promb-2n-dhcp368.eng.vmware.com>
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


* Alok Kataria <akataria@vmware.com> wrote:

> Rename the paravirtualized calculate_cpu_khz to calibrate_tsc. In all 
> cases, we actually calibrate_tsc and use that as the cpu_khz value.

thanks Alok, i've applied all 5 unification patches to tip/x86/core:

 Alok Kataria (5):
       x86: merge sched_clock handling
       x86: merge tsc calibration
       x86: merge the TSC cpu-freq code
       x86: merge tsc_init and clocksource code
       x86: rename paravirtualized TSC functions

they are looking good in testing so far.

	Ingo
