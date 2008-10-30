Return-Path: <linux-kernel-owner+w=401wt.eu-S1758516AbYJ3VYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758516AbYJ3VYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbYJ3VYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:24:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50829 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376AbYJ3VYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:24:08 -0400
Date: Thu, 30 Oct 2008 22:23:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix missing cpu_index initialisation
Message-ID: <20081030212359.GC30303@elte.hu>
References: <1225401217.19324.28.camel@localhost.localdomain> <86802c440810301421t71e88ffm112a7bd361e7920a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440810301421t71e88ffm112a7bd361e7920a@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

>   CC      arch/x86/kernel/cpu/common.o
> arch/x86/kernel/cpu/common.c: In function 'early_identify_cpu':
> arch/x86/kernel/cpu/common.c:553: error: 'boot_cpu_id' undeclared
> (first use in this function)
> arch/x86/kernel/cpu/common.c:553: error: (Each undeclared identifier
> is reported only once
> arch/x86/kernel/cpu/common.c:553: error: for each function it appears in.)
> make[2]: *** [arch/x86/kernel/cpu/common.o] Error 1
> make[1]: *** [arch/x86/kernel/cpu] Error 2
> make: *** [arch/x86/kernel] Error 2

depends on this patch perhaps:

Subject: [PATCH] fix compile breakage caused by	dc1e35c6e95e8923cf1d3510438b63c600fee1e2

?

	Ingo
