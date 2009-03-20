Return-Path: <linux-kernel-owner+w=401wt.eu-S1757278AbZCTIwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278AbZCTIwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 04:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755040AbZCTIwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 04:52:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54824 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744AbZCTIwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 04:52:43 -0400
Date: Fri, 20 Mar 2009 09:52:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Jan Beulich <jbeulich@novell.com>,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [tip:core/ipi] generic-ipi: eliminate spurious
	pointlessWARN_ON()s
Message-ID: <20090320085205.GB16021@elte.hu>
References: <49B91A7E.76E4.0078.0@novell.com> <tip-6a09dfa870ba0ed21b1124539968a36b42660661@git.kernel.org> <1236934491.5188.209.camel@laptop> <49BA33BE.76E4.0078.0@novell.com> <1236937423.22914.3698.camel@twins> <20090313103828.GB31094@elte.hu> <m1d4cd9n4k.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1d4cd9n4k.fsf@fess.ebiederm.org>
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


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> Ingo Molnar <mingo@elte.hu> writes:
> 
> > I also changed all of panic() to be covered by oops_in_progress 
> > - see the other commit. Eric: that should make kexec [a tiny 
> > bit] more robust too, agreed?
> 
> A tad.  We shouldn't have any printk's on that path.  But if we do 
> it will keep us from wedging and getting ourselves into trouble.

Ok. Baby steps are what got us from Linux 0.12 to where we are now 
so i'm content with making a tad of progress with each commit ;-)

	Ingo
