Return-Path: <linux-kernel-owner+w=401wt.eu-S1759909AbXJKNc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759909AbXJKNc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 09:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759423AbXJKNc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 09:32:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53531 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759632AbXJKNcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 09:32:24 -0400
Date: Thu, 11 Oct 2007 15:32:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.23
Message-ID: <20071011133211.GA5510@elte.hu>
References: <alpine.LFD.0.999.0710091346490.5039@woody.linux-foundation.org> <1191996740.8694.7.camel@entropy> <20071010101452.GA25433@elte.hu> <1192070057.3019.17.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1192070057.3019.17.camel@ymzhang>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:

> > ( Config is at http://redhat.com/~mingo/misc/config, system is Core2Duo
> >   1.83 GHz, mysql-5.0.45, glibc-2.6. Nothing fancy either in the config
> >   nor in the setup - everything is pretty close to the defaults. )
>
> I used FedoraCore 8 Test2 distribution, so glibc-2.6.90-13 already 
> fixed the old malloc scalability issue. Cpu is 2.66GHZ quad core, 2 
> physical processor, totally 8 cores. The regression is about 28%.

thanks for confirming this! I've updated glibc and mysql and now i can 
reproduce something similar. (I have a theory about the reason of this 
regression, and i'm working on a test-patch.)

	Ingo
