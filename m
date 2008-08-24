Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbYHXJPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbYHXJPF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 05:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbYHXJOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 05:14:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51648 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbYHXJOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 05:14:54 -0400
Date: Sun, 24 Aug 2008 11:14:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/18] merge apic_32.c and apic_64.c
Message-ID: <20080824091436.GB27274@elte.hu>
References: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> 	calibrated_APIC_clock still have two copies.
> 	it seems we should use 32 bit, because some system may not has tsc
> 	but it is some long than 64 bits...

correct, the 32-bit calibration code looks more mature, so we should 
pick that. (after making sure it's properly 64-bit clean)

	Ingo
