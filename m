Return-Path: <linux-kernel-owner+w=401wt.eu-S1762171AbXJMLug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762171AbXJMLug (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 07:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbXJMLu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 07:50:29 -0400
Received: from www.tglx.de ([62.245.132.106]:34346 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756229AbXJMLu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 07:50:28 -0400
Date: Sat, 13 Oct 2007 13:50:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Patrizio Bassi <patrizio.bassi@gmail.com>
cc: "Kernel, " <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-git3 compilation broken, asm headers missing?
In-Reply-To: <4710AD07.70000@gmail.com>
Message-ID: <alpine.LFD.0.9999.0710131348310.12017@localhost.localdomain>
References: <4710AD07.70000@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Oct 2007, Patrizio Bassi wrote:
> include/linux/types.h:15:23: error: asm/types.h: No such file or directory
> In file included from include/linux/prefetch.h:13,
>                  from include/linux/list.h:8,
>                  from include/linux/module.h:9,
>                  from include/linux/crypto.h:21,
>                  from arch/x86/kernel/asm-offsets_32.c:7,
>                  from arch/x86/kernel/asm-offsets.c:2:
> 
> full log attached.

That's a stale include/asm symlink. Can you save your .config file and do 

make mrproper

please and check if it's solved.

Thanks,

	tglx

