Return-Path: <linux-kernel-owner+w=401wt.eu-S1760389AbYEMOMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760389AbYEMOMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 10:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753801AbYEMOL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 10:11:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45280 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbYEMOLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 10:11:55 -0400
Date: Tue, 13 May 2008 16:11:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Sven Wegener <sven.wegener@stealer.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [git pull] scheduler fixes
Message-ID: <20080513141129.GC18798@elte.hu>
References: <20080511125049.GA22513@elte.hu> <20080511125216.GA25040@elte.hu> <20080511130226.GR19219@parisc-linux.org> <20080511132636.GA22878@parisc-linux.org> <20080511140017.GA2457@elte.hu> <20080511141818.GT19219@parisc-linux.org> <20080511144203.GB3220@elte.hu> <20080511144821.GW19219@parisc-linux.org> <20080511151909.GA3887@elte.hu> <20080511152942.GY19219@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080511152942.GY19219@parisc-linux.org>
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


* Matthew Wilcox <matthew@wil.cx> wrote:

> > So why not transform it to real completions instead? And if our 
> > current 'struct completion' abstraction is insufficient for whatever 
> > reason, why not extend that instead?
> 
> My point is that for the only user of counting semaphores and/or 
> semaphores-abused-as-completions that has so far hit this race, the 
> serialised wake-up performs better.  You have not pointed at a 
> scenario that _shows_ a parallel wake-up to perform better. [...]

a 50% AIM7 slowdown maybe? With the BKL being a spinlock again it doesnt 
matter much in practice though.

	Ingo
