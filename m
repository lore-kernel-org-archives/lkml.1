Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbYDMHwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbYDMHwS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 03:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbYDMHwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 03:52:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48571 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbYDMHwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 03:52:05 -0400
Date: Sun, 13 Apr 2008 09:51:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: x86 git tree broken (bisected)
Message-ID: <20080413075144.GI20332@elte.hu>
References: <200804102159.14563.rjw@sisk.pl> <20080410203800.GA14560@elte.hu> <200804110028.22290.rjw@sisk.pl> <200804112126.29455.rjw@sisk.pl> <86802c440804111326t4c3ff4b6od33a128560b58aec@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440804111326t4c3ff4b6od33a128560b58aec@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> >  and X starts again.  Also, suspend to RAM works from under X.
> 
> please keep the three patches and applied the two attached debug 
> patches.
> 
> i wonder if there is some io allocation overlapping with your system.

hm, would be nice to have these two debugging patches upstream. Perhaps 
the printouts should be dependent on some boot parameter?

	Ingo
