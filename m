Return-Path: <linux-kernel-owner+w=401wt.eu-S1757943AbYABN3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943AbYABN3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 08:29:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753712AbYABN31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 08:29:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55261 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625AbYABN30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 08:29:26 -0500
Date: Wed, 2 Jan 2008 14:24:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Zhenyu Wang <zhenyu.z.wang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.24-rc6-git7: Reported regressions from 2.6.23
Message-ID: <20080102132415.GB13237@elte.hu>
References: <200801012202.57851.rjw@sisk.pl> <20080102031205.GA10794@zhen-devel.sh.intel.com> <200801021412.07313.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801021412.07313.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> On Wednesday, 2 of January 2008, Zhenyu Wang wrote:
> > On 2008.01.01 22:02:57 +0000, Rafael J. Wysocki wrote:
> > > Subject		: linux-2.6.24-rcX regression / xserver-xorg-video-intel / Q35
> > > Submitter	: Harald Welte <laforge@gnumonks.org>
> > > Date		: 2007-12-22 04:37
> > > References	: http://lkml.org/lkml/2007/12/21/269
> > > 		  http://bugzilla.kernel.org/show_bug.cgi?id=9618
> > > Handled-By	: Zhenyu Wang <zhen78@gmail.com>
> > > Patch		: 
> > 
> > This is resolved by turning on CONFIG_DMAR_GFX_WA.
> 
> OK, I have removed it from the list.

because it's default-enabled, and someone would have to consciously 
disable it to intentionally trigger DMA bugs in drivers, right?

	Ingo
