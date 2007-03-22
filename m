Return-Path: <linux-kernel-owner+w=401wt.eu-S1753144AbXCVHFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144AbXCVHFV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 03:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbXCVHFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 03:05:21 -0400
Received: from smtp-104-thursday.noc.nerim.net ([62.4.17.104]:1977 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753144AbXCVHFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 03:05:20 -0400
Date: Thu, 22 Mar 2007 08:03:56 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Cc: "Bob Copeland" <me@bobcopeland.com>, bryan.wu@analog.com,
       "David Brownell" <david-b@pacbell.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alexey Dobriyan" <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 4/4] Blackfin: on-chip Two Wire Interface I2C driver
Message-Id: <20070322080356.738b7a1e.khali@linux-fr.org>
In-Reply-To: <8bd0f97a0703211214ic7e42d2pa9452ef52b566fd9@mail.gmail.com>
References: <1174471688.5648.56.camel@roc-desktop>
	<b6c5339f0703211117m70d01240mdfe1c0798d3296e2@mail.gmail.com>
	<8bd0f97a0703211214ic7e42d2pa9452ef52b566fd9@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007 15:14:29 -0400, Mike Frysinger wrote:
> On 3/21/07, Bob Copeland <me@bobcopeland.com> wrote:
> > > +config I2C_BLACKFIN_TWI
> > > +       tristate "Blackfin TWI I2C support"
> > > +       depends on I2C && (BF534 || BF536 || BF537)
> > > +       help
> > > +         This is the TWI I2C device driver for Blackfin 534/536/537.
> > > +         This driver can also be built as a module.  If so, the module
> > > +         will be called i2c-bfin-twi.
> >
> > Pardon my ignorance, but is there any reason to call it "Blackfin TWI"
> > as opposed to just "Blackfin" since TWI and I2C mean the same thing?
> > It lends itself to some redundancies such as:
> >
> > > +       pr_info("I2C: Blackfin I2C TWI driver\n");
> 
> it reflects the hardware manual and all public Analog Devices
> documentation ... the peripheral is always referred to as a "Two Wire
> Interface that is fully compatible with the I2C standard" since using
> the "I2C" term is not free

Damn, I hate it when legal idiocy takes the lead on technical clarity :(

-- 
Jean Delvare
