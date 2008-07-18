Return-Path: <linux-kernel-owner+w=401wt.eu-S1760284AbYGRQaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760284AbYGRQaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 12:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760200AbYGRQ3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 12:29:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48919 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760189AbYGRQ3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 12:29:54 -0400
Date: Fri, 18 Jul 2008 18:29:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] softlockup: fix invalid proc_handler for
	softlockup_panic
Message-ID: <20080718162943.GA6875@elte.hu>
References: <4872C4C0.6040307@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4872C4C0.6040307@ct.jp.nec.com>
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


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> The type of softlockup_panic is int, but the proc_handler is 
> proc_doulongvec_minmax(). This handler is for unsigned long.
> 
> This handler should be proc_dointvec_minmax().

applied to tip/core/softlockup - thanks!

	Ingo
