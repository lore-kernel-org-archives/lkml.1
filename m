Return-Path: <linux-kernel-owner+w=401wt.eu-S1753114AbZFYUS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114AbZFYUS5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 16:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbZFYUSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 16:18:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36914 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbZFYUSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 16:18:48 -0400
Date: Thu, 25 Jun 2009 22:18:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <gregkh@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, x86@kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Kurt Garloff <garloff@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: sysctl to allow panic on IOCK NMI error
Message-ID: <20090625201835.GA10263@elte.hu>
References: <20090624213211.GA11291@kroah.com> <m1ab3wgoxa.fsf@fess.ebiederm.org> <20090625200728.GB6410@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090625200728.GB6410@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Greg KH <gregkh@suse.de> wrote:

> On Thu, Jun 25, 2009 at 11:15:45AM -0700, Eric W. Biederman wrote:
> > Greg KH <gregkh@suse.de> writes:
> > 
> > > From: Kurt Garloff <garloff@suse.de>
> > >
> > > This patch introduces a sysctl /proc/sys/kernel/panic_on_io_nmi, which
> > > defaults to 0 (off).
> > >
> > > When enabled, the kernel panics when the kernel receives an NMI caused
> > > by an IO error.
> > >
> > > The IO error triggered NMI indicates a serious system condition, which
> > > could result in IO data corruption. Rather than contiuing, panicing and
> > > dumping might be a better choice, so one can figure out what's causing
> > > the IO error.
> > >
> > > This could be especially important to companies running IO intensive
> > > applications where corruption must be avoided, e.g. a banks databases.
> > 
> > Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> > 
> > New binary sysctls are not allowed.   Please remove the
> > sysctl.h and .ctl_name portions.
> > 
> > see:
> > Documentation/sysctl/ctl_unnumbered.txt
> > Documentation/feature-remove-schedule.txt
> > 
> > I have a set of patches that should make this kind of thing
> > fail to compile for .32.  Hopefully I can get that out in 
> > the next couple of days.  Making problems like this easier
> > to spot and deal with.
> 
> Oops, ok, will do, sorry about that.  Let me go create a new 
> patch.
> 
> Ingo, do you want an incremental one, or a replacement for the 
> original?

Neither - already fixed :)

	Ingo
