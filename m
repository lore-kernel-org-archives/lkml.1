Return-Path: <linux-kernel-owner+w=401wt.eu-S1759679AbXJYKUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759679AbXJYKUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 06:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbXJYKUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 06:20:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35245 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590AbXJYKUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 06:20:46 -0400
Date: Thu, 25 Oct 2007 12:20:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Amit Walambe <amit.walambe@eurotech-ltd.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: x86 compile failure on 2.6.24-rc1
Message-ID: <20071025102040.GA30907@elte.hu>
References: <20071025100550.637a3af3@eurotech-ltd.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071025100550.637a3af3@eurotech-ltd.co.uk>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0027]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Amit Walambe <amit.walambe@eurotech-ltd.co.uk> wrote:

> Hi!
> I get following error while compiling 2.6.24-rc1 : 
> 
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> arch/x86/kernel/built-in.o: In function `machine_crash_shutdown':
> (.text+0x191c8): undefined reference to `genapic'
> make: *** [.tmp_vmlinux1] Error 1

see:

 http://lkml.org/lkml/2007/10/24/128

	Ingo
