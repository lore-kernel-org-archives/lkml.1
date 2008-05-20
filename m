Return-Path: <linux-kernel-owner+w=401wt.eu-S932528AbYETTxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528AbYETTxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 15:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756318AbYETTwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 15:52:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55443 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757164AbYETTwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 15:52:50 -0400
Date: Tue, 20 May 2008 21:51:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Hugh Dickins <hugh@veritas.com>,
       Theodore Tso <tytso@mit.edu>, Gabriel C <nix.or.die@googlemail.com>,
       Keith Packard <keithp@keithp.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Eric Anholt <eric@anholt.net>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, airlied@linux.ie,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 0 of 8] x86: use PTE_MASK consistently
Message-ID: <20080520195147.GA17648@elte.hu>
References: <patchbomb.1211268376@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <patchbomb.1211268376@localhost>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> This series has had some testing in the x86.git tree, and hasn't shown 
> any problems.  Each patch is more or less absolutely trivial and the 
> series is very bisectable, to help track down any problems which might 
> arise (this area has always been a source of subtle problems).

yep, this has been problem-free in x86.git and then in -tip, we had a 
separate x86/ptemask topic for it that we originally intended for 
v2.6.27, and we dont mind to see it upstream now ;-)

	Ingo
