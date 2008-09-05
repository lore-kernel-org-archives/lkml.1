Return-Path: <linux-kernel-owner+w=401wt.eu-S1754395AbYIERAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbYIERAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 13:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754217AbYIEQ7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 12:59:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49695 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754002AbYIEQ7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 12:59:48 -0400
Date: Fri, 5 Sep 2008 18:59:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: hpet: modify IXP400 quirk to enable interrupts
Message-ID: <20080905165932.GB12645@elte.hu>
References: <20080904144657.GC15987@alberich.amd.com> <20080904153206.GB7120@elte.hu> <alpine.LFD.1.10.0809041812450.3243@apollo.tec.linutronix.de> <20080905124203.GD6743@alberich.amd.com> <alpine.LFD.1.10.0809051600370.3243@apollo.tec.linutronix.de> <20080905163326.GE6743@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080905163326.GE6743@alberich.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> The current quirk is incomplete. Some more chipset fiddling has to be
> done to enable HPET interrupts. This patch aims to do this. From my
> tests it seems to work faultlessly.
> 
> But the official statement is that HPET is not supported on SB4X0.
> 
> Users will still have to use hpet=force to enable it.
> 
> Use it at your own risk.
> 
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>

applied to tip/timers/hpet - thanks Andreas!

	Ingo
