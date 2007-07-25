Return-Path: <linux-kernel-owner+w=401wt.eu-S932163AbXGYHh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163AbXGYHh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 03:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760176AbXGYHhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 03:37:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33240 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754870AbXGYHhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 03:37:17 -0400
Date: Wed, 25 Jul 2007 09:37:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Deepak Saxena <dsaxena@plexity.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -rt] Disable lpptest on !Linux hosts
Message-ID: <20070725073710.GA595@elte.hu>
References: <20070724205103.GA32043@plexity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070724205103.GA32043@plexity.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.6
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.6 required=5.9 tests=BAYES_00,UPPERCASE_25_50 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.4 UPPERCASE_25_50        message body is 25-50% uppercase
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Deepak Saxena <dsaxena@plexity.net> wrote:

>  hostprogs-$(CONFIG_IKCONFIG)     += bin2c
> +HOST_OS := $(shell uname)
> +ifeq ($(HOST_OS),Linux)
>  ifdef CONFIG_LPPTEST
>  hostprogs-y      += testlpp
>  endif
> +endif

ok, i've applied this.

	Ingo
