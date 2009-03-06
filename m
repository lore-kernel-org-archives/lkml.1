Return-Path: <linux-kernel-owner+w=401wt.eu-S1751010AbZCFJlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751010AbZCFJlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 04:41:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbZCFJlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 04:41:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39751 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbZCFJlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 04:41:37 -0500
Date: Fri, 6 Mar 2009 10:41:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 1/3] perfcounters/powerpc: fix oops with multiple
	counters in a group
Message-ID: <20090306094126.GB20698@elte.hu>
References: <18864.61033.280502.291018@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18864.61033.280502.291018@cargo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> Ingo, please pull this series of 3 patches from my perfcounters.git
> master branch at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perfcounters.git master

Pulled into tip:perfcounters/core, thanks Paul!

Note, Mike Galbraith updated both perfstat.c and kerneltop.c to 
the new ABI, they can be picked up from:

  http://redhat.com/~mingo/perfcounters/perfstat.c
  http://redhat.com/~mingo/perfcounters/kerneltop.c

(I also extended kerneltop.c with the -r0x000 type of event IDs 
to pass in raw event IDs.)

	Ingo
