Return-Path: <linux-kernel-owner+w=401wt.eu-S1756003AbZAJMzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbZAJMzh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 07:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754889AbZAJMzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 07:55:14 -0500
Received: from mk-outboundfilter-5-a-2.mail.uk.tiscali.com ([212.74.114.4]:42506
	"EHLO mk-outboundfilter-5-a-2.mail.uk.tiscali.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987AbZAJMzM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 07:55:12 -0500
X-Trace: 122468347/mk-outboundfilter-5.mail.uk.tiscali.com/F2S/$F2S-NILDRAM-ACCEPTED/f2s-nildram-customers/195.149.44.6/None/alistair@devzero.co.uk
X-SBRS: None
X-RemoteIP: 195.149.44.6
X-IP-MAIL-FROM: alistair@devzero.co.uk
X-MUA: KMail/1.10.3 (Linux/2.6.28-damocles; KDE/4.1.3; x86_64; ; )
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap8EAL0paEnDlSwG/2dsb2JhbACBa88WhW8
X-IronPort-AV: E=Sophos;i="4.37,244,1231113600"; 
   d="scan'208";a="122468347"
X-IP-Direction: IN
From: Alistair John Strachan <alistair@devzero.co.uk>
To: "Roman Medina-Heigl Hernandez" <roman@rs-labs.com>
Subject: Re: Oops with Gigabyte motherboard "GA-X48-DQ6" and r8168 Realtek driver
Date: Sat, 10 Jan 2009 12:55:07 +0000
User-Agent: KMail/1.10.3 (Linux/2.6.28-damocles; KDE/4.1.3; x86_64; ; )
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org
References: <49671B77.7080705@rs-labs.com> <200901092252.46448.elendil@planet.nl> <4967DE52.3040709@rs-labs.com>
In-Reply-To: <4967DE52.3040709@rs-labs.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901101255.07611.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 January 2009 23:31:30 Roman Medina-Heigl Hernandez wrote:
> Frans Pop escribió:
> > Roman Medina-Heigl Hernandez wrote:
> >> It includes two RTL8111/8168B NICs, which seem the cause of the kernel
> >> crashes (*but I'm not sure*)..., a Quad core, 4GB RAM and two 500GB HDs.
> >>
> >> I installed Debian Linux (4.0) on it and I'm getting *kernel panic*
> >> errors (r8168 module) when set to production state. I couldn't get any
> >> kernel debug messages since I'm using Debian stock kernel
> >> (2.6.18-6-686-bigmem) and I'm not a kernel hacker either.
> >
> > Have you tried the 2.6.24 kernel that is available for Debian Etch? That
> > seems to me the most logical thing to try first as a possible solution.
>
> I didn't (although I thought of it). It seems to me like a blind attempt
> and the problem is that I cannot afford to waste another "production
> attempt" and that I cannot reproduce the crash whenever I want, so if I
> upgrade I'll not be able to know whether the problem is fixed or not until
> I got a new crash (or not). Moreover, if the root cause of the problem is
> r8168 driver, it will crash in both cases (the driver doesn't change, it's
> compiled from source by me).

One thing to bear in mind is that if you're using a CPU which goes via swiotlb 
(such as a pre-nehalem Intel Quad) 2.6.24 won't be new enough. The r8169 
driver until recently had a grave bug on >=4GB RAM systems where the kernel 
would crash after some amount of transfer.

My advice to you is to install the very latest Debian kernel (2.6.27) in which 
this bug has been fixed. That said, I think if you do this, you won't have any 
further problems. Using the vendor driver instead of the one in mainline 
probably isn't a good idea.

-- 
Cheers,
Alistair.
