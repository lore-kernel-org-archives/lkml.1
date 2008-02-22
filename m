Return-Path: <linux-kernel-owner+w=401wt.eu-S934583AbYBVN2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934583AbYBVN2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 08:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758419AbYBVN2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 08:28:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58049 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757366AbYBVN2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 08:28:11 -0500
Date: Fri, 22 Feb 2008 14:27:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: James Morris <jmorris@namei.org>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Regression [Was: Boot hang with stack protector on x86_64]
Message-ID: <20080222132743.GA6602@elte.hu>
References: <Xine.LNX.4.64.0802221121340.20800@us.intercode.com.au> <20080222075950.GB2660@uranus.ravnborg.org> <20080222093621.GG327@elte.hu> <Xine.LNX.4.64.0802222133150.6937@us.intercode.com.au> <20080222121751.GA17889@elte.hu> <Xine.LNX.4.64.0802230000470.14729@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Xine.LNX.4.64.0802230000470.14729@us.intercode.com.au>
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

> > Please send me your full .config and the gcc version you used for 
> > building the failing kernel.
> 
> config attached.

thanks, i'll try that.

> gcc version 4.1.2 20071124 (Red Hat 4.1.2-36)

ok, i have a slightly older one:

  gcc version 4.1.2 20070925 (Red Hat 4.1.2-33)

i'll try to upgrade to your version to make sure we see the same 
regression.

	Ingo
