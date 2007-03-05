Return-Path: <linux-kernel-owner+w=401wt.eu-S932156AbXCEIHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156AbXCEIHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 03:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932212AbXCEIHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 03:07:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57312 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932156AbXCEIHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 03:07:31 -0500
Date: Mon, 5 Mar 2007 08:57:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Emil Karlson <jkarlson@cc.hut.fi>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Soeren Sonnenburg <kernel@nn7.de>, Daniel Walker <dwalker@mvista.com>
Subject: Re: [5/6] 2.6.21-rc2: known regressions
Message-ID: <20070305075747.GA19838@elte.hu>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015040.GJ3441@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070305015040.GJ3441@stusta.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Adrian Bunk <bunk@stusta.de> wrote:

> Subject    : i386: no boot with nmi_watchdog=1  (clockevents)
> References : http://lkml.org/lkml/2007/2/21/208
> Submitter  : Daniel Walker <dwalker@mvista.com>
> Caused-By  : Thomas Gleixner <tglx@linutronix.de>
>              commit e9e2cdb412412326c4827fc78ba27f410d837e6e
> Handled-By : Thomas Gleixner <tglx@linutronix.de>
> Status     : problem is being debugged

FYI, this is not a "wont boot" problem, this should be a "NMI watchdog 
does not work" problem - which has far lower severity. Also, Thomas did 
a fix for this which is now in -mm.

	Ingo
