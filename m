Return-Path: <linux-kernel-owner+w=401wt.eu-S1753563AbYIFMKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbYIFMKF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 08:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbYIFMJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 08:09:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49980 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbYIFMJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 08:09:55 -0400
Date: Sat, 6 Sep 2008 14:09:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: remove duplicated get_mode_name calling
Message-ID: <20080906120937.GC30964@elte.hu>
References: <1220691148-5608-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220691148-5608-1-git-send-email-yhlu.kernel@gmail.com>
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
>  arch/x86/kernel/cpu/amd.c       |    3 ---
>  arch/x86/kernel/cpu/amd_64.c    |    3 +--
>  arch/x86/kernel/cpu/centaur.c   |    1 -
>  arch/x86/kernel/cpu/common.c    |    9 +++------
>  arch/x86/kernel/cpu/cpu.h       |    1 -
>  arch/x86/kernel/cpu/cyrix.c     |    1 -
>  arch/x86/kernel/cpu/transmeta.c |    1 -
>  7 files changed, 4 insertions(+), 15 deletions(-)

applied to tip/x86/unify-cpu-detect, thanks Yinghai.

	Ingo
