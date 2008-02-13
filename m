Return-Path: <linux-kernel-owner+w=401wt.eu-S1761243AbYBMNGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761243AbYBMNGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 08:06:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756757AbYBMNGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 08:06:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35948 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452AbYBMNGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 08:06:20 -0500
Date: Wed, 13 Feb 2008 14:06:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: rdreier@cisco.com, linux-kernel@vger.kernel.org
Subject: Re: Strange hang on ia64 with CONFIG_PRINTK_TIME=y
Message-ID: <20080213130601.GF6344@elte.hu>
References: <adazlu5tlve.fsf@cisco.com> <20080212.230156.33759433.davem@davemloft.net> <20080213125725.GC6344@elte.hu> <20080213.050340.64342037.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213.050340.64342037.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* David Miller <davem@davemloft.net> wrote:

> I see nothing illegal in what cpu_clock() is doing, that's why I fixed 
> the sparc64 per-cpu problem I ran into since sparc64 was doing the 
> wrong thing when booted on a non-zero cpu.

okay. I'm just somewhat uneasy about potentially losing the ability to 
printk. printk must stay simple and dependable. Maybe PRINTK_TIMESTAMPs 
should be delayed to at the point when system_state == SYSTEM_RUNNING.

	Ingo
