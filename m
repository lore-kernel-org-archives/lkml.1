Return-Path: <linux-kernel-owner+w=401wt.eu-S1751338AbXBEQfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338AbXBEQfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 11:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbXBEQfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 11:35:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56878 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbXBEQfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 11:35:30 -0500
Date: Mon, 5 Feb 2007 17:31:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
Message-ID: <20070205163152.GA2464@elte.hu>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org> <20070205084523.GA21858@elte.hu> <1170682488.29759.795.camel@pmac.infradead.org> <20070205155627.GA8354@elte.hu> <1170692539.29759.856.camel@pmac.infradead.org> <20070205162635.GA755@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205162635.GA755@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.3 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4457]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> we should not have 'select' at all - unless it's some non-code option 
> that is just a convenience switch for several other config options. A 
> true dependency is already expressed in one direction via the 'depend 
> on' directive - no need to express it in the other direction as well, 
> that only leads to redundancy and to bugs.

but this is /only/ practical if all (even disabled) features are visible 
(and selectable) in the tools. They are not at the moment, so selects 
are quite useful.

	Ingo
