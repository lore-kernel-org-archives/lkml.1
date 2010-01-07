Return-Path: <linux-kernel-owner+w=401wt.eu-S1752299Ab0AHJ0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab0AHJ0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 04:26:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674Ab0AHJ0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 04:26:46 -0500
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:34833 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751465Ab0AHJ0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 04:26:45 -0500
Subject: RE: [PATCH 1/2] i2c: Add support for Ux500/Nomadik I2C controller
From: srinidhi kasagar <srinidhi.kasagar@stericsson.com>
To: Linus WALLEIJ <linus.walleij@stericsson.com>
Cc: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
       "ben-linux@fluff.org" <ben-linux@fluff.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
       Sachin VERMA <sachin.verma@st.com>,
       Andrea GALLO <andrea.gallo@stericsson.com>, <rubini@unipv.it>
In-Reply-To: <A6D19A13FE030A409EC4362C172E091F0E30CDB5@eseldmw101.eemea.ericsson.se>
References: <27f8aa32bf40c690930a76ce5e1ee82cec86b248.1262870858.git.srinidhi.kasagar@stericsson.com>
	 <A6D19A13FE030A409EC4362C172E091F0E30CDB5@eseldmw101.eemea.ericsson.se>
Content-Type: text/plain
Organization: ST-Ericsson
Date: Fri, 8 Jan 2010 02:39:02 +0530
Message-ID: <1262898542.1026.6.camel@vinay-desktop>
MIME-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 21:37 +0100, Linus WALLEIJ wrote:
> > +++ b/drivers/i2c/busses/i2c-nmk.c
> (...)
> > +	dev->irq = platform_get_irq(pdev, 0);
> > +	ret = request_irq(dev->irq, i2c_irq_handler, IRQF_DISABLED,
> > +				DRIVER_NAME, dev);
> 
> Since I2C IRQs can be a bit tedious, could this be converted
> to a request_threaded_irq()? OK I know that is probably a bit
> intrusive and can very well be done later (so no blocker) but
> think about it.

hmm..I tried using request_threaded_irq, but seems not to be working at
the first step, did not debug further. So, I will post v2 patch fixing
the rest of your comments. Once I have this driver working fully with
threaded implementation, I will post a patch on top of it. Hope this is
OK.

Srinidhi 

