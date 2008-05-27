Return-Path: <linux-kernel-owner+w=401wt.eu-S1759315AbYE0XgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315AbYE0XgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 19:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbYE0XgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 19:36:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58714 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbYE0XgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 19:36:11 -0400
Date: Tue, 27 May 2008 19:36:08 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH -rt] fix sysrq+l when nmi_watchdog disabled
In-Reply-To: <483C8EEC.2030306@ct.jp.nec.com>
Message-ID: <Pine.LNX.4.58.0805271935320.13815@gandalf.stny.rr.com>
References: <483C8EEC.2030306@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 27 May 2008, Hiroshi Shimamoto wrote:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>
> In nmi_show_all_regs(), set nmi_show_regs for all cpus but NMI never come
> to itself when nmi_watchdog is disabled. It means the kernel hangs up when
> sysrq+l is issued.
>
> Call irq_show_regs_callback() itself before calling smp_send_nmi_allbutself().

Thanks,

I had a patch to do this fix but it got lost. I'll add yours.

-- Steve

>
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
