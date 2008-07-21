Return-Path: <linux-kernel-owner+w=401wt.eu-S1755787AbYGULDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbYGULDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 07:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbYGULDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 07:03:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55431 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbYGULDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 07:03:43 -0400
Date: Mon, 21 Jul 2008 13:03:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: use setup_clear_cpu_cap with disable_apic
Message-ID: <20080721110330.GA10782@elte.hu>
References: <200807210138.15054.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807210138.15054.yhlu.kernel@gmail.com>
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

> so don't need to call clear_cpu_cap again in early_identify_cpu, and 
> could use cleared_cpu_caps like other setup clear.

applied to tip/x86/core, thanks Yinghai.

	Ingo
