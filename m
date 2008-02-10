Return-Path: <linux-kernel-owner+w=401wt.eu-S1756833AbYBJVRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833AbYBJVRN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 16:17:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbYBJVQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 16:16:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34328 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbYBJVQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 16:16:57 -0500
Date: Sun, 10 Feb 2008 22:16:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jan Kiszka <jan.kiszka@web.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [0/6] kgdb light
Message-ID: <20080210211641.GC29507@elte.hu>
References: <20080210071304.GA3788@elte.hu> <20080210104709.GB10790@uranus.ravnborg.org> <47AEFB40.5070208@web.de> <20080210193153.GC13733@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210193153.GC13733@uranus.ravnborg.org>
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

> > Is the patch below OK? I also added an "if KGB" to unbreak kgdb's 
> > kconfig menu again and included two minor cleanups I posted 
> > yesterday.
> 
> Looks OK - but I think Ingo already addressed this.

i picked up everything from Jan that would apply - please yell if you 
still see something not absolutely squeeky clean ;-)

btw., we should convert all those current:

 config ARCH_POPULATES_NODE_MAP
         def_bool y

 config AUDIT_ARCH
         bool
         default X86_64

 config ARCH_SUPPORTS_AOUT
         def_bool y

instances to select lines after config X86 / config X86_64.

KGDB just followed the current Kconfig style status quo.

	Ingo
