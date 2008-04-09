Return-Path: <linux-kernel-owner+w=401wt.eu-S1757916AbYDITUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916AbYDITUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 15:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757283AbYDITUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 15:20:34 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56053 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757254AbYDITUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 15:20:33 -0400
Date: Wed, 9 Apr 2008 20:20:09 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dmitry <dbaryshkov@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, haavard.skinnemoen@atmel.com,
       lethal@linux-sh.org, philipp.zabel@gmail.com, pavel@ucw.cz,
       tony@atomide.com, paul@pwsan.com
Subject: Re: [PATCH 5/6] Clocklib: Use correct clock for IrDA on pxa
Message-ID: <20080409192009.GB13891@flint.arm.linux.org.uk>
References: <20080403132142.GA26882@doriath.ww600.siemens.net> <20080403132402.GA27008@doriath.ww600.siemens.net> <20080407160029.f1f9ce4f.akpm@linux-foundation.org> <20080407230434.GA525@flint.arm.linux.org.uk> <bc64b4640804080247s82ba84chd740c08b2fbb9b1a@mail.gmail.com> <20080408193309.GA18053@flint.arm.linux.org.uk> <bc64b4640804090015m7dd640d5j31c54b99007f09a7@mail.gmail.com> <20080409190504.GA13891@flint.arm.linux.org.uk> <20080409200916.78615f39@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080409200916.78615f39@core>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2008 at 08:09:16PM +0100, Alan Cox wrote:
> > Basically what I'm thinking is a serial_core function which could be
> > called to say "I'm an IrDA driver, and I think I should be using the
> > serial port located <here>, please give me control of it" and it'd
> > pass over the various parameters including the struct device for it.
> > Or something like that.
> 
> It's called a line discipline, we've had them for many years. We may need
> a way for ldiscs and drivers to co-operate a bit more but these days we
> support proper buffering and arbitary baud rates (except on a few
> platforms whose maintainers are not paying attention ;)).

I feel that's a "it would be nice if" solution - and something worth
aiming for, but the amount of work required to get there is not going
to be insignificant.

Maybe Dmitry can bite his nails on the NULL device clklib issue for a
while as this transition is happening ?  (Though we need to find someone
to make it happen... we need volunteers!)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
