Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbYHRSeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbYHRSeF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbYHRSdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:33:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42752 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752AbYHRSdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:33:53 -0400
Date: Mon, 18 Aug 2008 20:33:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alok Kataria <akataria@vmware.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Daniel Hecht <dhecht@vmware.com>, Mikko Vinni <mmvinni@yahoo.com>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [Bug #11330] int3: 0000 in tsc_read_refs when using powernow_k7
Message-ID: <20080818183328.GB22989@elte.hu>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik> <sNRO-BDDjQL.A.v-E.dazpIB@albercik> <1219079740.13032.14.camel@alok-dev1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219079740.13032.14.camel@alok-dev1>
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


* Alok Kataria <akataria@vmware.com> wrote:

> On Sat, 2008-08-16 at 12:02 -0700, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.26.  Please verify if it still should be listed and let me know
> > (either way).
> 
> There is this fix 
> 
> commit d554d9a4295dd0595d12eeccbc55d1f495b15176
> Author: Marcin Slusarz <marcin.slusarz@gmail.com>
> Date:   Mon Aug 11 00:07:44 2008 +0200
> 
>     x86, tsc: fix section mismatch warning
> 
> which is in x86/tip-master which fixes this issue. 
> I don't see the fix in the mainline tree yet. 
> 
> Maybe Ingo, has it queued, for upstream ?
> Ingo, other than a section mismatch warning it also fixes a real bug.

yeah, hpa queued it up into x86/urgent as well earlier today, it will go 
out with the next pull request.

	Ingo
