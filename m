Return-Path: <linux-kernel-owner+w=401wt.eu-S1756917AbZFAKEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917AbZFAKEF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 06:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbZFAKD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 06:03:56 -0400
Received: from tango.tkos.co.il ([62.219.50.35]:47823 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbZFAKDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 06:03:55 -0400
Date: Mon, 1 Jun 2009 13:02:35 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH v2] gpio: driver for PrimeCell PL061 GPIO controller
Message-ID: <20090601100234.GA8025@jasper.tkos.co.il>
References: <1243846836-14395-1-git-send-email-baruch@tkos.co.il> <20090601093106.GC11880@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090601093106.GC11880@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Mon, Jun 01, 2009 at 10:31:06AM +0100, Russell King - ARM Linux wrote:
> On Mon, Jun 01, 2009 at 12:00:36PM +0300, Baruch Siach wrote:
> > This is a driver for the ARM PrimeCell PL061 GPIO AMBA peripheral. The driver
> > is implemented using the gpiolib framework.
> 
> Why is this a platform driver rather than an AMBA primecell driver?

I'm willing to make this driver an AMBA driver. I'd just like to know what is 
the advantage of the AMBA bus (linux/amba/bus.h) over the platform "bus", from 
software point of view?

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
