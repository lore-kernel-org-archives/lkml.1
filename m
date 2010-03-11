Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402Ab0CKNWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 08:22:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56674 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932087Ab0CKNWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 08:22:31 -0500
Date: Thu, 11 Mar 2010 14:22:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, x86 <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, k8 nb: Enable k8_northbridges unconditionally on AMD
Message-ID: <20100311132202.GF11837@elte.hu>
References: <20100308170637.GA26565@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100308170637.GA26565@aftab>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@amd64.org> wrote:

> Hi,
> 
> we're getting the following oopsie with current -git. Proposed patch is below:

alas, your patch doesnt always build:

drivers/built-in.o: In function `agp_amd64_probe':
amd64-agp.c:(.devinit.text+0x81d2): undefined reference to `cache_k8_northbridges'
amd64-agp.c:(.devinit.text+0x8207): undefined reference to `k8_northbridges'
amd64-agp.c:(.devinit.text+0x8409): undefined reference to `num_k8_northbridges'
amd64-agp.c:(.devinit.text+0x8500): undefined reference to `k8_northbridges'

Thanks,

	Ingo
