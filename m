Return-Path: <linux-kernel-owner+w=401wt.eu-S1761767AbZEGLCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761767AbZEGLCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 07:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbZEGLCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 07:02:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51299 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036AbZEGLCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 07:02:33 -0400
Date: Thu, 7 May 2009 13:02:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Neil Brown <neilb@suse.de>
Cc: Alessio Igor Bogani <abogani@texware.it>, Jonathan Corbet <corbet@lwn.net>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] md: Avoid to call flush_scheduled_work() with BKL
	held
Message-ID: <20090507110210.GD28398@elte.hu>
References: <1240492313-6560-1-git-send-email-abogani@texware.it> <20090426163841.GC6236@elte.hu> <18946.28620.916415.205482@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18946.28620.916415.205482@notabene.brown>
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


* Neil Brown <neilb@suse.de> wrote:

> On Sunday April 26, mingo@elte.hu wrote:
> > 
> > Hm, couldnt we switch the ioctl in drivers/md/md.c from 
> > ->locked_ioctl to ->unlocked_ioctl?
> > 
> > Neil, what do you think?
> 
> Yes, definitely.  Though it is just 'ioctl', not 'unlocked_ioctl'.
> 
> I'll queue a patch for 2.6.31.

thanks!

	Ingo
