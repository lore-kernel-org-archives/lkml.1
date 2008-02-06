Return-Path: <linux-kernel-owner+w=401wt.eu-S932680AbYBGAZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680AbYBGAZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932515AbYBFX7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:59:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50812 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932568AbYBFX7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:59:42 -0500
Date: Thu, 7 Feb 2008 00:59:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: Rusty Russel <rusty@rustcorp.com.au>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, lguest@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Lguest/x86]: Clash with ioremap_nocache() + _PAGE_PWT
Message-ID: <20080206235923.GA19843@elte.hu>
References: <20080206232134.GB6450@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080206232134.GB6450@ubuntu>
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


* Ahmed S. Darwish <darwish.07@gmail.com> wrote:

> Hi all,
> 
> Beginning from commit 4138cc3418f5, ioremap_nocache() sets the _PAGE_PWT
> flag. 
> 
> Lguest doesn't accept a guest pte with a _PWT flag and reports a "bad 
> page table entry" in that case.
> 
> I've removed check from lguest code and everything worked fine. Is 
> this safe from the Lguest side ?

yes, should be safe. Could you send a patch so that others can apply it 
too?

	Ingo
