Return-Path: <linux-kernel-owner+w=401wt.eu-S1755605AbYBQQX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605AbYBQQX6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 11:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbYBQQXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 11:23:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52103 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbYBQQXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 11:23:49 -0500
Date: Sun, 17 Feb 2008 17:23:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com, hpa@zytor.com,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] [x86] arch/x86/kernel/signal_32.c: replace
	!likely(x) by likely(!x)
Message-ID: <20080217162335.GF6006@elte.hu>
References: <47B7065B.8090209@tiscali.nl> <47B73963.1050702@tiscali.nl> <47B73FF4.6000804@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B73FF4.6000804@tiscali.nl>
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


* Roel Kluin <12o3l@tiscali.nl> wrote:

> -	if (on_sig_stack(sp) && !likely(on_sig_stack(sp - frame_size)))
> +	if (on_sig_stack(sp) && unlikely(!on_sig_stack(sp - frame_size)))

hm, what's the purpose of this change?

	Ingo
