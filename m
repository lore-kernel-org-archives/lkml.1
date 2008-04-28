Return-Path: <linux-kernel-owner+w=401wt.eu-S933846AbYD1M2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933846AbYD1M2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 08:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765110AbYD1M2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 08:28:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33848 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765378AbYD1M2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 08:28:11 -0400
Date: Mon, 28 Apr 2008 14:27:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: missing locking in sched_domains code
Message-ID: <20080428122741.GA27997@elte.hu>
References: <20080427183926.acb66fff.akpm@linux-foundation.org> <20080428070946.GA4507@osiris.boeblingen.de.ibm.com> <20080428002853.1693e7fd.akpm@linux-foundation.org> <20080428075253.GB4507@osiris.boeblingen.de.ibm.com> <20080428081129.GC4507@osiris.boeblingen.de.ibm.com> <20080428083222.GA16963@elte.hu> <20080428084904.GA27056@osiris.boeblingen.de.ibm.com> <20080428015723.e1632c45.akpm@linux-foundation.org> <20080428091745.GB27056@osiris.boeblingen.de.ibm.com> <20080428093307.GC27056@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428093307.GC27056@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> > version 42. Please feel free to change the comment if you think it 
> > could be better :)
> 
> I don't believe this... version 43 ;) I forgot to add the lock in 
> sched_init_smp(). Not that it would really matter, but it should be 
> there to avoid (even more) confusion.
> 
> Subject: [PATCH] sched: fix locking in arch_reinit_sched_domains

thanks Heiko, applied.

	Ingo
