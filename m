Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbZFCDVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbZFCDVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 23:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbZFCDV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 23:21:29 -0400
Received: from tango.tkos.co.il ([62.219.50.35]:50120 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbZFCDV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 23:21:28 -0400
Date: Wed, 3 Jun 2009 06:20:22 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       linux-arm-kernel@lists.arm.linux.org.uk, linux@arm.linux.org.uk
Subject: Re: [PATCH v3] gpio: driver for PrimeCell PL061 GPIO controller
Message-ID: <20090603032021.GA8721@tarshish>
References: <1243975690-12073-1-git-send-email-baruch@tkos.co.il> <20090602160902.046ccffa.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090602160902.046ccffa.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Tue, Jun 02, 2009 at 04:09:02PM -0700, Andrew Morton wrote:
> On Tue,  2 Jun 2009 23:48:10 +0300
> Baruch Siach <baruch@tkos.co.il> wrote:
> 
> > This is a driver for the ARM PrimeCell PL061 GPIO AMBA peripheral. The driver
> > is implemented using the gpiolib framework.
> 
> x86_64 allmodconfig:
> 
> drivers/gpio/pl061.c: In function 'pl061_probe':
> drivers/gpio/pl061.c:254: error: 'SZ_4K' undeclared (first use in this function)
> drivers/gpio/pl061.c:254: error: (Each undeclared identifier is reported only once
> drivers/gpio/pl061.c:254: error: for each function it appears in.)
> drivers/gpio/pl061.c:306: error: implicit declaration of function 'set_irq_flags'
> drivers/gpio/pl061.c:306: error: 'IRQF_VALID' undeclared (first use in this function)
> 
> I'll put a depends-on-ARM in there...

I guess a depends-on-ARM_AMBA would be better.

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
