Return-Path: <linux-kernel-owner+w=401wt.eu-S1763134AbZCQJpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763134AbZCQJpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 05:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755953AbZCQJov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 05:44:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43843 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755407AbZCQJou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 05:44:50 -0400
Date: Tue, 17 Mar 2009 10:43:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG 2.6.29_rc8] BIOS Bug: CPU MTRRs don't cover all of
	memory, losing 0MB of RAM.
Message-ID: <20090317094332.GE6477@elte.hu>
References: <49BE58BA.1000907@pardus.org.tr> <86802c440903161121s3ba18abaiaa3ccf6847e0eafe@mail.gmail.com> <49BEB3C9.8070705@pardus.org.tr> <49BECBF4.1000508@kernel.org> <49BED5D5.2000801@pardus.org.tr> <49BED813.1090405@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49BED813.1090405@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> > x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> >   get_mtrr: cpu0 reg00 base=0000000000 size=0010000000 write-back
> >   get_mtrr: cpu0 reg01 base=00000cff00 size=0000000100 uncachable
> >   get_mtrr: cpu0 reg02 base=00000d0000 size=0000010000 uncachable
> >   get_mtrr: cpu0 reg03 base=00000e0000 size=0000020000 uncachable
> >   get_mtrr: cpu0 reg04 base=0000000004 size=0000000001 uncachable
> >   get_mtrr: cpu0 reg05 base=0000000005 size=0000000001 uncachable
> >   get_mtrr: cpu0 reg06 base=0000000006 size=0000000001 uncachable
> >   get_mtrr: cpu0 reg07 base=0000000007 size=0000000001 uncachable
> > WARNING: BIOS bug: VAR MTRR contains strange UC entry under 1M, check with your system vendor!
> > WARNING: BIOS bug: VAR MTRR contains strange UC entry under 1M, check with your system vendor!
> > WARNING: BIOS bug: VAR MTRR contains strange UC entry under 1M, check with your system vendor!
> > WARNING: BIOS bug: VAR MTRR contains strange UC entry under 1M, check with your system vendor!
> 
> you got four wrong entries

but it's unintuitive. That warning should specify which entry is 
wrong, so that we dont get these pointless duplicated lines.

	Ingo
