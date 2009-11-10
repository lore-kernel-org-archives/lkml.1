Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048AbZKJEkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbZKJEkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 23:40:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756005AbZKJEkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 23:40:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36209 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755997AbZKJEkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 23:40:45 -0500
Date: Tue, 10 Nov 2009 05:40:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de
Subject: Re: [tip:x86/apic] x86/apic: Limit irq affinity
Message-ID: <20091110044025.GA7897@elte.hu>
References: <20091021011233.GB32196@sgi.com>
 <tip-683c91f85d7a3e1092d7fa3ec5687af8cd379f02@git.kernel.org>
 <20091108145355.GA8432@elte.hu>
 <20091109160215.GA14718@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091109160215.GA14718@sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dimitri Sivanich <sivanich@sgi.com> wrote:

> On Sun, Nov 08, 2009 at 03:53:55PM +0100, Ingo Molnar wrote:
> > 
> > * tip-bot for Dimitri Sivanich <sivanich@sgi.com> wrote:
> > 
> > > Commit-ID:  683c91f85d7a3e1092d7fa3ec5687af8cd379f02
> > > Gitweb:     http://git.kernel.org/tip/683c91f85d7a3e1092d7fa3ec5687af8cd379f02
> > > Author:     Dimitri Sivanich <sivanich@sgi.com>
> > > AuthorDate: Tue, 3 Nov 2009 12:40:37 -0600
> > > Committer:  Ingo Molnar <mingo@elte.hu>
> > > CommitDate: Sun, 8 Nov 2009 13:30:40 +0100
> > > 
> > > x86/apic: Limit irq affinity
> > > 
> > > This patch allows for hard numa restrictions to irq affinity on
> > > x86 systems.
> > 
> > -tip testing found a build failure:
> > 
> > arch/x86/kernel/apic/io_apic.c:1438: error: ???struct irq_desc??? has no member named ???node???
> > arch/x86/kernel/apic/io_apic.c:3286: error: ???struct irq_desc??? has no member named ???node???
> >
> 
> In the interest of doing some ifdef cleanup as well as fixing the 
> build problem, can I suggest that we remove the 'ifdef CONFIG_SMP' 
> from the irq_desc?

What's the (data and code) size effect on UP kernels?

	Ingo
