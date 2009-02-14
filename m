Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbZBNXC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbZBNXC7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 18:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbZBNXCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 18:02:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52392 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668AbZBNXCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 18:02:51 -0500
Date: Sun, 15 Feb 2009 00:02:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jiri Slaby <jirislaby@gmail.com>, lenb@kernel.org, mingo@redhat.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH 1/1] x86_64: fix s3 fail path
Message-ID: <20090214230221.GD20477@elte.hu>
References: <1234190120-6268-1-git-send-email-jirislaby@gmail.com> <200902142121.46987.rjw@sisk.pl> <499728AC.90609@gmail.com> <200902142222.03895.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902142222.03895.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> On Saturday 14 February 2009, Jiri Slaby wrote:
> > Rafael J. Wysocki napsal(a):
> > > On Monday 09 February 2009, Jiri Slaby wrote:
> > >> As acpi_enter_sleep_state can fail, take this into account in
> > >> do_suspend_lowlevel and don't return to the do_suspend_lowlevel's
> > >> caller. This would break (currently) fpu status and preempt count.
> > >>
> > >> Technically, this means use `call' instead of `jmp' and `jmp' to
> > >> the `resume_point' after the `call' (i.e. if
> > >> acpi_enter_sleep_state returns=fails). `resume_point' will handle
> > >> the restore of fpu and preempt count gracefully.
> > >>
> > >> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> > >> Cc: Len Brown <lenb@kernel.org>
> > >> Cc: Pavel Machek <pavel@suse.cz>
> > >> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > What kernel is this patch against?  It doesn't apply to the mainline.
> > 
> > It is applicable even after
> > [PATCH v2 1/1] x86_64: acpi/wakeup_64 cleanup
> > from
> > http://lkml.org/lkml/2009/2/7/101
> > which is not present anywhere so far.
> 
> Thanks, I'm going to push both patches through Len, if Ingo doesn't mind.

Fine with me.

	Ingo
