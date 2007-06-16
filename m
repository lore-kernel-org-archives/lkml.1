Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbXFPJYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbXFPJYS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 05:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbXFPJYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 05:24:11 -0400
Received: from mail.screens.ru ([213.234.233.54]:43080 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010AbXFPJYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 05:24:10 -0400
Date: Sat, 16 Jun 2007 13:24:15 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: John Blackwood <john.blackwood@ccur.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] selective signal ptracing
Message-ID: <20070616092415.GA130@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Blackwood wrote:
>
> By default all signals are ptraced as before. However, a debugger
> may now modify the set of per-task ptraced signals, where only the
> signals in this ptrace signal mask will be ptraced.

I must admit, I agree with Roland...

> +void ptrace_update_traced_signals(struct task_struct *child,
> +							sigset_t *new_smaskp)
> +{
> [...snip...]
> +
> +		spin_lock_irqsave(&child->sighand->siglock, flags);
> +
> +		if (child->sighand == NULL) {

How so?

Oleg.

