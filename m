Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab0CGIXe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 03:23:34 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:36570 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750857Ab0CGIXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 03:23:33 -0500
Date: Sun, 7 Mar 2010 09:23:44 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       James.Bottomley@HansenPartnership.com, benh@kernel.crashing.org,
       linux@arm.linux.org.uk, mdharm-kernel@one-eyed-alien.net,
       linux-usb@vger.kernel.org, x0082077@ti.com, sshtylyov@ru.mvista.com,
       tom.leiming@gmail.com, bigeasy@linutronix.de, oliver@neukum.org,
       linux-kernel@vger.kernel.org, santosh.shilimkar@ti.com, greg@kroah.com,
       linux-arm-kernel@lists.infradead.org
Subject: Re: USB mass storage and ARM cache coherency
Message-ID: <20100307082344.GB1987@elf.ucw.cz>
References: <20100226210030.GC23933@n2100.arm.linux.org.uk>
 <1267316072.23523.1842.camel@pasglop>
 <1267333263.2762.11.camel@mulgrave.site>
 <20100302211049V.fujita.tomonori@lab.ntt.co.jp>
 <1267549527.15401.78.camel@e102109-lin.cambridge.arm.com>
 <20100303215437.GF2579@ucw.cz>
 <1267709756.6526.380.camel@e102109-lin.cambridge.arm.com>
 <20100304135128.GA12191@atrey.karlin.mff.cuni.cz>
 <1267716956.6526.491.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267716956.6526.491.camel@e102109-lin.cambridge.arm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Seems like ARM has requirement other architectures do not, that is
> > a) not documented anywhere
> > b) causes problems
> 
> Well, ARM is pretty similar to other architectures in this respect. And
> I'm sure other architectures have similar problems, only that they only
> become visible in some circumstances they may not have encountered (i.e.
> PIO drivers + filesystem that doesn't call flush_dcache_page like ext*).
> Some other architectures may do heavier flushing
> 
> Of course, a Documentation/arm/cachetlb.txt file would make sense.

Actually, short/simple documentation for driver authors would be even
better. Then you can claim it is bug in driver :-).
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
