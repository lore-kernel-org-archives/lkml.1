Return-Path: <linux-kernel-owner+w=401wt.eu-S933572AbZJIPqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933572AbZJIPqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 11:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932688AbZJIPqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 11:46:37 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:43487 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183AbZJIPqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 11:46:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=rSXfLwXY+BM7DktltWZ6RllhFUMMFZ7gb2jkZpBtyjM6BH1Mzjl33r5Z6w+O3fWB1+
         j21+xcOgExNkYf846J8BPPs/mdyj2XEH07Vu/q8YtVgtfPmYUFFPI1IOD3I2gNUi7BYU
         nxDfY+ay0ooWMPZw2NWr/SjOIj1dKj0dQsI0g=
Subject: Re: [PATCH] MIPS: add IRQF_TIMER flag for Timer Interrupts
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-mips@linux-mips.org, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, ralf@linux-mips.org,
       rjw@sisk.pl, yuasa@linux-mips.org
In-Reply-To: <20091010.001754.229727131.anemo@mba.ocn.ne.jp>
References: <1255007874-19574-1-git-send-email-wuzhangjin@gmail.com>
	 <20091010.001754.229727131.anemo@mba.ocn.ne.jp>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Fri, 09 Oct 2009 23:45:49 +0800
Message-Id: <1255103149.3658.112.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-10 at 00:17 +0900, Atsushi Nemoto wrote:
> On Thu,  8 Oct 2009 21:17:54 +0800, Wu Zhangjin <wuzhangjin@gmail.com> wrote:
> > This patch add IRQF_TIMER flag for all Timer interrupts in linux-MIPS,
> > which will help to not disable the Timer IRQ when suspending to ensure
> > resuming normally(d6c585a4342a2ff627a29f9aea77c5ed4cd76023) and not
> > thread them when enabled PREEMPT_RT.
> > 
> > Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
> > ---
> >  arch/mips/jazz/irq.c                |    2 +-
> >  arch/mips/kernel/cevt-gt641xx.c     |    2 +-
> >  arch/mips/kernel/cevt-r4k.c         |    2 +-
> >  arch/mips/kernel/i8253.c            |    2 +-
> >  arch/mips/nxp/pnx8550/common/time.c |    2 +-
> >  arch/mips/sgi-ip27/ip27-timer.c     |    2 +-
> >  arch/mips/sni/time.c                |    2 +-
> >  7 files changed, 7 insertions(+), 7 deletions(-)
> 
> Maybe cevt-bcm1480.c, cevt-ds1287.c, cevt-sb1250.c, cevt-txx9.c and
> i8253.c need same fix?
> 

I got them via "grep timer -ur arch/mips | grep name", so, perhaps there
are also some other timer interrupts missing here.

just get more via "grep Timer -ur arch/mips | grep name", "grep IRQF_
-ur arch/mips/ | grep -v TIMER | grep =", a new patch will be sent out
in the next E-mail.

Regards,
	Wu Zhangjin

