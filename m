Return-Path: <linux-kernel-owner+w=401wt.eu-S1762266AbZAQPF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762266AbZAQPF3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 10:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757971AbZAQPFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 10:05:10 -0500
Received: from mk-outboundfilter-5-a-2.mail.uk.tiscali.com ([212.74.114.4]:60238
	"EHLO mk-outboundfilter-5-a-2.mail.uk.tiscali.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757963AbZAQPFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 10:05:08 -0500
X-Trace: 124278979/mk-outboundfilter-5.mail.uk.tiscali.com/F2S/$F2S-NILDRAM-ACCEPTED/f2s-nildram-customers/195.149.44.6/None/alistair@devzero.co.uk
X-SBRS: None
X-RemoteIP: 195.149.44.6
X-IP-MAIL-FROM: alistair@devzero.co.uk
X-MUA: KMail/1.10.4 (Linux/2.6.29-rc2-damocles; KDE/4.1.4; x86_64; ; )
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArcEAOSCcUnDlSwG/2dsb2JhbACBbMoThXM
X-IronPort-AV: E=Sophos;i="4.37,281,1231113600"; 
   d="scan'208";a="124278979"
X-IP-Direction: IN
From: Alistair John Strachan <alistair@devzero.co.uk>
To: w.landgraf@yahoo.com
Subject: Re: 2.6.29-rc2 rt2860 driver
Date: Sat, 17 Jan 2009 15:04:53 +0000
User-Agent: KMail/1.10.4 (Linux/2.6.29-rc2-damocles; KDE/4.1.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <755926.36103.qm@web112217.mail.gq1.yahoo.com>
In-Reply-To: <755926.36103.qm@web112217.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901171504.53299.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 January 2009 14:30:01 We La wrote:
> 1) In the press was published that 2.6.29 would include the rt2860 WIFI
> driver.  However, in 2.6.29-rc2 one find nowhere this driver. rt2x00 don't
> work, at least ifconfig ra0 up gives a error message.  and to compile it
> from source code, works with 2.6.26.X but not with 2.6.29-rc2 (plenty error
> messages) What's the situation of the rt2860 driver ??  The only senseful
> criterion for inclusion of a driver in the kernel is not the maturity of
> the code, but the number of sellings of that hardware in the shops, and
> that driver is necessary for msi wind notebooks, so it should be included
> into the kernel.

It's in the kernel. You need to enable CONFIG_STAGING which is Greg's option 
for "these drivers aren't as good quality as normal Linux drivers but we're 
providing them anyway for early adopters". Exactly your argument, I think.

Device Drivers -> Staging drivers
Exclude Staging drivers from being built -> n
Ralink 2860 wireless support (NEW)

Hope this helps.

-- 
Cheers,
Alistair.
