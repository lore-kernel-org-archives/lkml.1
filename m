Return-Path: <linux-kernel-owner+w=401wt.eu-S1753466AbYIQM7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbYIQM7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 08:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbYIQM7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 08:59:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59618 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbYIQM7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 08:59:35 -0400
Date: Wed, 17 Sep 2008 14:59:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<ukleinek@informatik.uni-freiburg.de>
Cc: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>,
       Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH] gpio_free might sleep, x86 architecture
Message-ID: <20080917125900.GB18192@elte.hu>
References: <1216884515-12084-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <1221508963-27259-1-git-send-email-ukleinek@informatik.uni-freiburg.de> <1221508963-27259-2-git-send-email-ukleinek@informatik.uni-freiburg.de> <1221508963-27259-3-git-send-email-ukleinek@informatik.uni-freiburg.de> <1221508963-27259-4-git-send-email-ukleinek@informatik.uni-freiburg.de> <1221508963-27259-5-git-send-email-ukleinek@informatik.uni-freiburg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1221508963-27259-5-git-send-email-ukleinek@informatik.uni-freiburg.de>
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


* Uwe Kleine-König <ukleinek@informatik.uni-freiburg.de> wrote:

> According to the documentation gpio_free should only be called from task
> context only.  To make this more explicit add a might sleep to all
> implementations.
> 
> This patch changes the gpio_free implementations for the x86
> architecture.

applied to tip/x86/debug, thanks Uwe,

	Ingo
