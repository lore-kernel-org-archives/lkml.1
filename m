Return-Path: <linux-kernel-owner+w=401wt.eu-S1032014AbXFHUnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032014AbXFHUnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 16:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762946AbXFHUnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 16:43:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41867 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793AbXFHUne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 16:43:34 -0400
Date: Fri, 8 Jun 2007 22:43:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, ak@suse.de
Subject: Re: [PATCH 0/2] i386: Fix two more NMI watchdog bugs
Message-ID: <20070608204324.GA25392@elte.hu>
References: <465C2225.2000100@googlemail.com> <20070603150246.5151dda6@laptop.hypervisor.org> <20070608060244.GA2369@atjola.homenet> <20070607234153.09c32b49.akpm@linux-foundation.org> <20070608105808.GA10190@elte.hu> <20070608184422.GA2204@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070608184422.GA2204@atjola.homenet>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Bj?rn Steinbrink <B.Steinbrink@gmx.de> wrote:

> Anyway, both are bugs and should be fixed. Maybe we're even lucky and 
> it fixes your hang. *fingers crossed*

just to make it clear: the NMI watchdog was working perfectly fine on 
that box (in v2.6.21 and in dozens of kernel releases before that, for 
multiple years) before Andi's cleanup patch. So lets find that bug first 
or revert the cleanups.

	Ingo
