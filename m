Return-Path: <linux-kernel-owner+w=401wt.eu-S1765505AbXJOT1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765505AbXJOT1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 15:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759200AbXJOT1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 15:27:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50464 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759224AbXJOT1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 15:27:16 -0400
Date: Mon, 15 Oct 2007 21:27:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch] scsi: fix crash in gdth_timeout()
Message-ID: <20071015192703.GA7279@elte.hu>
References: <20071015165534.GA17833@elte.hu> <alpine.LFD.0.999.0710151006400.6887@woody.linux-foundation.org> <4713A9FA.4050209@garzik.org> <4713B4E7.2050001@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4713B4E7.2050001@panasas.com>
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


* Boaz Harrosh <bharrosh@panasas.com> wrote:

> > Honestly, the driver is probably rarely run by people that lack the 
> > hardware, I bet...
> 
> It was all "flight by instruments only". I called for HW testers and 
> none came forward. All these changes, apart from "successful downgrade 
> to messy" where also needed in order to push important changes to 
> scsi.
> 
> But a little bird said that QEMU might simulate this HW. SO I guess it 
> is QEMU time for me.

heh. Incidentally i was thinking about using KVM for automated testing. 
Important pieces of hardware should get an in-KVM simulator/emulator, 
that way developers who do not own that hardware can do functionality 
testing too. So basically the highest-quality drivers would have an 
"inverse driver" in KVM, which simulates the hardware. (that model is 
evidently useful to the hardware maker even for new hardware: it can 
then also be used to test the Linux compatibility and Linux performance 
of future planned releases of the hardware, etc.)

	Ingo
