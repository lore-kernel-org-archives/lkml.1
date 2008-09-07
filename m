Return-Path: <linux-kernel-owner+w=401wt.eu-S1755823AbYIGPrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823AbYIGPrn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 11:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbYIGPrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 11:47:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46316 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbYIGPrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 11:47:35 -0400
Date: Sun, 7 Sep 2008 17:47:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, yhlu.kernel@gmail.com
Subject: Re: [patch 3/3] x86: io-apic - code style cleaning for
	setup_IO_APIC_irqs
Message-ID: <20080907154721.GA13177@elte.hu>
References: <48c02b6a.0637560a.15e9.ffffa39d@mx.google.com> <20080905080447.GC12409@elte.hu> <20080905180126.GA19334@lenovo> <20080905181111.GG27395@elte.hu> <20080905183347.GB19334@lenovo> <20080905183835.GA19215@elte.hu> <20080906101533.GA7273@lenovo> <Pine.LNX.4.55.0809061938250.13851@cliff.in.clinika.pl> <20080906184914.GG21872@elte.hu> <20080907100000.GA7515@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080907100000.GA7515@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> here is an another attempt to satisfy the requirements :)
> Please review and comment if it looks better or worse now.

sigh, i think the extra buffering is clearly worse. These are early init 
printks and we already do many other cases of multi-line printouts and 
even KERN_CONT printouts. We have a perfectly fine built-in buffer 
already: the printk buffer.

	Ingo
