Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbZJZRH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbZJZRH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 13:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbZJZRHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 13:07:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59393 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486AbZJZRHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 13:07:24 -0400
Date: Mon, 26 Oct 2009 09:48:07 -0700
From: Greg KH <gregkh@suse.de>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Russell King <rmk+kernel@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: platform_device_add_data(pdev, NULL, 0)
Message-ID: <20091026164807.GC28072@suse.de>
References: <20091023202622.GA11843@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091023202622.GA11843@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 23, 2009 at 10:26:22PM +0200, Uwe Kleine-König wrote:
> Hello,
> 
> mfd_add_device() (defined in drivers/mfd/mfd-core.c) is a wrapper do
> allocate platform_devices.
> 
> It contains:
> 
> 	ret = platform_device_add_data(pdev,
> 			cell->platform_data, cell->data_size);
> 
> If cell->data_size is 0 (and so likely cell->platform_data == NULL),
> still pdev->dev.platform_data get assigned ZERO_SIZE_PTR.
> 
> IMHO the result should better be that pdev->dev.platform_data ends being
> NULL, too.  Agreed?

Why?  Is this causing problems somewhere?

thanks,

greg k-h
