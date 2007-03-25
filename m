Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbXCYHaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbXCYHaA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 03:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbXCYH37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 03:29:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41487 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341AbXCYH36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 03:29:58 -0400
Date: Sun, 25 Mar 2007 09:29:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Early hang with 2.6.21-rc4-rt1
Message-ID: <20070325072947.GA10734@elte.hu>
References: <adad52xnccs.fsf@cisco.com> <ada8xdlnb6f.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada8xdlnb6f.fsf@cisco.com>
User-Agent: Mutt/1.4.2.2i
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


* Roland Dreier <rdreier@cisco.com> wrote:

> OK, another data point.  The config below boots and works with 
> 2.6.21-rc4-rt1, but enabling CONFIG_CRITICAL_IRQSOFF_TIMING causes the 
> early boot hang.
> 
> Any idea?

ah, i havent tried that option in quite some time, so bitrot is pretty 
likely. Does the problem go away if you disable CONFIG_FUNCTION_TRACE? 
If the problem goes away then it would suggest some sort of 
mcount()-driven recursion into hardirqs_off/hardirqs_on.

	Ingo
