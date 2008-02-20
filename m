Return-Path: <linux-kernel-owner+w=401wt.eu-S1759675AbYBTJdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759675AbYBTJdv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 04:33:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663AbYBTJdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 04:33:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38867 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755099AbYBTJdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 04:33:39 -0500
Date: Wed, 20 Feb 2008 10:33:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tony Breeds <tony@bakeyournoodle.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, lguest@ozlabs.org
Subject: Re: [PATCH] Fix building lguest as module.
Message-ID: <20080220093308.GA3881@elte.hu>
References: <20080201124520.GA29900@elte.hu> <20080201170551.GA3825@elte.hu> <200802040711.11280.rusty@rustcorp.com.au> <20080219034404.GT6887@bakeyournoodle.com> <20080219073205.GA12375@elte.hu> <20080219135401.GA9192@elte.hu> <20080219233520.GB6887@bakeyournoodle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219233520.GB6887@bakeyournoodle.com>
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


* Tony Breeds <tony@bakeyournoodle.com> wrote:

> > the right one is below. There's no 'LGUEST_MODULE' anymore - 
> > 'LGUEST_GUEST' is what should be used.
> 
> Hmm okay I'm confused now.  LGUEST_GUEST is only set when you have 
> guest support enabled, but if you're only building the host module[1] 
> then that wont work.

i have no strong idea either - but no more lguest build failures anymore 
in my test setup since i applied your patch with my small tweak. Rusty 
has pushed his ... lightly tested git tree upstream and went on a 
vacation. I'm strongly considering this new merge technique for the next 
merge window myself! ;-)

	Ingo
