Return-Path: <linux-kernel-owner+w=401wt.eu-S1756358AbYGXPJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358AbYGXPJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 11:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757922AbYGXPJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 11:09:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41983 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757929AbYGXPJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 11:09:07 -0400
Subject: Re: [PATCH 4/22] avr32: Introducing asm/syscalls.h
From: Jaswinder Singh <jaswinder@infradead.org>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20080724150911.5bf4372b@hskinnemo-gx745.norway.atmel.com>
References: <1216592500.3679.14.camel@jaswinder.satnam>
	 <1216592798.3679.22.camel@jaswinder.satnam>
	 <1216592879.3679.24.camel@jaswinder.satnam>
	 <1216593035.3679.27.camel@jaswinder.satnam>
	 <1216596035.3679.95.camel@jaswinder.satnam>
	 <20080724150911.5bf4372b@hskinnemo-gx745.norway.atmel.com>
Content-Type: text/plain
Date: Thu, 24 Jul 2008 20:37:58 +0530
Message-Id: <1216912079.15251.6.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Haavard,

On Thu, 2008-07-24 at 15:09 +0200, Haavard Skinnemoen wrote:
> Jaswinder Singh <jaswinder@infradead.org> wrote:
> > +asmlinkage int sys_fork(struct pt_regs);
> 
> This should be "struct pt_regs *"
> 
> > +asmlinkage int sys_clone(unsigned long, unsigned long,
> > +			 unsigned long, unsigned long,
> > +			 struct pt_regs *);
> > +asmlinkage int sys_vfork(struct pt_regs);
> 
> Same thing here.
> 
> Other than that, looks good to me.
> 

If you want to merge this patch in your tree then let me know.

I will fix above issues and send updated patch for avr32 tree.

Thank you,

Jaswinder Singh.

