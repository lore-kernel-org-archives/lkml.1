Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbYIQNNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbYIQNNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 09:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbYIQNNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 09:13:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53436 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411AbYIQNN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 09:13:29 -0400
Date: Wed, 17 Sep 2008 15:13:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: j_kernel@hoblitt.com, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bugme-new] [Bug 11543] New: kernel panic: softlockup in
	tick_periodic() ???
Message-ID: <20080917131306.GB20626@elte.hu>
References: <20080917024312.GA23209@hoblitt.com> <20080917071357.GA7455@lenovo> <20080917092058.GB23209@hoblitt.com> <20080917125950.GA7309@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080917125950.GA7309@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0098]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Evetually nmi_watchdog=2 does work right? Though it's not good that 
> we've got 8259 spurious interrupt. Hmm...

well, nmi_watchdog=2 changes the layout of clockevent devices and easily 
switches the system into non-highres non-dynticks mode. So it can hide 
bugs.

	Ingo
