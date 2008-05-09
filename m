Return-Path: <linux-kernel-owner+w=401wt.eu-S1754717AbYEIJuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbYEIJuS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 05:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760377AbYEIJt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 05:49:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57291 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758889AbYEIJt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 05:49:57 -0400
Date: Fri, 9 May 2008 11:49:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Theodore Tso <tytso@mit.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Possible regression?  2.6.26-rc1: X61s failure after
	suspend/resume
Message-ID: <20080509094941.GA19617@elte.hu>
References: <E1JuCBA-0002NZ-4E@closure.thunk.org> <200805082352.04352.rjw@sisk.pl> <20080509024426.GB8871@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080509024426.GB8871@mit.edu>
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


* Theodore Tso <tytso@MIT.EDU> wrote:

> > This looks like another manifestation of
> > http://bugzilla.kernel.org/show_bug.cgi?id=10620
> 
> Could be.  On my system, the X server runs for about 15 seconds to 
> five minutes before it wedges up and locks up.  This is why it took me 
> a while before I finally figured out that the way to reliably 
> reproduce the problem was to do a suspend/resume.  So it's not 
> *identical* to the report, but its really close....
> 
> When I have more time I'll try to find some actual bisection points 
> that actually will successfully boot on the X61s laptop, and not die 
> within 6-8 seconds of the kernel loading.....

on the off chance that this might be related: could you try to boot with 
nopat?

and on the off chance that this is a problem that has already been 
fixed, you might want to try x86.git/latest:

   http://people.redhat.com/mingo/x86.git/README

	Ingo
