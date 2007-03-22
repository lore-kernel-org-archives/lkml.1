Return-Path: <linux-kernel-owner+w=401wt.eu-S1753243AbXCVHNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbXCVHNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 03:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbXCVHNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 03:13:33 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:24099 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbXCVHNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 03:13:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FXQn7VHluAyBo2efV6oAaaKukZXxZxwBV17tz25GixIJn0vaHF8A3SVdzFbS1NbwXXjFjXyu9RtJNpNQVkbD+pii3Hv9w1FExf6NUxwW1f74oVHJEVlESriabs7ns9OQB0op14GWiLNNL4flbrdCJF4UELshRcoynIxnDxc9TYE=
Message-ID: <8bd0f97a0703220013h7898e5e6sd97df17705765d57@mail.gmail.com>
Date: Thu, 22 Mar 2007 03:13:32 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [PATCH -mm 4/4] Blackfin: on-chip Two Wire Interface I2C driver
Cc: "Bob Copeland" <me@bobcopeland.com>, bryan.wu@analog.com,
       "David Brownell" <david-b@pacbell.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alexey Dobriyan" <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070322080356.738b7a1e.khali@linux-fr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1174471688.5648.56.camel@roc-desktop>
	 <b6c5339f0703211117m70d01240mdfe1c0798d3296e2@mail.gmail.com>
	 <8bd0f97a0703211214ic7e42d2pa9452ef52b566fd9@mail.gmail.com>
	 <20070322080356.738b7a1e.khali@linux-fr.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/22/07, Jean Delvare <khali@linux-fr.org> wrote:
> On Wed, 21 Mar 2007 15:14:29 -0400, Mike Frysinger wrote:
> > On 3/21/07, Bob Copeland <me@bobcopeland.com> wrote:
> > > > +config I2C_BLACKFIN_TWI
> > > > +       tristate "Blackfin TWI I2C support"
> > > > +       depends on I2C && (BF534 || BF536 || BF537)
> > > > +       help
> > > > +         This is the TWI I2C device driver for Blackfin 534/536/537.
> > > > +         This driver can also be built as a module.  If so, the module
> > > > +         will be called i2c-bfin-twi.
> > >
> > > Pardon my ignorance, but is there any reason to call it "Blackfin TWI"
> > > as opposed to just "Blackfin" since TWI and I2C mean the same thing?
> > > It lends itself to some redundancies such as:
> > >
> > > > +       pr_info("I2C: Blackfin I2C TWI driver\n");
> >
> > it reflects the hardware manual and all public Analog Devices
> > documentation ... the peripheral is always referred to as a "Two Wire
> > Interface that is fully compatible with the I2C standard" since using
> > the "I2C" term is not free
>
> Damn, I hate it when legal idiocy takes the lead on technical clarity :(

i'm with you 100% but it isnt my call to make ;(
-mike
