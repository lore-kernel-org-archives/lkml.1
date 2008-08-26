Return-Path: <linux-kernel-owner+w=401wt.eu-S1757558AbYHZIhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbYHZIhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 04:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbYHZIhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 04:37:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60081 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbYHZIhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 04:37:38 -0400
Date: Tue, 26 Aug 2008 10:37:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joe Korty <joe.korty@ccur.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] lockstat - fix numerical output rounding error
Message-ID: <20080826083721.GC27080@elte.hu>
References: <20080825211533.GA27943@tsunami.ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080825211533.GA27943@tsunami.ccur.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0027]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joe Korty <joe.korty@ccur.com> wrote:

> Fix rounding error in /proc/lock_stat numerical output.
> 
> On occasion the two digit fractional part contains the three
> digit value '100'.  This is due to a bug in the rounding algorithm
> which pushes values in the range '95..99' to '100' rather than
> to '00' + an increment to the integer part.  For example,
> 
> 	- 123456.100      old display
> 	+ 123457.00	  new display

applied to tip/core/urgent - thanks Joe!

(btw., please include Signed-off-by lines in your patches in the future)

	Ingo
