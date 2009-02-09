Return-Path: <linux-kernel-owner+w=401wt.eu-S1756766AbZBIOSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbZBIOSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 09:18:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757254AbZBIORQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 09:17:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52593 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756384AbZBIORP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 09:17:15 -0500
Date: Mon, 9 Feb 2009 15:17:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       fweisbec@gmail.com, penberg@cs.helsinki.fi,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] splice patches for ftrace
Message-ID: <20090209141708.GA27131@elte.hu>
References: <cover.1234159200.git.eduard.munteanu@linux360.ro> <alpine.DEB.1.10.0902090907190.14528@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902090907190.14528@gandalf.stny.rr.com>
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
> On Mon, 9 Feb 2009, Eduard - Gabriel Munteanu wrote:
> 
> > Hi,
> > 
> > This implements splice support so we can use it in kmemtrace-user. Please
> > check it out and tell me what you think.
> > 
> > The "RFC" in the subject reads like "I tested this the best I could,
> > although kmemtrace-user isn't still ready.". As we speak, I'm working on
> > making kmemtrace over ftrace and kmemtrace-user work together nicely.
> 
> Hi Eduard!
> 
> Thanks, I'll give it a test. I've been playing on my spare time with
> a ring buffer splice interface. But I've not had the time to get it 
> working fully. My version would be a binary only interface, but I really 
> like the text interface you have.
> 
> You can look at my old changes at:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>   The branch tip/splice-broken
> 
> As the name suggests, it is still broken ;-)

I'd suggest we pick up Eduard's, with the fixes i suggested - because
they clearly work for his kmemtrace utility!

Then pick up whatever is left in your branch.

	Ingo
