Return-Path: <linux-kernel-owner+w=401wt.eu-S1760108AbZCOUmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760108AbZCOUmb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 16:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910AbZCOUmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 16:42:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39490 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbZCOUmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 16:42:20 -0400
Date: Sun, 15 Mar 2009 21:42:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash] Re: Latest brk patchset
Message-ID: <20090315204206.GA16184@elte.hu>
References: <49BC413B.5020104@zytor.com> <49BC4CAC.202@goop.org> <49BC4DB6.9070403@zytor.com> <49BCA03D.3020605@goop.org> <20090315203802.GA14625@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090315203802.GA14625@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> the previous kit in tip:x86/setup-memory is causing crashes. 
> One of them is:
> 
> init_memory_mapping: 0000000000000000-00000000377fe000                              
>  0000000000 - 00377fe000 page 4k                                                    
> Kernel panic - not syncing: Cannot find space for the kernel 

excluding these commits from tip:master:

2bd2753: x86: put initial_pg_tables into .bss
796216a: x86: allow extend_brk users to reserve brk space
7543c1d: x86-32: compute initial mapping size more accurately
6de6cb4: x86: use brk allocation for DMI
ccf3fe0: x86-32: use brk segment for allocating initial kernel pagetable
5368a2b: x86: move brk initialization out of #ifdef CONFIG_BLK_DEV_INITRD
93dbda7: x86: add brk allocation for very, very early allocations
b9719a4: x86: make section delimiter symbols part of their section

fixes the crashes.

	Ingo
