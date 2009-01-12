Return-Path: <linux-kernel-owner+w=401wt.eu-S1756337AbZALWQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337AbZALWQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:16:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbZALWQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:16:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53533 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757227AbZALWQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:16:11 -0500
Date: Mon, 12 Jan 2009 23:16:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Torsten Kaiser <just.for.lkml@googlemail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 fixes
Message-ID: <20090112221603.GA14934@elte.hu>
References: <20090111143951.GA6666@elte.hu> <64bb37e0901110845o2561db4auf68b86d024d210a0@mail.gmail.com> <7E82351C108FA840AB1866AC776AEC4643BB73C5@orsmsx505.amr.corp.intel.com> <64bb37e0901121101y73c492fel38a70681f226b526@mail.gmail.com> <20090112191934.GA28851@linux-os.sc.intel.com> <20090112192912.GA31650@linux-os.sc.intel.com> <64bb37e0901121205u78195ac4j145fa922f9e99107@mail.gmail.com> <20090112204041.GB3329@elte.hu> <64bb37e0901121350l696b866k4216a36c36ff5785@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64bb37e0901121350l696b866k4216a36c36ff5785@mail.gmail.com>
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


Linus,

* Torsten Kaiser <just.for.lkml@googlemail.com> wrote:

> pulled && build, here is the result:
> [   76.170171] BUG: unable to handle kernel NULL pointer dereference at (null)
> [   76.178376] IP: [<(null)>] (null)

this test result from Torsten establishes it beyond doubt that the current 
x86-fixes-for-linus lineup is safe to pull.

We'll work with Toralf to pin down the PAT crash as well, and will send 
those fixes once they work fine on Toralf's box.

	Ingo
