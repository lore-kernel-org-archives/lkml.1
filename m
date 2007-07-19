Return-Path: <linux-kernel-owner+w=401wt.eu-S965426AbXGSTjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965426AbXGSTjD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 15:39:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbXGSTix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 15:38:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55653 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180AbXGSTiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 15:38:52 -0400
Date: Thu, 19 Jul 2007 21:38:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Glauber <jang@linux.vnet.ibm.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       vatsa@linux.vnet.ibm.com, mschwid2@linux.vnet.ibm.com, efault@gmx.de,
       dmitry.adamushko@gmail.com, paulus@samba.org, anton@samba.org
Subject: Re: [PATCH] virtual sched_clock() for s390
Message-ID: <20070719193840.GA29523@elte.hu>
References: <1184842661.6546.14.camel@localhost.localdomain> <469F8342.7060000@goop.org> <20070719160025.GA31815@elte.hu> <1184872821.5516.10.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184872821.5516.10.camel@localhost.localdomain>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Glauber <jang@linux.vnet.ibm.com> wrote:

> > still, CFS needs time measurement across idle periods as well, for 
> > another purpose: to be able to do precise task statistics for /proc. 
> > (for top, ps, etc.) So it's still true that sched_clock() should 
> > include idle periods too.
> 
> I'm not sure, s390 already has an implemetation for precise accounting 
> in the architecture code, does CFS also improve accounting data?

what kind of precise accounting does s390 have in the architecture code? 
CFS changes task (and load) accounting to be sched_clock() driven in 
essence.

	Ingo
