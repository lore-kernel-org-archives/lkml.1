Return-Path: <linux-kernel-owner+w=401wt.eu-S1755909AbYHSAXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbYHSAXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 20:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754409AbYHSAW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 20:22:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37679 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754371AbYHSAW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 20:22:56 -0400
Date: Tue, 19 Aug 2008 02:22:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alok Kataria <akataria@vmware.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Daniel Hecht <dhecht@vmware.com>, Mikko Vinni <mmvinni@yahoo.com>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [Bug #11330] int3: 0000 in tsc_read_refs when using powernow_k7
Message-ID: <20080819002232.GF9914@elte.hu>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik> <sNRO-BDDjQL.A.v-E.dazpIB@albercik> <1219079740.13032.14.camel@alok-dev1> <20080818183328.GB22989@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080818183328.GB22989@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.3
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > There is this fix 
> > 
> > commit d554d9a4295dd0595d12eeccbc55d1f495b15176
> > Author: Marcin Slusarz <marcin.slusarz@gmail.com>
> > Date:   Mon Aug 11 00:07:44 2008 +0200
> > 
> >     x86, tsc: fix section mismatch warning
> > 
> > which is in x86/tip-master which fixes this issue. 
> > I don't see the fix in the mainline tree yet. 
> > 
> > Maybe Ingo, has it queued, for upstream ?
> > Ingo, other than a section mismatch warning it also fixes a real bug.
> 
> yeah, hpa queued it up into x86/urgent as well earlier today, it will go 
> out with the next pull request.

FYI, commit d554d9a4295d is upstream now, and will be part of -rc4.

	Ingo
