Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965372Ab0BZQhN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 11:37:13 -0500
Received: from kroah.org ([198.145.64.141]:46997 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965310Ab0BZQhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 11:37:11 -0500
Date: Fri, 26 Feb 2010 08:37:02 -0800
From: Greg KH <greg@kroah.com>
To: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
Cc: Nitin Shah <Nitin.Shah@kpitcummins.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Liam Girdwood <lrg@kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: Touch Screen Drivers for Dialog da9052
Message-ID: <20100226163702.GE16213@kroah.com>
References: <F56EA673D3E56E48804FE2B0D23EFD2D21346D8A9D@KCINPUNHJCMS01.kpit.com>
 <4B87CEE4.9090104@jic23.retrosnub.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B87CEE4.9090104@jic23.retrosnub.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 01:38:44PM +0000, Jonathan Cameron wrote:
> On 02/26/10 12:36, Nitin Shah wrote:
> > Hi,
> > 
> > We have developed Touch Screen (TSI) Drivers for Dialog da9052 Power
> > Management IC.
> > 
> > We have tested this driver on Samsung SMDK-6410 board. If any one
> > needs test application tor testing this driver, we will provide the
> > same which we have used for testing.
> > 
> > For more details about the attached drives please refer the README
> > file inside "da9052_drivers.zip".
> > 
> > We would like to incorporate this driver into Linux mainline kernel.
> > 
> > Please test the driver and provide your valuable comments and
> > feedback.
> > 
> > Thanks & Regards, Nitin Shah
> Hi Nitin,
> 
> Couple of initial points.  Please take a look at the guidance on
> Submitting patches in the Documentation directory of the linux
> kernel source tree. To get more eyes on code you need to make it
> as simple as possible for people to take a look!
> 
> To move this driver set towards merging, take a look at how the other
> da90xx chips are handled in the current kernel.  Given the chips have
> a lot of different functionality fitting into numerous corners of the
> kernel, that a given user may or may not want to use, they are implemented
> as multifunction devices (drivers/mfd) with children in a number of other
> subsystems.
> 
> Whilst the code you have sent is pretty clear and well commented etc, it
> is going to need a lot of changes to interface with the relevant kernel
> subsystems.
> 
> Perhaps this is one for staging? 

I'll take anything for staging, it just has to build and be
self-contained and have someone who is working on getting it merged to
the main kernel tree.

thanks,

greg k-h
