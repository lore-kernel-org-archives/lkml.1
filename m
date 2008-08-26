Return-Path: <linux-kernel-owner+w=401wt.eu-S1757836AbYHZIlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836AbYHZIlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 04:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbYHZIlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 04:41:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57540 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbYHZIlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 04:41:12 -0400
Date: Tue, 26 Aug 2008 10:41:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joe Korty <joe.korty@ccur.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] lockstat - repair erronous contention statistics
Message-ID: <20080826084102.GD27080@elte.hu>
References: <20080825211623.GA27969@tsunami.ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080825211623.GA27969@tsunami.ccur.com>
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

> Fix bad contention counting in /proc/lock_stat.
> 
> /proc/lockstat tries to gather per-ip contention
> statistics per-lock.  This was failing due to
> a garbage per-ip index selector being used.

applied to tip/core/urgent, thanks Joe.

	Ingo
