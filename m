Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbZBIPY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbZBIPY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 10:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754478AbZBIPYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 10:24:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53184 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885AbZBIPYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 10:24:50 -0500
Date: Mon, 9 Feb 2009 16:24:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Arnd Bergmann <arnd@arndb.de>,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Remis Lima Baima <remis.developer@googlemail.com>
Subject: Re: [PATCH] ftrace, powerpc64: fix math to calculate offset in TOC
Message-ID: <20090209152424.GA9845@elte.hu>
References: <alpine.DEB.1.10.0902080118480.30802@gandalf.stny.rr.com> <20090209094014.GE7930@elte.hu> <alpine.DEB.1.10.0902091000400.14528@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902091000400.14528@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Mon, 9 Feb 2009, Ingo Molnar wrote:
> 
> > 
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > 
> > > Paul,
> > > 
> > > I found the bug that was causing large modules to fail in setting
> > > up dynamic ftrace. It wound up being a simple math error. To calculate
> > > the offset in the TOC, I had used an OR, but the bottom half was
> > > a signed extended short, and it should have been an addition.
> > > The fix is in my tree below, as well as posted here.
> > 
> > Looks like a .29 candidate?
> 
> Ingo,
> 
> I think Ben pulled them into their tree. The changes are specific to ppc, 
> and will probably get better user testing there. Unless you feel that we 
> have a bit of ppc testers using tip.

no, that's fine - just wanted to make sure it goes upstream via some method.

	Ingo
