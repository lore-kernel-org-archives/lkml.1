Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbXLKQyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbXLKQyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 11:54:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbXLKQxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 11:53:52 -0500
Received: from gw.goop.org ([64.81.55.164]:45007 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbXLKQxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 11:53:52 -0500
Message-ID: <475EC0A0.1000206@goop.org>
Date: Tue, 11 Dec 2007 08:53:52 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 4/4] x86: unify asm-x86/pgtable*.h
References: <475DA7BF.8090606@goop.org> <20071211082910.GB15183@elte.hu>
In-Reply-To: <20071211082910.GB15183@elte.hu>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> when applied to x86.git#mm this patch has build problems:
>
> include/asm/pgtable.h: In function 'pte_modify':
> include/asm/pgtable.h:246: error: 'pteval_t' undeclared (first use in this function)
> include/asm/pgtable.h:246: error: (Each undeclared identifier is reported only once
> include/asm/pgtable.h:246: error: for each function it appears in.)
> include/asm/pgtable.h:246: error: expected ';' before 'pte'
> include/asm/pgtable.h:247: error: 'pte' undeclared (first use in this function)
>
> config attached.
>   

Hm, odd.  I compiled and booted 32-bit and 64-bit.  Ah, though I may
have missed 32-bit non-PAE,  which is your config.

    J
