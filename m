Return-Path: <linux-kernel-owner+w=401wt.eu-S1752753Ab0AGOEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab0AGOEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 09:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692Ab0AGOEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 09:04:33 -0500
Received: from bamako.nerim.net ([62.4.17.28]:53744 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592Ab0AGOEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 09:04:31 -0500
Date: Thu, 7 Jan 2010 15:04:29 +0100
From: Jean Delvare <khali@linux-fr.org>
To: srinidhi kasagar <srinidhi.kasagar@stericsson.com>
Cc: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
       "ben-linux@fluff.org" <ben-linux@fluff.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
       Sachin VERMA <sachin.verma@st.com>,
       Andrea GALLO <andrea.gallo@stericsson.com>, <rubini@unipv.it>
Subject: Re: [PATCH 1/2] i2c: Add support for Ux500/Nomadik I2C controller
Message-ID: <20100107150429.585942cd@hyperion.delvare>
In-Reply-To: <1262828335.23286.2.camel@vinay-desktop>
References: <27f8aa32bf40c690930a76ce5e1ee82cec86b248.1262870858.git.srinidhi.kasagar@stericsson.com>
	<1262828335.23286.2.camel@vinay-desktop>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jan 2010 07:08:55 +0530, srinidhi kasagar wrote:
> Adding Alessandro Rubini in CC. I forgot to add you in copy.
> 
> Srinidhi
> On Thu, 2010-01-07 at 14:41 +0100, Srinidhi KASAGAR wrote:
> > This adds support for the ST-Ericsson's I2C
> > block found in Ux500 and Nomadik 8815
> > platforms.
> > 
> > Signed-off-by: srinidhi kasagar <srinidhi.kasagar@stericsson.com>
> > Acked-by: Andrea Gallo <andrea.gallo@stericsson.com>
> > ---
> >  arch/arm/plat-nomadik/include/plat/i2c.h |   31 +
> >  drivers/i2c/busses/Kconfig               |    7 +
> >  drivers/i2c/busses/Makefile              |    1 +
> >  drivers/i2c/busses/i2c-nmk.c             |  957 ++++++++++++++++++++++++++++++

i2c-nomadik.c, please. We're not using FAT16 ;)

> > +static void __exit nmk_i2c_exit(void)
> > +{
> > +       platform_driver_unregister(&nmk_i2c_driver);
> > +       return;

Useless statement.

> > +}

-- 
Jean Delvare
