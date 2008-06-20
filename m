Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbYFTKHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbYFTKHh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 06:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbYFTKH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 06:07:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56377 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073AbYFTKH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 06:07:27 -0400
Date: Fri, 20 Jun 2008 12:07:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Bisecting tip/auto-x86-next?
Message-ID: <20080620100708.GC17692@elte.hu>
References: <485AFC9B.7090502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <485AFC9B.7090502@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kevin Winchester <kjwinchester@gmail.com> wrote:

> include/asm/thread_info_64.h: In function ‘set_restore_sigmask’:
> include/asm/thread_info_64.h:189: warning: passing argument 2 of  
> ‘set_bit’ from incompatible pointer type
>
> -----------------
>
> Can I ignore these warnings and keep building the kernel anyway? [...]

btw., you can probably ignore this one safely. Also please tell me at 
which commit ID you were at when you triggered this warning.

	Ingo
