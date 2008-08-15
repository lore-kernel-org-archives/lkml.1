Return-Path: <linux-kernel-owner+w=401wt.eu-S1758649AbYHOJan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649AbYHOJan (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 05:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758287AbYHOJ37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 05:29:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59429 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758261AbYHOJ36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 05:29:58 -0400
Date: Fri, 15 Aug 2008 11:29:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bruce Duncan <bwduncan@gmail.com>
Cc: Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org
Subject: Re: [git pull] ftrace for v2.6.27
Message-ID: <20080815092947.GE22209@elte.hu>
References: <20080714142226.GA11412@elte.hu> <200808130248.58216.bwduncan@gmail.com> <48A316A2.9080907@redhat.com> <200808131908.48721.bwduncan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808131908.48721.bwduncan@gmail.com>
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


* Bruce Duncan <bwduncan@gmail.com> wrote:

> On Wednesday 13 August 2008 18:15:14 Steven Rostedt wrote:
> > Seems that the issue is with the "ftraced" daemon. The patch you
> > reverted was just a fix in the ftrace startup test. If something fails
> > in the start up test, that something is disabled.  There was a bug in
> > the start up test that caused the dynamic ftrace to fail, and thus
> > disabling dynamic ftrace. The patch you reverted, was the fix to that
> > bug, so you indirectly disabled dynamic ftrace with that revert.
> >
> > I've been developing a way to get rid of the "ftraced" daemon. Here's a
> > big patch to do so against latest git (as of today). Can you go back to
> > the original git, apply this patch and see if you can resume again.
> 
> I've been following that thread with great interest! Glad to see it's 
> taking shape.
> 
> The patch works beautifully. Thanks very much!

it's now integrated into tip/master (with a few other ftrace goodies), 
if you want to test the end result check out tip/master via:

  http://people.redhat.com/mingo/tip.git/README

	Ingo
