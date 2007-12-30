Return-Path: <linux-kernel-owner+w=401wt.eu-S1757496AbXL3OGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496AbXL3OGm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 09:06:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbXL3OGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 09:06:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54759 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222AbXL3OGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 09:06:33 -0500
Date: Sun, 30 Dec 2007 15:04:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch?] s2ram + P4 + tsc = annoyance
Message-ID: <20071230140456.GJ16946@elte.hu>
References: <1198745736.4235.23.camel@homer.simson.net> <1198779574.4425.50.camel@homer.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198779574.4425.50.camel@homer.simson.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0273]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> Or, reset to pristine prior to testing, though that's more lines to 
> accomplish the same thing.  Either way, or some other way...
> 
> If check_tsc_warp() is called after initial boot, and the TSC has in 
> the meantime been set (BIOS, user, silicon, elves) to a value lower 
> than the last stored/stale value, we blame the TSC.  Reset to pristine 
> condition after every test.

ok, i prefer this fix a bit more. (we dont want to set last_tsc outside 
of the sync_lock - which your initial patch does)

	Ingo
