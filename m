Return-Path: <linux-kernel-owner+w=401wt.eu-S932776AbXJRLkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776AbXJRLkx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 07:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756900AbXJRLkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 07:40:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33371 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756389AbXJRLko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 07:40:44 -0400
Date: Thu, 18 Oct 2007 13:40:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Tejun Heo <htejun@gmail.com>, Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071018114016.GA30823@elte.hu>
References: <20071018083213.GN5063@kernel.dk> <471720FE.4090004@garzik.org> <20071018091706.GO5063@kernel.dk> <4717281B.6070301@garzik.org> <20071018094128.GP5063@kernel.dk> <47172FB1.5020704@garzik.org> <20071018100959.GQ5063@kernel.dk> <471738A6.2020201@garzik.org> <20071018105438.GB9658@elte.hu> <47173D5A.9050508@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47173D5A.9050508@garzik.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Garzik <jeff@garzik.org> wrote:

> I never had to apply the changes you included, to fix problems here.

perhaps because you are not running a CONFIG_DEBUG_PAGEALLOC=y kernel?

I recently fixed DEBUG_PAGEALLOC (it would crash upon bootup on x86 most 
of the time on any real hardware - so i doubt people were able to use it 
all that much). As long as you try Linus' latest -git tree (which has 
the latest arch/x86 merge) and use the 32-bit x86 kernel it should work 
fine for you too, and you will probably be able to trigger similar 
crashes too.

	Ingo
