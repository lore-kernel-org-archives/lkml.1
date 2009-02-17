Return-Path: <linux-kernel-owner+w=401wt.eu-S1753759AbZBQKaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbZBQKaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 05:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbZBQKaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 05:30:05 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:58827 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750921AbZBQKaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 05:30:01 -0500
X-BigFish: VPS-27(zz1432R98dR1805M936fMzzzzz32i6bh43j)
X-WSS-ID: 0KF7H5P-02-0UF-01
Date: Tue, 17 Feb 2009 11:29:33 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yinghai@kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] x86: memtest: adapt log messages
Message-ID: <20090217102933.GD6298@alberich.amd.com>
References: <20090213144600.GA6298@alberich.amd.com> <20090213145517.GD13000@alberich.amd.com> <20090213165302.GA24299@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090213165302.GA24299@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 17 Feb 2009 10:29:49.0444 (UTC) FILETIME=[A9550C40:01C990EA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 13, 2009 at 05:53:02PM +0100, Ingo Molnar wrote:
> 
> * Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> 
> > +#ifdef CONFIG_X86_64
> > +			printk(KERN_CONT "\n  %010llx - %010llx pattern %016llx",
> > +			       t_start, t_start + t_size, cpu_to_be64(pattern));
> > +#else
> > +			printk(KERN_CONT "\n  %010llx - %010llx pattern %08x",
> > +			       t_start, t_start + t_size, cpu_to_be32(pattern));
> > +#endif
> 
> hm, is there really no cleaner way to do this?

There is -- but only if 32-bit-code is changed to use u64 for the test
pattern.


Andreas


