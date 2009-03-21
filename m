Return-Path: <linux-kernel-owner+w=401wt.eu-S1756503AbZCUTxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503AbZCUTxW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 15:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758168AbZCUTwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 15:52:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49700 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758178AbZCUTwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 15:52:09 -0400
Date: Sat, 21 Mar 2009 20:51:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Patrick Walton <pcwalton@cs.ucla.edu>, Philipp Kohlbecher <xt28@gmx.de>
Subject: Re: [Bug #12645] DMI low-memory-protect quirk causes resume hang
	on Samsung NC10
Message-ID: <20090321195152.GB25327@elte.hu>
References: <HPkmj74uawF.A.iqE.M8TxJB@chimera> <fnEpM0mQZjO.A.fJF.d8TxJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fnEpM0mQZjO.A.fJF.d8TxJB@chimera>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.27 and 2.6.28.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12645
> Subject		: DMI low-memory-protect quirk causes resume hang on Samsung NC10
> Submitter	: Patrick Walton <pcwalton@cs.ucla.edu>
> Date		: 2009-02-06 18:35 (44 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0af40a4b1050c050e62eb1dc30b82d5ab22bf221

this is in NEEDINFO state - the question is whether this commit 
(currently queued up for .30) fixes it:

  78a8b35: x86: make e820_update_range() handle small range update

	Ingo
