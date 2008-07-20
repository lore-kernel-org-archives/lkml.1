Return-Path: <linux-kernel-owner+w=401wt.eu-S1756843AbYGTH2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbYGTH2u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 03:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbYGTH2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 03:28:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33344 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223AbYGTH2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 03:28:42 -0400
Date: Sun, 20 Jul 2008 09:28:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: use x86_ops with numaq
Message-ID: <20080720072832.GD32168@elte.hu>
References: <200807190207.26077.yhlu.kernel@gmail.com> <200807191801.17143.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807191801.17143.yhlu.kernel@gmail.com>
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

> move numaq related mps table handling to numaq_32.c
> 
> also moving calling to smp_read_mpc_oem() to smp_read_mpc directly
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

applied, thanks Yinghai. Again, very nice cleanups.

I guess we could remove mach-numaq real soon?

The APIC/IPI stuff it uses seems quite close to standard, with a few 
quirks.

SMP bootup details seem a bit special in mach_wakecpu.h.

	Ingo
