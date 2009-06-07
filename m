Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbZFGVqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbZFGVqY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 17:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbZFGVqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 17:46:17 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43131 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbZFGVqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 17:46:16 -0400
Date: Sun, 7 Jun 2009 22:45:59 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Baruch Siach <baruch@tkos.co.il>, linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH v4] gpio: driver for PrimeCell PL061 GPIO controller
Message-ID: <20090607214559.GD7785@n2100.arm.linux.org.uk>
References: <1244399935-23128-1-git-send-email-baruch@tkos.co.il> <63386a3d0906071433h516ee358ud2e64a90692fa4f9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <63386a3d0906071433h516ee358ud2e64a90692fa4f9@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 07, 2009 at 11:33:23PM +0200, Linus Walleij wrote:
> OK sorry for coming in so late, this is really not so important but anyway:
> 
> 2009/6/7 Baruch Siach <baruch@tkos.co.il>:
> > This is a driver for the ARM PrimeCell PL061 GPIO AMBA peripheral. The driver
> > is implemented using the gpiolib framework.
> >
> > This driver also includes support for the use of the PL061 as an interrupt
> > controller (secondary).
> >
> > Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> > ---
> > Changes in v4:
> >        - Depend on CONFIG_ARM_AMBA
> >        - Do not request the gpio for IRQ automatically, just warn if it's not
> >          requested
> >        - Remove SZ_4K
> 
> Yes but defined a new one 4*1024 instead, but I'll show, hang on...

Hint: it got changed because we don't want to use SZ_4K in drivers which
can be used externally to ARM.
