Return-Path: <linux-kernel-owner+w=401wt.eu-S1757849AbZCCPgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849AbZCCPgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 10:36:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbZCCPgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 10:36:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43462 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbZCCPgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 10:36:11 -0500
Date: Tue, 3 Mar 2009 16:35:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6 v6] SGI RTC: add clocksource driver
Message-ID: <20090303153553.GB29454@elte.hu>
References: <20090303151044.GA20016@sgi.com> <20090303151357.GA20120@sgi.com> <20090303151524.GB20120@sgi.com> <20090303151657.GC20120@sgi.com> <20090303151827.GD20120@sgi.com> <20090303152016.GE20120@sgi.com> <20090303152206.GF20120@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090303152206.GF20120@sgi.com>
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


* Dimitri Sivanich <sivanich@sgi.com> wrote:

>  drivers/clocksource/Makefile |    1 
>  drivers/clocksource/rtc_uv.c |  381 +++++++++++++++++++++++++++++++++++++++
>  drivers/misc/Kconfig         |    9 

btw., since this is a platform driver, i'd suggest to move it to 
arch/x86/kernel/uv_time.c or so.

	Ingo
