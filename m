Return-Path: <linux-kernel-owner+w=401wt.eu-S1757522AbZFAKQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522AbZFAKQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 06:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbZFAKPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 06:15:53 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40081 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbZFAKPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 06:15:52 -0400
Date: Mon, 1 Jun 2009 11:15:41 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Baruch Siach <baruch@tkos.co.il>
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH v2] gpio: driver for PrimeCell PL061 GPIO controller
Message-ID: <20090601101541.GA14072@n2100.arm.linux.org.uk>
References: <1243846836-14395-1-git-send-email-baruch@tkos.co.il> <20090601093106.GC11880@n2100.arm.linux.org.uk> <20090601100234.GA8025@jasper.tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090601100234.GA8025@jasper.tkos.co.il>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 01:02:35PM +0300, Baruch Siach wrote:
> Hi Russell,
> 
> On Mon, Jun 01, 2009 at 10:31:06AM +0100, Russell King - ARM Linux wrote:
> > On Mon, Jun 01, 2009 at 12:00:36PM +0300, Baruch Siach wrote:
> > > This is a driver for the ARM PrimeCell PL061 GPIO AMBA peripheral. The driver
> > > is implemented using the gpiolib framework.
> > 
> > Why is this a platform driver rather than an AMBA primecell driver?
> 
> I'm willing to make this driver an AMBA driver. I'd just like to know what
> is the advantage of the AMBA bus (linux/amba/bus.h) over the platform "bus",
> from software point of view?

The amba bus is the established bus for amba primecells.  I repeat:
please make it an amba bus driver.
