Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbYGXNRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbYGXNRr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 09:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbYGXNRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 09:17:38 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:48938 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552AbYGXNRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 09:17:37 -0400
Date: Thu, 24 Jul 2008 15:09:11 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 4/22] avr32: Introducing asm/syscalls.h
Message-ID: <20080724150911.5bf4372b@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <1216596035.3679.95.camel@jaswinder.satnam>
References: <1216592500.3679.14.camel@jaswinder.satnam>
	<1216592798.3679.22.camel@jaswinder.satnam>
	<1216592879.3679.24.camel@jaswinder.satnam>
	<1216593035.3679.27.camel@jaswinder.satnam>
	<1216596035.3679.95.camel@jaswinder.satnam>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 24 Jul 2008 13:09:53.0926 (UTC) FILETIME=[9020B260:01C8ED8E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh <jaswinder@infradead.org> wrote:
> +asmlinkage int sys_fork(struct pt_regs);

This should be "struct pt_regs *"

> +asmlinkage int sys_clone(unsigned long, unsigned long,
> +			 unsigned long, unsigned long,
> +			 struct pt_regs *);
> +asmlinkage int sys_vfork(struct pt_regs);

Same thing here.

Other than that, looks good to me.

Haavard
