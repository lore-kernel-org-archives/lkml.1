Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbZGBPjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbZGBPjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 11:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756712AbZGBPj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 11:39:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:58097 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756693AbZGBPj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 11:39:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,335,1243839600"; 
   d="scan'208";a="704528938"
Date: Thu, 2 Jul 2009 23:38:34 +0800
From: Alek Du <alek.du@intel.com>
To: Andrey Panin <pazke@centrinvest.ru>
CC: David Brownell <david-b@pacbell.net>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] gpio: add Intel Moorestown Platform Langwell chip
 gpio driver
Message-ID: <20090702233834.00004c32@unknown>
In-Reply-To: <20090702140022.GA18313@centrinvest.ru>
References: <20090702204335.4411f6bc@dxy.sh.intel.com>
	<20090702140022.GA18313@centrinvest.ru>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.0; i586-pc-mingw32msvc)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrey,

On Thu, 2 Jul 2009 22:00:22 +0800
Andrey Panin <pazke@centrinvest.ru> wrote:

> On 183, 07 02, 2009 at 08:43:35PM +0800, Alek Du wrote:
> > Changes from v1:
> > 1. driver name changed from lnw.c ==> langwell_gpio.c
> > 2. removed hard coded driver data, now we get it from PCI bar1
> > (platform init code fills it) 3. removed alternative function
> > setting code, it should be called in platform init part. 4. misc.
> > style clean
> > 
> > From abdf5c678c1df2dc5538628bba5578b92ce5ac4e Mon Sep 17 00:00:00
> > 2001 From: Alek Du <alek.du@intel.com>
> > Date: Tue, 30 Jun 2009 12:13:27 +0800
> > Subject: [PATCH] gpio: add Intel Moorestown Platform Langwell chip
> > gpio driver
> > 
> > The Langwell chip is the IO hub for Intel Moorestown platform which
> > has a 64-pin gpio block device inside. It is exposed as a PCI
> > device. We use it to control outside peripheral as well as to do
> > IRQ demuxing. The gpio block uses MSI to request level type
> > interrupt to IOAPIC.
> 
> There is no MODULE_DEVICE_TABLE() in the driver, is this intentional ?
> 
Thanks for the catch, I should add it.

Thanks,
Alek 

