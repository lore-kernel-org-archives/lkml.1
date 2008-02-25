Return-Path: <linux-kernel-owner+w=401wt.eu-S1754638AbYBYIXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbYBYIXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 03:23:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbYBYIXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 03:23:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59574 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116AbYBYIXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 03:23:40 -0500
Date: Mon, 25 Feb 2008 09:23:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: James Morris <jmorris@namei.org>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Regression [Was: Boot hang with stack protector on x86_64]
Message-ID: <20080225082314.GA12715@elte.hu>
References: <Xine.LNX.4.64.0802221121340.20800@us.intercode.com.au> <20080222075950.GB2660@uranus.ravnborg.org> <20080222093621.GG327@elte.hu> <Xine.LNX.4.64.0802222133150.6937@us.intercode.com.au> <20080222121751.GA17889@elte.hu> <Xine.LNX.4.64.0802230000470.14729@us.intercode.com.au> <20080223061856.GA26185@elte.hu> <20080223073746.GA28310@elte.hu> <Xine.LNX.4.64.0802250952570.846@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Xine.LNX.4.64.0802250952570.846@us.intercode.com.au>
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


* James Morris <jmorris@namei.org> wrote:

> > > could you try the fix below ontop of x86.git#testing, does it 
> > > solve your boot hang?
> > 
> > find below another fix that is somewhat better as it does not affect 
> > the native kernel and !PARAVIRT.
> 
> This works.

thanks. We'll delay the stackprotector fixes for v2.6.26 (it's been 
broken for too long), but if you want to have it you can pick it up from 
x86.git.

	Ingo
