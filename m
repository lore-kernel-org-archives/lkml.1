Return-Path: <linux-kernel-owner+w=401wt.eu-S934085AbXGQTdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934085AbXGQTdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 15:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760660AbXGQTdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 15:33:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37643 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757308AbXGQTdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 15:33:07 -0400
Date: Tue, 17 Jul 2007 21:32:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Carsten Emde <carsten.emde@osadl.org>,
       "jcaceres@ccrma.Stanford.EDU" <jcaceres@ccrma.Stanford.EDU>,
       Steven Rostedt <rostedt@goodmis.org>,
       RT-Users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Rui Nuno Capela <rncbc@rncbc.org>
Subject: Re: v2.6.21.5-rt19 (sched_getaffinity?)
Message-ID: <20070717193223.GJ26283@elte.hu>
References: <1183582155.3291.160.camel@chaos> <9609.194.65.103.1.1183731007.squirrel@www.rncbc.org> <1183758545.20747.34.camel@cmn3.stanford.edu> <20070707092401.GB21234@elte.hu> <1183934205.11854.11.camel@cmn3.stanford.edu> <46917678.70700@googlemail.com> <Pine.LNX.4.63.0707082047130.12404@cmn3.stanford.edu> <1183957703.12681.4.camel@cmn3.stanford.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183957703.12681.4.camel@cmn3.stanford.edu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:

> I do get flash 9 (I know, not the best example) and tomboy to hang as 
> reported by one of my Planet CCRMA users - flash 9 tested working on 
> stock fedora 7 kernel - and both seem to hang in the same system call:
> 
> sched_getaffinity(3528, 32, <unfinished ...>
> 
> Full output of strace attached for both cases.

hm, that's weird. Is it completely unkillable at that time? Could you do 
a few things: enable CONFIG_PROVE_LOCKING (lockdep), and also try to get 
a full task state dump via:

  echo t > /proc/sysrq-trigger

thanks,

	Ingo
