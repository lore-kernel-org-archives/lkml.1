Return-Path: <linux-kernel-owner+w=401wt.eu-S1753128AbYGXF04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbYGXF04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 01:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbYGXF0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 01:26:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53992 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527AbYGXF0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 01:26:47 -0400
Date: Thu, 24 Jul 2008 07:26:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       jgarzik@redhat.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [build failure] hp-plus.c: (.text+0xd7c1a): undefined
	reference to `ei_close'
Message-ID: <20080724052603.GA8744@elte.hu>
References: <20080721.233512.128618365.anemo@mba.ocn.ne.jp> <20080721191519.GA15843@elte.hu> <20080721214258.787a67ca@lxorguk.ukuu.org.uk> <20080722072334.GA25241@elte.hu> <48865899.3030209@garzik.org> <20080723104520.GA20672@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723104520.GA20672@elte.hu>
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


not sure it's known but despite all the fixes i still get:

 drivers/built-in.o: In function `ne_drv_resume':
 ne.c:(.text+0x146ba4): undefined reference to `NS8390_init'
 drivers/built-in.o: In function `ne_block_output':
 ne.c:(.text+0x146e00): undefined reference to `NS8390_init'
 drivers/built-in.o: In function `hpp_close':
 hp-plus.c:(.text+0x148c3b): undefined reference to `ei_close'
 drivers/built-in.o: In function `hpp_open':
 hp-plus.c:(.text+0x148c77): undefined reference to `ei_interrupt'
 hp-plus.c:(.text+0x148ce7): undefined reference to `ei_open'
 drivers/built-in.o: In function `ne_probe1':
 ne.c:(.init.text+0xb532): undefined reference to `NS8390_init'
 drivers/built-in.o: In function `hpp_probe1':
 hp-plus.c:(.init.text+0xc033): undefined reference to `ei_poll'
 drivers/built-in.o: In function `hp_plus_probe':
 (.init.text+0xc134): undefined reference to `__alloc_ei_netdev'
 make: *** [.tmp_vmlinux1] Error 1

with this config and latest -git (v2.6.26-6371-g338b9bb):

 http://redhat.com/~mingo/misc/config-Thu_Jul_24_07_13_29_CEST_2008.bad

	Ingo
