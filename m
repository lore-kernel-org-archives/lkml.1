Return-Path: <linux-kernel-owner+w=401wt.eu-S1757101AbZBINop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101AbZBINop (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 08:44:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756079AbZBINms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 08:42:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52638 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756589AbZBINmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 08:42:47 -0500
Date: Mon, 9 Feb 2009 14:42:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: hpa@zytor.com, jeremy@goop.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, x86@kernel.org, rusty@rustcorp.com.au
Subject: Re: [PATCH 02/11] x86: math_emu info cleanup
Message-ID: <20090209134234.GA14048@elte.hu>
References: <1234186798-16820-1-git-send-email-tj@kernel.org> <1234186798-16820-3-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234186798-16820-3-git-send-email-tj@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Impact: cleanup
> 
> * Come on, struct info?  s/struct info/struct math_emu_info/
> 
> * Use struct pt_regs and kernel_vm86_regs instead of defining its own
>   register frame structure.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  arch/x86/include/asm/math_emu.h  |   29 +++++------------
>  arch/x86/include/asm/processor.h |    2 +-
>  arch/x86/math-emu/fpu_entry.c    |    2 +-
>  arch/x86/math-emu/fpu_proto.h    |    2 +-
>  arch/x86/math-emu/fpu_system.h   |   14 ++++----
>  arch/x86/math-emu/get_address.c  |   63 ++++++++++++++++++--------------------
>  6 files changed, 48 insertions(+), 64 deletions(-)

Nice - that's a fix for .29 too, right?

	Ingo
