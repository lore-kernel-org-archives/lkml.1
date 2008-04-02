Return-Path: <linux-kernel-owner+w=401wt.eu-S1756677AbYDBMhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677AbYDBMhn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 08:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754402AbYDBMhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 08:37:34 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:53537 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394AbYDBMhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 08:37:33 -0400
Date: Wed, 02 Apr 2008 21:38:17 +0900 (JST)
Message-Id: <20080402.213817.74752727.anemo@mba.ocn.ne.jp>
To: dmitri.vorobiev@gmail.com
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] [MIPS] unexport null_perf_irq() and make it static
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <1207094318-21748-6-git-send-email-dmitri.vorobiev@gmail.com>
References: <1207094318-21748-1-git-send-email-dmitri.vorobiev@gmail.com>
	<1207094318-21748-6-git-send-email-dmitri.vorobiev@gmail.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  2 Apr 2008 03:58:38 +0400, Dmitri Vorobiev <dmitri.vorobiev@gmail.com> wrote:
> --- a/arch/mips/oprofile/op_model_mipsxx.c
> +++ b/arch/mips/oprofile/op_model_mipsxx.c
> @@ -31,6 +31,8 @@
>  
>  #define M_COUNTER_OVERFLOW		(1UL      << 31)
>  
> +int (*save_perf_irq)(void);

This should be another target of "make it static" patch :-)

---
Atsushi Nemoto
