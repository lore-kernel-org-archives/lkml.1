Return-Path: <linux-kernel-owner+w=401wt.eu-S1758157AbZFOLX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157AbZFOLX5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 07:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbZFOLXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 07:23:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:41827 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364AbZFOLXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 07:23:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,222,1243839600"; 
   d="scan'208";a="524634265"
Date: Mon, 15 Jun 2009 19:19:16 +0800
From: Alek Du <alek.du@intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Ben Dooks <ben-linux@fluff.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpiolib: Add gpio_detect, gpio_debounce and
 gpio_alt_func features to GPIOLIB
Message-ID: <20090615191916.31d95ab7@dxy.sh.intel.com>
In-Reply-To: <20090615100253.GC6106@sirena.org.uk>
References: <20090615171502.2a981bf5@dxy.sh.intel.com>
	<20090615095023.GA19873@fluff.org.uk>
	<20090615100253.GC6106@sirena.org.uk>
Organization: Intel Corp.
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009 18:02:53 +0800
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> On Mon, Jun 15, 2009 at 10:50:23AM +0100, Ben Dooks wrote:
> > On Mon, Jun 15, 2009 at 05:15:02PM +0800, Alek Du wrote:
> 
> > > * gpio_alt_func is to set pin as alternative function or GPIO.
> 
> > gpio_alt_func is feature creep, I don't really belive this is the
> > best place to put it as it will be difficult to actually make this
> > generic for all gpio platforms.
> 
> Since the proposed API just passes a value through to the driver for the
> GPIO chip it looks generic enough - each chip can define whatever set of
> constants it likes.  I'd expect a large proportion of driver specific
> APIs would end up just the same.
> 
> Given the number of manufacturers that don't use a separate term like
> the PXA MFP for the alternative functions of their GPIOs it makes sense
> to have a gpiolib API for this.  Without one you end up having each
> driver needing to add its own API, and since the pins are just referred
> to as GPIOs in the documentation the API will have that in the name and
> look like it ought to be connected with gpiolib.

Mark,
Thanks for the comments. I do believe that API would benefit some GPIO device
drivers. I'm preparing a GPIO driver for one Intel IOH that has GPIO block
needs that API.

Thanks,
Alek
