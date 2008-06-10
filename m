Return-Path: <linux-kernel-owner+w=401wt.eu-S1758308AbYFJJx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758308AbYFJJx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 05:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbYFJJxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 05:53:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54358 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbYFJJxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 05:53:48 -0400
Date: Tue, 10 Jun 2008 11:53:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: numa32 use find_e820_area to find KVA ram on node
Message-ID: <20080610095303.GB27706@elte.hu>
References: <200806031025.55026.yhlu.kernel@gmail.com> <200806031935.05202.yhlu.kernel@gmail.com> <200806061443.57488.yhlu.kernel@gmail.com> <200806061853.33968.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806061853.33968.yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> don't assume we can use ram near end of every node.
> esp some system has less memory. and they could have
> kva address and kva ram all below max_low_pfn

applied to tip/x86/mpparse, thanks Yinghai.

	Ingo
