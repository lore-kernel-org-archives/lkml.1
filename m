Return-Path: <linux-kernel-owner+w=401wt.eu-S1761266AbYDKT7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761266AbYDKT7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 15:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760853AbYDKT7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 15:59:32 -0400
Received: from www.tglx.de ([62.245.132.106]:52406 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760822AbYDKT7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 15:59:31 -0400
Date: Fri, 11 Apr 2008 21:59:20 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] [RFC] UIO: generic platform driver
Message-ID: <20080411195920.GM3185@local>
References: <1207831023-8583-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-2-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-3-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-4-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-5-git-send-email-Uwe.Kleine-Koenig@digi.com> <20080410224804.GI3193@local> <20080411062106.GA18096@digi.com> <20080411092449.GB3185@local> <20080411104154.GA18986@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080411104154.GA18986@digi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 12:41:54PM +0200, Uwe Kleine-König wrote:
> > problem? Please move the declaration to the top of the function.

> I'm not conviced and still prefer it that way.  I gave way for your
> requests in uio.c because it's your code.  I want to leave it as it is
> and hope you will accept that (as this is my code).

I looked around a bit and talked to some people. It seems that a local
variable declaration within a for{} block is OK. I still don't like it,
but I won't object any longer.

So, AFAICT you've only got that arch dependency problem left to solve.

Thanks,
Hans

