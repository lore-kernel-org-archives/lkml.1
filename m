Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbXJLC7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbXJLC7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 22:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754504AbXJLC7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 22:59:36 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:33636 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252AbXJLC7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 22:59:35 -0400
X-IronPort-AV: i="4.21,263,1188792000"; 
   d="scan'208"; a="53831765:sNHT28648312"
Subject: Re: [PATCH 1/9] Blackfin SPI driver: use new GPIO API and add
	error handling
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: David Brownell <david-b@pacbell.net>
Cc: Bryan Wu <bryan.wu@analog.com>, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Michael Hennerich <michael.hennerich@analog.com>
In-Reply-To: <200710111446.29725.david-b@pacbell.net>
References: <1192097441-24962-1-git-send-email-bryan.wu@analog.com>
	 <1192097441-24962-2-git-send-email-bryan.wu@analog.com>
	 <200710111446.29725.david-b@pacbell.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Fri, 12 Oct 2007 10:59:28 +0800
Message-Id: <1192157968.6247.1.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 12 Oct 2007 02:59:33.0266 (UTC) FILETIME=[EA5EEF20:01C80C7B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-11 at 14:46 -0700, David Brownell wrote:
> On Thursday 11 October 2007, Bryan Wu wrote:
> > @@ -1182,12 +1198,9 @@ static int __init bfin5xx_spi_probe(struct platform_device *pdev)
> >                 return -ENOMEM;
> >         }
> >  
> > -       if (peripheral_request(P_SPI0_SCK, DRV_NAME) ||
> > -                peripheral_request(P_SPI0_MISO, DRV_NAME) ||
> > -                peripheral_request(P_SPI0_MOSI, DRV_NAME) ) {
> > -
> > +       if (setup_pin_mux(1)) {
> >                 dev_err(&pdev->dev, ": Requesting Peripherals failed\n");
> > -               goto out_error_queue_alloc;
> > +               goto out_error;
> >         }
> >  
> >         drv_data = spi_master_get_devdata(master);
> 
> 
> This doesn't apply against 2.6.23 ... ?

Oops, I missed the first patch in this patch series.
It will be sent as soon as possible.

Thanks a lot
-Bryan
