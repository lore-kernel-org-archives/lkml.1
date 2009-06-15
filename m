Return-Path: <linux-kernel-owner+w=401wt.eu-S1757019AbZFOMvC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019AbZFOMvC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 08:51:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbZFOMuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 08:50:52 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:40230 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753777AbZFOMuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 08:50:52 -0400
Date: Mon, 15 Jun 2009 13:50:25 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Alek Du <alek.du@intel.com>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpiolib: Add gpio_detect, gpio_debounce and
	gpio_alt_func features to GPIOLIB
Message-ID: <20090615125025.GB19873@fluff.org.uk>
References: <20090615171502.2a981bf5@dxy.sh.intel.com> <20090615095023.GA19873@fluff.org.uk> <20090615100253.GC6106@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615100253.GC6106@sirena.org.uk>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 11:02:53AM +0100, Mark Brown wrote:
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

Yes, however I can see some horrible problems ahead as soon as people
try and then try and standardise the values passed through this. The
GPIO API was meant to be a lightweight way of allowing drivers at
GPIOs, now everyone seems to want to push whatever they feel like in.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
