Return-Path: <linux-kernel-owner+w=401wt.eu-S1758795AbYBEPub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795AbYBEPub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 10:50:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbYBEPuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 10:50:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52374 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489AbYBEPuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 10:50:19 -0500
Date: Tue, 5 Feb 2008 16:49:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Arjan van de Ven <arjan@infradead.org>, Hugh Dickins <hugh@veritas.com>,
       Jiri Kosina <jkosina@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Abel Bernabeu <abel.bernabeu@gmail.com>
Subject: Re: brk randomization breaks columns
Message-ID: <20080205154953.GA26829@elte.hu>
References: <20080204122837.GA1647@elf.ucw.cz> <Pine.LNX.4.64.0802050242440.30873@twin.jikos.cz> <Pine.LNX.4.64.0802051243240.542@blonde.site> <20080205070001.7bc8058f@laptopd505.fenrus.org> <20080205154648.GA24331@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080205154648.GA24331@elf.ucw.cz>
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


* Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> > > In my usual dither, I'm rather hoping Arjan will have a clear answer.
> > 
> > 
> > setarch works. If the apps come in source form they need fixing anyway (since I'd not be
> > surprised of current gcc reorders variables), if not.. we only have 2 cases,
> > the other case was the build process of emacs (which got fixed 5
> > years ago).
> 
> uemacs ... broken with randomization
> colums, sss ... local programs, broken with randomization
> procinfo ... broken, randomization makes it die sooner.
> mikmod ... broken with randomization
> bsdsed ... broken with randomization
> ...
> Should I test few more?

just a quick debug question: do they all work if you start them via 
setarch?

	Ingo
