Return-Path: <linux-kernel-owner+w=401wt.eu-S1753364AbYH1JlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbYH1JlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 05:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbYH1Jk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 05:40:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36963 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbYH1Jk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 05:40:58 -0400
Date: Thu, 28 Aug 2008 11:40:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joe Korty <joe.korty@ccur.com>
Cc: Mark Brown <broonie@sirena.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Simon Farnsworth <simon.farnsworth@onelan.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] printk timestamp post-boot suppression, v2
Message-ID: <20080828094032.GC28783@elte.hu>
References: <20080827151613.GA10325@tsunami.ccur.com> <20080827161621.GF10834@sirena.org.uk> <20080827170424.GA17217@tsunami.ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080827170424.GA17217@tsunami.ccur.com>
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


* Joe Korty <joe.korty@ccur.com> wrote:

> On Wed, Aug 27, 2008 at 12:16:30PM -0400, Mark Brown wrote:
> > It'd be nicer if this were optional - syslog typically only logs at
> > second resolution and not all systems are going to have logfiles.
> 
> Optionally suppress printk timestamping after system boot.

i think the best approach is to write an initcall tracer - i think Arjan 
has some ideas in that area.

that would be infinitely higher quality than anything printk based 
anyway, as with ftrace you could see the reasons of why a boot delay 
happens - which tasks context-switch, in which code path, etc.

	Ingo
