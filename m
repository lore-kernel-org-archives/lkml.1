Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565AbYBJXKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbYBJXKA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 18:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbYBJXJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 18:09:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33012 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059AbYBJXJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 18:09:52 -0500
Date: Mon, 11 Feb 2008 00:09:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 updates
Message-ID: <20080210230927.GA24812@elte.hu>
References: <alpine.LFD.1.00.0802092246390.3145@apollo.tec.linutronix.de> <20080209172538.87994c61.randy.dunlap@oracle.com> <alpine.LFD.1.00.0802092344070.2896@woody.linux-foundation.org> <alpine.LFD.1.00.0802101003340.12988@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802101003340.12988@apollo.tec.linutronix.de>
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Sun, 10 Feb 2008, Linus Torvalds wrote:
> > On Sat, 9 Feb 2008, Randy Dunlap wrote:
> > 
> > So Thomas, don't do this. I don't like it. The same way I didn't like 
> > seeing Ingo trying to mix in a kgdb pull into his x86 pull. Keep these 
> > things separate - git is *really* good at having multiple branches with 
> > different lines of development, use it that way (or send odd-ball misc 
> > patches just as emails).
> 
> Please accept my apologies.
> 
> I went through the content, pointed out the other two non x86 patches 
> and did not notice the vsprintf one. My bad.

and i'd like to apologize for the misleading Subject line which said 
"Subject: x86: ...". That i think made us miss the generic impact later 
on (we remind ourselves about non-arch/x86 patches via Subject line 
annotations and via looking at the diffstat before pull requests), and 
the accidentally missing diffstat just removed the last-line defense 
against such annotation mistakes.

btw., i was -->.<--- this close to removing this patch from x86.git 
altogether - because it had a bug (which already shows its 
non-obviousness) and i didnt think this complication was worth it. When 
that happened i took a really hard look at its correctness and 
worthiness and narrowly decided to keep it - but enforced an unusually 
long testing interval for this patch.

	Ingo
