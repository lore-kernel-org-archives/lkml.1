Return-Path: <linux-kernel-owner+w=401wt.eu-S1760813AbXK1NQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760813AbXK1NQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 08:16:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759835AbXK1NPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 08:15:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56044 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759776AbXK1NPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 08:15:54 -0500
Date: Wed, 28 Nov 2007 14:15:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: -rt doesn't compile for UML
Message-ID: <20071128131541.GA4467@elte.hu>
References: <E1IxMK0-0006ae-2s@dorka.pomaz.szeredi.hu> <20071128125030.GB21791@elte.hu> <E1IxMfh-0006fN-HQ@dorka.pomaz.szeredi.hu> <20071128131518.GA3193@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071128131518.GA3193@elte.hu>
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
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> >   CC      kernel/latency_trace.o
> > kernel/latency_trace.c:28:21: error: asm/rtc.h: No such file or directory
> > kernel/latency_trace.c:63:3: error: #error Implement cycles_to_usecs.
> > kernel/latency_trace.c: In function ???____trace???:
> > kernel/latency_trace.c:658: error: implicit declaration of function ???irqs_disabled_flags???
> > make[1]: *** [kernel/latency_trace.o] Error 1
> 
> hm, just fill those functions in - should be fairly trivial and we can 
> carry those patches in -rt. (I'd suggest to create an empty 
> asm-um/rtc.h stub as well, for consistency.)

trivial == 'far easier than porting -rt to UML' :-)

	Ingo
