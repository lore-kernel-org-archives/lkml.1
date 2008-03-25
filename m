Return-Path: <linux-kernel-owner+w=401wt.eu-S1756965AbYCYP03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965AbYCYP03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 11:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756000AbYCYP0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 11:26:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37553 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755330AbYCYP0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 11:26:18 -0400
Date: Tue, 25 Mar 2008 16:25:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joe Perches <joe@perches.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 134/148] include/asm-x86/uaccess_64.h: checkpatch
	cleanups - formatting only
Message-ID: <20080325152559.GA20898@elte.hu>
References: <1206259443-13210-1-git-send-email-joe@perches.com> <1206259443-13210-135-git-send-email-joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206259443-13210-135-git-send-email-joe@perches.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1957]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joe Perches <joe@perches.com> wrote:

> +	    : "1" (addr), "g" ((long)(size)),				\
> +	      "g" (current_thread_info()->addr_limit.seg));		\
> +	flag;
> +})

hm, you apparently never built this on 64-bit x86? The above has a 
trivial typo.

	Ingo
