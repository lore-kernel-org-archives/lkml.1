Return-Path: <linux-kernel-owner+w=401wt.eu-S1757999AbYGRMV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999AbYGRMV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755312AbYGRMVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:21:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44461 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755154AbYGRMVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:21:50 -0400
Date: Fri, 18 Jul 2008 14:21:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: I/O APIC: Include <asm/i8259.h> required by some
	code
Message-ID: <20080718122128.GL6875@elte.hu>
References: <Pine.LNX.4.55.0807141709300.16334@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0807141709300.16334@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0020]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Maciej W. Rozycki <macro@linux-mips.org> wrote:

>  Include <asm/i8259.h> for i8259A_lock used in print_PIC() -- #if-0-ed out
> by default.  The 32-bit version gets it right already.
> 
> Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
> ---
>  The plan is to enable this code with "apic=debug" eventually.  This will
> aid with debugging strange problems without the need to ask people to
> apply patches.

applied to tip/x86/apic, thanks Maciej.

	Ingo
