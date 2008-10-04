Return-Path: <linux-kernel-owner+w=401wt.eu-S1752851AbYJDIrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbYJDIrT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 04:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbYJDIrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 04:47:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44710 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbYJDIrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 04:47:00 -0400
Date: Sat, 4 Oct 2008 10:46:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC PATCH] x86: make 64bit efi to use ioremap_cache for
	efi_ioremap
Message-ID: <20081004084644.GF27624@elte.hu>
References: <1223101400-8819-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223101400-8819-1-git-send-email-yhlu.kernel@gmail.com>
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

> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> ---
>  arch/x86/kernel/efi.c       |    5 +----
>  arch/x86/kernel/efi_64.c    |   27 ++-------------------------
>  include/asm-x86/efi.h       |    8 ++------
>  include/asm-x86/fixmap_64.h |    3 ---
>  4 files changed, 5 insertions(+), 38 deletions(-)

ok, that looks like a very nice cleanup and should make the EFI mapping 
code more generic and more robust as well.

Huang, any chance you could test this against latest tip/master on a 
real EFI system?

	Ingo
