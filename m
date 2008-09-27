Return-Path: <linux-kernel-owner+w=401wt.eu-S1753324AbYI0QKC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbYI0QKC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 12:10:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbYI0QJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 12:09:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59901 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbYI0QJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 12:09:53 -0400
Date: Sat, 27 Sep 2008 18:09:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] x86: mtrr_cleanup optimization v2
Message-ID: <20080927160936.GA29661@elte.hu>
References: <1222500608-14855-1-git-send-email-yhlu.kernel@gmail.com> <1222500608-14855-3-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222500608-14855-3-git-send-email-yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0077]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> fix hpa's t61 with 4g ram
>    change layout from
> 	(n - 1)*chunksize + chunk_size - NC
>    to
> 	n*chunksize - NC

applied the three patches to tip/x86/mtrr, thanks Yinghai!

i'm wondering, arent 2/3 and 3/3 also for v2.6.27?

	Ingo
