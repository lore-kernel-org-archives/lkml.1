Return-Path: <linux-kernel-owner+w=401wt.eu-S1752161AbXLJIWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbXLJIWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 03:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbXLJIWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 03:22:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35487 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbXLJIWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 03:22:14 -0500
Date: Mon, 10 Dec 2007 09:21:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Tejun Heo <htejun@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Message-ID: <20071210082157.GA21564@elte.hu>
References: <200712080340.49546.rjw@sisk.pl> <20071208015227.3a1c7fae.akpm@linux-foundation.org> <475B9270.6070902@gmail.com> <20071209134217.7ff02dd2@the-village.bc.nu> <alpine.LFD.0.9999.0712091036380.12046@woody.linux-foundation.org> <20071209220132.53268368@the-village.bc.nu> <alpine.LFD.0.9999.0712091736450.12046@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0712091736450.12046@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Tejun already reported that this apparently gets fixed _properly_ with 
> the more extensive cleanups and fixes that are pending for 2.6.25.

btw., how extensive are those cleanups and fixes in reality, is there a 
rollup somewhere one could take a look at? Those fixes and cleanups were 
deferred to v2.6.25 in the knowledge of having the current code included 
in v2.6.24 - but now that the current approach seems to regress, maybe 
those cleanups are still safe enough. (compared to an outright revert)

	Ingo
