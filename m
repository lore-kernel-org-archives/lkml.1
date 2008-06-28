Return-Path: <linux-kernel-owner+w=401wt.eu-S1755347AbYF1Gha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347AbYF1Gha (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 02:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754319AbYF1GhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 02:37:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39036 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754247AbYF1GhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 02:37:15 -0400
Date: Sat, 28 Jun 2008 08:37:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: let setup_arch call init_apic_mappings for 32bit
Message-ID: <20080628063703.GC15710@elte.hu>
References: <200806251748.06743.yhlu.kernel@gmail.com> <200806252151.29028.yhlu.kernel@gmail.com> <200806262317.48716.yhlu.kernel@gmail.com> <200806270141.56409.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806270141.56409.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> instead of calling it from trap_init()
> 
> also move init ioapic mapping out of apic_32.c
> 
> so 32 bit do same as 64 bit

applied to tip/x86/unify-setup - thanks Yinghai.

	Ingo
