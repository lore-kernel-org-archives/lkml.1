Return-Path: <linux-kernel-owner+w=401wt.eu-S1759976AbYF2JuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759976AbYF2JuX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 05:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759672AbYF2Jtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 05:49:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42767 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759623AbYF2Jtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 05:49:52 -0400
Date: Sun, 29 Jun 2008 11:49:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix warning in e820_reserve_resources with 32bit
Message-ID: <20080629094941.GC3001@elte.hu>
References: <200806251748.06743.yhlu.kernel@gmail.com> <200806271538.46829.yhlu.kernel@gmail.com> <200806272247.11971.yhlu.kernel@gmail.com> <200806281749.59443.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200806281749.59443.yhlu.kernel@gmail.com>
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

> when 64bit resource is not enabled, got:
> 
> arch/x86/kernel/e820.c: In function ‘e820_reserve_resources’:
> arch/x86/kernel/e820.c:1217: warning: comparison is always false due to limited range of data type
> 
> because res->start/end is resource_t aka u32. it will overflow.
> 
> fix it with temp end of u64

applied, thanks.

	Ingo
