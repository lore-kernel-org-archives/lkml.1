Return-Path: <linux-kernel-owner+w=401wt.eu-S1752638AbYIWLHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbYIWLHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 07:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbYIWLHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 07:07:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49053 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbYIWLHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 07:07:25 -0400
Date: Tue, 23 Sep 2008 13:07:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Russ Anderson <rja@sgi.com>, Huang@elte.hu, Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>
Subject: Re: [PATCH 2/4] x86: Add UV bios call infrastructure
Message-ID: <20080923110711.GD29021@elte.hu>
References: <20080922210928.GE222374@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922210928.GE222374@sgi.com>
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


* Russ Anderson <rja@sgi.com> wrote:

> +/*
> + * IF EFI is not configured, have the EFI calls return unimplemented.
> + */
> +u64 efi_call6(void *fp, u64 arg1, u64 arg2, u64 arg3,
> +			u64 arg4, u64 arg5, u64 arg6)
> +{
> +	return  BIOS_STATUS_UNIMPLEMENTED;
> +}

> +#ifndef CONFIG_EFI
> +extern u64 efi_call6(void *, u64, u64, u64, u64, u64, u64);
> +#endif

shouldnt this be done in include/asm-x86/efi.h and 
arch/x86/kernel/efi_stub_64.S instead?

	Ingo
