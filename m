Return-Path: <linux-kernel-owner+w=401wt.eu-S933755AbXCUTOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933755AbXCUTOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 15:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933782AbXCUTOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 15:14:44 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:20266 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933770AbXCUTOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 15:14:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aIaU2sSho/OblGaiHarSJ+/k6Bq86dwkMZOQFN7uNgjAl5w424lxKJoMtTBnIgL0SdjwhVYjnhw9uPEDXyWd1+WKCQwCD28FPjRqRrWdh9BfRWkRrzG10k6vf20fR/XSpvnD6a1ltwiYkhWYPdnZ8ppTb5KTuqyW+BxgNXpv/Cg=
Message-ID: <8bd0f97a0703211214ic7e42d2pa9452ef52b566fd9@mail.gmail.com>
Date: Wed, 21 Mar 2007 15:14:29 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: [PATCH -mm 4/4] Blackfin: on-chip Two Wire Interface I2C driver
Cc: bryan.wu@analog.com, khali@linux-fr.org,
       "David Brownell" <david-b@pacbell.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alexey Dobriyan" <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <b6c5339f0703211117m70d01240mdfe1c0798d3296e2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1174471688.5648.56.camel@roc-desktop>
	 <b6c5339f0703211117m70d01240mdfe1c0798d3296e2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/21/07, Bob Copeland <me@bobcopeland.com> wrote:
> > +config I2C_BLACKFIN_TWI
> > +       tristate "Blackfin TWI I2C support"
> > +       depends on I2C && (BF534 || BF536 || BF537)
> > +       help
> > +         This is the TWI I2C device driver for Blackfin 534/536/537.
> > +         This driver can also be built as a module.  If so, the module
> > +         will be called i2c-bfin-twi.
>
> Pardon my ignorance, but is there any reason to call it "Blackfin TWI"
> as opposed to just "Blackfin" since TWI and I2C mean the same thing?
> It lends itself to some redundancies such as:
>
> > +       pr_info("I2C: Blackfin I2C TWI driver\n");

it reflects the hardware manual and all public Analog Devices
documentation ... the peripheral is always referred to as a "Two Wire
Interface that is fully compatible with the I2C standard" since using
the "I2C" term is not free
-mike
