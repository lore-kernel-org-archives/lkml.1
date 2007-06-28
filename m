Return-Path: <linux-kernel-owner+w=401wt.eu-S1762824AbXF1PBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762824AbXF1PBA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 11:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756399AbXF1PAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 11:00:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46378 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbXF1PAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 11:00:52 -0400
Date: Thu, 28 Jun 2007 17:00:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Sattler <tsattler@gmx.de>
Cc: Oleg Nesterov <oleg@tv-sign.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.22-rc6 spurious hangs
Message-ID: <20070628150047.GA14494@elte.hu>
References: <4683BF16.40905@gmx.de> <20070628144741.GA437@tv-sign.ru> <4683CC89.80406@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4683CC89.80406@gmx.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Sattler <tsattler@gmx.de> wrote:

> >> As Ingo told me I run 'echo t > /proc/sysrq-trigger' this time. The
> >> corresponding part of my syslogs is attached, as well as my kernel config.
> > 
> > Could you try the patch below? It dumps some info when flush_workqueue()
> > hangs.
> 
> I'm compiling a patched kernel right now. As I wrote in my former mail 
> the whole thing not easy to trigger. So it can take some time to get 
> the info.

i'd suggest to increase CONFIG_LOG_BUF_SHIFT=17 to =20 in your .config - 
to make sure the full SysRq-t dump is captured when you do it.

	Ingo
