Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbXCYHec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbXCYHec (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 03:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753488AbXCYHeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 03:34:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41611 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487AbXCYHea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 03:34:30 -0400
Date: Sun, 25 Mar 2007 09:34:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Early hang with 2.6.21-rc4-rt1
Message-ID: <20070325073424.GA14242@elte.hu>
References: <adad52xnccs.fsf@cisco.com> <ada8xdlnb6f.fsf@cisco.com> <20070325072947.GA10734@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070325072947.GA10734@elte.hu>
User-Agent: Mutt/1.4.2.2i
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > OK, another data point.  The config below boots and works with 
> > 2.6.21-rc4-rt1, but enabling CONFIG_CRITICAL_IRQSOFF_TIMING causes the 
> > early boot hang.
>
> ah, i havent tried that option in quite some time, so bitrot is pretty 
> likely. Does the problem go away if you disable CONFIG_FUNCTION_TRACE? 

hm - on 32-bit, CRITICAL_IRQSOFF_TIMING+FUNCTION_TRACING works fine for 
me. I'll try the 64-bit kernel too.

	Ingo
