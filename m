Return-Path: <linux-kernel-owner+w=401wt.eu-S1753066AbYIVIla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbYIVIla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 04:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbYIVIlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 04:41:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45195 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbYIVIlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 04:41:20 -0400
Date: Mon, 22 Sep 2008 10:41:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers <kernel-testers@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>
Subject: Re: [Regression] Commit 2344abbcbdb82140050e8be29d3d55e4f6fe860b
	breaks resume on nx6325
Message-ID: <20080922084103.GF6601@elte.hu>
References: <200809210124.30547.rjw@sisk.pl> <200809210132.46504.rjw@sisk.pl> <200809212103.17578.rjw@sisk.pl> <200809220036.52831.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809220036.52831.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0048]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> So, it looks like RCU is broken and I have no idea how to debug it 
> further.
> 
> Please advise.

i think RCU is not broken, RCU just happens to be the first entity 
affected by C1E-enter magically killing the (previously working) lapic 
timer clockevents device. We are working on a fix.

	Ingo
