Return-Path: <linux-kernel-owner+w=401wt.eu-S1758669AbYFEMkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669AbYFEMkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 08:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757128AbYFEMjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 08:39:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54075 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757091AbYFEMju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 08:39:50 -0400
Date: Thu, 5 Jun 2008 14:39:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RFC [PATCH] x86: make generic arch support NUMAQ
Message-ID: <20080605123933.GA22737@elte.hu>
References: <200806050309.11197.yhlu.kernel@gmail.com> <20080605110002.GB17961@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080605110002.GB17961@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> > +#if defined(CONFIG_X86_NUMAQ) || defined(CONFIG_X86_GENERICARCH)
> 
> I counted several places where you test for the above. Introducing a 
> CONFIG_X86_NUMAQ_OR_GENERIC would simplify stuff.

Yinghai, please get rid of the NUMAQ build option altogether and 
eliminate the subarch.

We should keep a compatibility CONFIG_X86_NUMAQ that selects 
X86_GENERICARCH, so that 'make oldconfig' on a NUMAQ config does the 
right thing - but it's not a subarch anymore nor anything 
user-configurable.

All that together would be a very nice simplification.

	Ingo
