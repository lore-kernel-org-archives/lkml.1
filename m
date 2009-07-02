Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbZGBXQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbZGBXQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 19:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbZGBXQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 19:16:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:52296 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbZGBXQE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 19:16:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,337,1243839600"; 
   d="scan'208";a="529822130"
Date: Fri, 3 Jul 2009 07:16:01 +0800
From: Alek Du <alek.du@intel.com>
To: David Brownell <david-b@pacbell.net>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio: add Intel Moorestown Platform Langwell chip gpio
 driver
Message-ID: <20090703071601.000048f1@unknown>
In-Reply-To: <200907021245.56003.david-b@pacbell.net>
References: <EADF0A36011179459010BDF5142A457501C9F46019@pdsmsx502.ccr.corp.intel.com>
	<200907011628.08799.david-b@pacbell.net>
	<EADF0A36011179459010BDF5142A457501C9F4603D@pdsmsx502.ccr.corp.intel.com>
	<200907021245.56003.david-b@pacbell.net>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.0; i586-pc-mingw32msvc)
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On Fri, 3 Jul 2009 03:45:55 +0800
David Brownell <david-b@pacbell.net> wrote:

> On Wednesday 01 July 2009, Du, Alek wrote:
> > > Is this a dedicated GPIO-only device?  Or is it like e.g. ICH8
> > > which shares that device with other functions?
> > 
> > Yes, the GPIO block is just one function of Langwell chip, the
> > Langwell chip is an IOH (IO hub) for the whole system. But the
> > devices on the chip are all exposed as PCI devices.  
> 
> To be clear:  this PCI function is *only* for GPIO?
> 
> Which is unlike the southbridge chips which have an LPC
> function, which exposes GPIOs along with other stuff.
> (So that LPC function should, arguably, be modeled as an
> MFD parent device; or an adapter to an LPC bus.)
> 

Yes, this PCI function is *only* for GPIO. Each devices on the IOH are
exposed as dedicated PCI functions. It is not a MFD style device.

Thanks,
Alek
