Return-Path: <linux-kernel-owner+w=401wt.eu-S1757140AbYGTJzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140AbYGTJzv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 05:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754996AbYGTJzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 05:55:43 -0400
Received: from mk-outboundfilter-6-a-2.mail.uk.tiscali.com ([212.74.114.16]:57696
	"EHLO mk-outboundfilter-6-a-2.mail.uk.tiscali.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754703AbYGTJzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 05:55:42 -0400
X-Trace: 4416509/mk-outboundfilter-6.mail.uk.tiscali.com/F2S/$F2S-ACCEPTED/f2s-freedom2Surf-customers/195.137.94.162
X-SBRS: None
X-RemoteIP: 195.137.94.162
X-IP-MAIL-FROM: spyro@f2s.com
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApwAANWogkjDiV6i/2dsb2JhbAAIrS0
X-IronPort-AV: E=Sophos;i="4.31,218,1215385200"; 
   d="scan'208";a="4416509"
X-IP-Direction: IN
Subject: Re: [PATCH 1/3] at91_mci: Enable MMC_CAP_SDIO_IRQ only when it
	actually works
From: ian <spyro@f2s.com>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Andrew Victor <linux@maxim.org.za>
In-Reply-To: <20080719010143.142d59a0@mjolnir.drzeus.cx>
References: <487F120F.2050305@atmel.com>
	 <20080717125544.36f41947@mjolnir.drzeus.cx> <48809B00.1070405@atmel.com>
	 <20080719010143.142d59a0@mjolnir.drzeus.cx>
Content-Type: text/plain
Date: Sun, 20 Jul 2008 10:55:39 +0100
Message-Id: <1216547739.3200.5.camel@wirenth>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-07-19 at 01:01 +0200, Pierre Ossman wrote:
> > In your opinion, a printed warning that says to be sure to use only 
> > 4-bit mode SDIO cards on slot B... is not acceptable ?
> 
> It's not really up to the user. The SDIO spec does not mandate 4-bit
> support, so some cards will not have it.

That seems overly rigid.

its not linux violating the spec, its the SDIO controller in this case.

I see no harm in supporting what the hardware is actually capable of.

It wouldnt be the first bit of broken hardware supported by linux.

