Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbZCCLGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbZCCLGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 06:06:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbZCCLF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 06:05:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54622 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbZCCLFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 06:05:55 -0500
Date: Tue, 3 Mar 2009 12:05:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Tim Blechmann <tim@klingt.org>, oprofile-list@lists.sf.net,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] oprofile: don't set counter width from cpuid on core2
Message-ID: <20090303110545.GB11532@elte.hu>
References: <20090216114010.GG25042@erda.amd.com> <20090219173403.49871cac@thinkpad> <20090303100412.GC10085@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090303100412.GC10085@erda.amd.com>
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


* Robert Richter <robert.richter@amd.com> wrote:

> On 19.02.09 17:34:03, Tim Blechmann wrote:
> > resetting the counter width of the performance counters on intel's
> > core2, breaks the delivery of NMIs, when running in x86_64 mode.
> > 
> > this should fix bug #12395:
> > http://bugzilla.kernel.org/show_bug.cgi?id=12395
> 
> Applied to oprofile/fixes. Thanks Tim.
> 
> Ingo, please pull from
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git fixes
> 
> for v2.6.29-rc7.

Pulled, thanks a lot Robert!

Note: i amended the commit to add a tag for the .28 backport 
[this fix is .28.x relevant] and to fix a few small details 
(removed the goto, etc.).

	Ingo
