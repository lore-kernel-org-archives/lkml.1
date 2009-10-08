Return-Path: <linux-kernel-owner+w=401wt.eu-S932680AbZJHPO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680AbZJHPO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 11:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932663AbZJHPO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 11:14:28 -0400
Received: from www.tglx.de ([62.245.132.106]:41876 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932629AbZJHPO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 11:14:27 -0400
Date: Thu, 8 Oct 2009 17:13:00 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Wu Zhangjin <wuzhangjin@gmail.com>
cc: linux-mips@linux-mips.org, pm list <linux-pm@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yoichi Yuasa <yuasa@linux-mips.org>
Subject: Re: [PATCH] MIPS: add IRQF_TIMER flag for Timer Interrupts
In-Reply-To: <1255007874-19574-1-git-send-email-wuzhangjin@gmail.com>
Message-ID: <alpine.LFD.2.00.0910081712390.9428@localhost.localdomain>
References: <1255007874-19574-1-git-send-email-wuzhangjin@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Oct 2009, Wu Zhangjin wrote:

> This patch add IRQF_TIMER flag for all Timer interrupts in linux-MIPS,
> which will help to not disable the Timer IRQ when suspending to ensure
> resuming normally(d6c585a4342a2ff627a29f9aea77c5ed4cd76023) and not
> thread them when enabled PREEMPT_RT.
> 
> Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>

Acked-by: Thomas Gleixner <tglx@linutronix.de>
