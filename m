Return-Path: <linux-kernel-owner+w=401wt.eu-S1763702AbXF1PEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763702AbXF1PEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 11:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755418AbXF1PDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 11:03:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47739 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137AbXF1PDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 11:03:53 -0400
Date: Thu, 28 Jun 2007 17:03:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [patch -mm] s390: rename CPU_IDLE to S390_CPU_IDLE
Message-ID: <20070628150343.GB14494@elte.hu>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org> <20070628133956.GC4343@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070628133956.GC4343@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> sched-cfs-v2.6.22-git-v18.patch introduces CPU_IDLE in sched.h.
> This conflict with the already existing define in
> include/asm-s390/processor.h
> Just rename the s390 defines, since they will go away as soon as
> we support CONFIG_NO_HZ instead of our own CONFIG_NO_IDLE_HZ.

thanks for the fix. I _swear_ i did a grep for this new name when i 
introduced it, but apparently i must have only done it for SCHED_IDLE
:-/

	Ingo
