Return-Path: <linux-kernel-owner+w=401wt.eu-S1754814AbZEKMXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbZEKMXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752382AbZEKMXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:23:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49989 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbZEKMXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:23:00 -0400
Date: Mon, 11 May 2009 14:22:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, roland@redhat.com, vmayatsk@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] do_wait cleanupe (more to come)
Message-ID: <20090511122233.GE13954@elte.hu>
References: <20090507064630.GA15847@redhat.com> <20090507131234.adf90d1b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507131234.adf90d1b.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 7 May 2009 08:46:30 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
> 
> > Slightly tested. Definitely this needs more testing, but since a) the
> > second patch was reviewed by Ingo and b) Andrew likes the buggy patches
> > very much, I am sending this series. At least I believe this all is
> > right "in general".
> 
> Worried.  This hits on ptrace and there's a lot of ptrace work 
> pending, including large changes which are threatening to come in 
> via a different tree (security).
> 
> If we end up with marginal/flakey patches in the middle of all of 
> this, a big mess ensues.

This problems would be solved if all these bits were in -mm.

	Ingo
