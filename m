Return-Path: <linux-kernel-owner+w=401wt.eu-S1762008AbYD0MhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762008AbYD0MhQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 08:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756003AbYD0MhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 08:37:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46480 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755863AbYD0MhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 08:37:01 -0400
Date: Sun, 27 Apr 2008 14:36:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Adrian Bunk <bunk@kernel.org>, linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] prepare kconfig inline optimization for all
	architectures
Message-ID: <20080427123642.GA28005@elte.hu>
References: <20080427105100.GA14795@uranus.ravnborg.org> <20080427113158.GY2252@cs181133002.pp.htv.fi> <20080427115603.GA23493@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080427115603.GA23493@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> > My opinion on this is still:
> > "OPTIMIZE" means "work around bugs in the kernel".
> 
> So then let us name it: GCC_INLINING

i object to that - please keep it named the way we came up with: 
OPTIMIZE_INLINING=y - because that's what it does.

It goes along the same line as CC_OPTIMIZE_FOR_SIZE=y. Perhaps rename it 
to CC_OPTIMIZE_INLINING=y?

	Ingo
