Return-Path: <linux-kernel-owner+w=401wt.eu-S1761145AbZJIPTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761145AbZJIPTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 11:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761135AbZJIPTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 11:19:17 -0400
Received: from mba.ocn.ne.jp ([122.28.14.163]:57556 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761133AbZJIPTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 11:19:16 -0400
Date: Sat, 10 Oct 2009 00:17:54 +0900 (JST)
Message-Id: <20091010.001754.229727131.anemo@mba.ocn.ne.jp>
To: wuzhangjin@gmail.com
Cc: linux-mips@linux-mips.org, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, ralf@linux-mips.org,
       rjw@sisk.pl, yuasa@linux-mips.org
Subject: Re: [PATCH] MIPS: add IRQF_TIMER flag for Timer Interrupts
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <1255007874-19574-1-git-send-email-wuzhangjin@gmail.com>
References: <1255007874-19574-1-git-send-email-wuzhangjin@gmail.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  8 Oct 2009 21:17:54 +0800, Wu Zhangjin <wuzhangjin@gmail.com> wrote:
> This patch add IRQF_TIMER flag for all Timer interrupts in linux-MIPS,
> which will help to not disable the Timer IRQ when suspending to ensure
> resuming normally(d6c585a4342a2ff627a29f9aea77c5ed4cd76023) and not
> thread them when enabled PREEMPT_RT.
> 
> Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
> ---
>  arch/mips/jazz/irq.c                |    2 +-
>  arch/mips/kernel/cevt-gt641xx.c     |    2 +-
>  arch/mips/kernel/cevt-r4k.c         |    2 +-
>  arch/mips/kernel/i8253.c            |    2 +-
>  arch/mips/nxp/pnx8550/common/time.c |    2 +-
>  arch/mips/sgi-ip27/ip27-timer.c     |    2 +-
>  arch/mips/sni/time.c                |    2 +-
>  7 files changed, 7 insertions(+), 7 deletions(-)

Maybe cevt-bcm1480.c, cevt-ds1287.c, cevt-sb1250.c, cevt-txx9.c and
i8253.c need same fix?

---
Atsushi Nemoto
