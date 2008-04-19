Return-Path: <linux-kernel-owner+w=401wt.eu-S1762037AbYDSPGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762037AbYDSPGN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 11:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755598AbYDSPFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 11:05:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:53028 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530AbYDSPFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 11:05:54 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH] Re: Bad network performance over 2Gbps
To: Kok@vger.kernel.org, Auke <auke-jan.h.kok@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anton Titov <a.titov@host.bg>, Chris Snook <csnook@redhat.com>,
       "H. Willstrand" <h.willstrand@gmail.com>, netdev@vger.kernel.org,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Reply-To: 7eggert@gmx.de
Date: Sat, 19 Apr 2008 17:05:06 +0200
References: <aiXVe-Yn-7@gated-at.bofh.it> <ajGfA-7rt-9@gated-at.bofh.it> <ajGfA-7rt-11@gated-at.bofh.it> <ajGfA-7rt-13@gated-at.bofh.it> <ajGfA-7rt-15@gated-at.bofh.it> <ajGfA-7rt-7@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1JnEcl-0000xc-D9@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX18IFJ4+IEEN0BqV6peICT7LAAdB4ex+fDvOV7V
 OO2/zDIRHnfErsGxtH94XUyuaPdRxpTbZLWanUNtkAo7Erz+mb
 HX8srK1/04olNzuwp9yEw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kok, Auke <auke-jan.h.kok@intel.com> wrote:

> [X86] IRQBALANCE: Mark as BROKEN and disable by default
> 
> The IRQBALANCE option causes interrupts to bounce all around on SMP systems
> quickly burying the CPU in migration cost and cache misses. Mainly affected
> are network interrupts and this results in one CPU pegged in softirqd
> completely.

If this is the problem, maybe it would help to only balance the IRQs each
e.g. ten seconds? Unfortunately I have no SMP system to try it out.


