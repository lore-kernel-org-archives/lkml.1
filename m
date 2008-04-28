Return-Path: <linux-kernel-owner+w=401wt.eu-S965262AbYD1Sqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965262AbYD1Sqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 14:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934255AbYD1SqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 14:46:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58895 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933507AbYD1SqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 14:46:16 -0400
Date: Mon, 28 Apr 2008 20:45:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: move i386 memory setup code to e820_32.c
Message-ID: <20080428184555.GB4491@elte.hu>
References: <20080423130905.GA7347@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080423130905.GA7347@mailshack.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander van Heukelum <heukelum@mailshack.com> wrote:

> The x86_64 code has centralized the memory setup code in e820_64.c. 
> This patch copies that approach to i386:
> 
> - early_param("mem", ...) parsing is moved from
> setup_32.c to e820_32.c.
> 
> - setup_memory_map() and finish_e820_parsing() are
> factored out from setup_arch(), and declarations
> are added to e820_32.h.
> 
> - print_memory_map() is made static and removed from
> e820_32.h.
> 
> - user_defined_memmap is marked as __initdata.

applied, thanks Alexander.

	Ingo
