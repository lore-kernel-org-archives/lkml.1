Return-Path: <linux-kernel-owner+w=401wt.eu-S1755946AbYHTKy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbYHTKy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 06:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbYHTKyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 06:54:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34288 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791AbYHTKyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 06:54:15 -0400
Date: Wed, 20 Aug 2008 12:53:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: PATCH] debug: add notifier chain debugging
Message-ID: <20080820105352.GB18524@elte.hu>
References: <20080815152938.4bc9d48c@infradead.org> <20080819210932.9bb348b9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080819210932.9bb348b9.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > +config DEBUG_NOTIFIERS
> > +	bool "Debug notifier call chains"
> > +	depends on DEBUG_KERNEL
> > +	help
> > +	  Enable this to turn on sanity checking for notifier call chains.
> > +	  This is most useful for kernel developers to make sure that
> > +	  modules properly unregister themselves from notifier chains.
> > +	  This is a relatively cheap check but if you care about maximum
> > +	  performance, say N.
> > +
> 
> If we remove the first two checks then surely we can afford to add the
> remaining check unconditionally and lose the new config option and its
> ifdef.

yeah, that's sensible. Arjan?

	Ingo
