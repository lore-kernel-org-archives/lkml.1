Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab0CHK5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 05:57:13 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42851 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753348Ab0CHK5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 05:57:08 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       James.Bottomley@HansenPartnership.com, benh@kernel.crashing.org,
       linux@arm.linux.org.uk, mdharm-kernel@one-eyed-alien.net,
       linux-usb@vger.kernel.org, x0082077@ti.com, sshtylyov@ru.mvista.com,
       tom.leiming@gmail.com, bigeasy@linutronix.de, oliver@neukum.org,
       linux-kernel@vger.kernel.org, santosh.shilimkar@ti.com, greg@kroah.com,
       linux-arm-kernel@lists.infradead.org
In-Reply-To: <20100307082344.GB1987@elf.ucw.cz>
References: <20100226210030.GC23933@n2100.arm.linux.org.uk>
	 <1267316072.23523.1842.camel@pasglop>
	 <1267333263.2762.11.camel@mulgrave.site>
	 <20100302211049V.fujita.tomonori@lab.ntt.co.jp>
	 <1267549527.15401.78.camel@e102109-lin.cambridge.arm.com>
	 <20100303215437.GF2579@ucw.cz>
	 <1267709756.6526.380.camel@e102109-lin.cambridge.arm.com>
	 <20100304135128.GA12191@atrey.karlin.mff.cuni.cz>
	 <1267716956.6526.491.camel@e102109-lin.cambridge.arm.com>
	 <20100307082344.GB1987@elf.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Mon, 08 Mar 2010 10:57:04 +0000
Message-ID: <1268045824.14199.37.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Mar 2010 10:57:05.0267 (UTC) FILETIME=[16FBD430:01CABEAE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-03-07 at 08:23 +0000, Pavel Machek wrote:
> > > Seems like ARM has requirement other architectures do not, that is
> > > a) not documented anywhere
> > > b) causes problems
> >
> > Well, ARM is pretty similar to other architectures in this respect. And
> > I'm sure other architectures have similar problems, only that they only
> > become visible in some circumstances they may not have encountered (i.e.
> > PIO drivers + filesystem that doesn't call flush_dcache_page like ext*).
> > Some other architectures may do heavier flushing
> >
> > Of course, a Documentation/arm/cachetlb.txt file would make sense.
> 
> Actually, short/simple documentation for driver authors would be even
> better. Then you can claim it is bug in driver :-).

That would help, but only once we agree whether it's a driver bug or the
arch code needs changing.

-- 
Catalin

