Return-Path: <linux-kernel-owner+w=401wt.eu-S1755262AbZBFTbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbZBFTbt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 14:31:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbZBFTbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 14:31:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39348 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787AbZBFTbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 14:31:38 -0500
Date: Fri, 6 Feb 2009 20:31:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ben Greear <greearb@candelatech.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, len.brown@intel.com
Subject: Re: PATCH:  Allow over-ride of smp_found_cfg with kernel cmd-line
	option.
Message-ID: <20090206193121.GA32634@elte.hu>
References: <498B421D.9090609@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498B421D.9090609@candelatech.com>
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


* Ben Greear <greearb@candelatech.com> wrote:

> Allow user to keep smp_found_cfg set to 1 even if MADT
> cannot be parsed.  This works around funky BIOS on FWA-7304
> (VIA CN700 chipset) system, and possibly other systems as well.
> Without this override, performance drops by around 15% on
> network throughput tests on this system.

The question is, _why_ does network performance drop?

Do you have a before/after pair of /proc/interrupts output
perhaps? Does the layout of IRQs change?

The system is not SMP - so only something about UP-IOAPIC can
be helpful to performance here - or some unknown effect.

	Ingo
