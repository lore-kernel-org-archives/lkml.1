Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089Ab0AWAcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab0AWAcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:32:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754369Ab0AWAcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:32:12 -0500
Received: from kroah.org ([198.145.64.141]:35028 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754353Ab0AWAcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:32:09 -0500
Date: Fri, 22 Jan 2010 16:31:12 -0800
From: Greg KH <greg@kroah.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
       Jonathan Cameron <jic23@cam.ac.uk>, LKML <linux-kernel@vger.kernel.org>,
       Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>,
       "Frysinger, Michael" <Michael.Frysinger@analog.com>,
       "Getz, Robin" <Robin.Getz@analog.com>,
       Jean Delvare <khali@linux-fr.org>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>,
       "Zhang, Xing Z" <xing.z.zhang@intel.com>,
       Ira Snyder <iws@ovro.caltech.edu>
Subject: Re: [RFC] Staging:IIO: New ABI
Message-ID: <20100123003112.GA7836@kroah.com>
References: <4B571DA4.6070603@cam.ac.uk>
 <20100120153748.GA29401@kroah.com>
 <4B573501.9090001@jic23.retrosnub.co.uk>
 <20100122204718.GA15759@kroah.com>
 <20100123001414.GB14538@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100123001414.GB14538@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 22, 2010 at 04:14:15PM -0800, Dmitry Torokhov wrote:
> On Fri, Jan 22, 2010 at 12:47:18PM -0800, Greg KH wrote:
> > On Wed, Jan 20, 2010 at 04:53:21PM +0000, Jonathan Cameron wrote:
> > > I am not aware of these. Could you direct me to the current api? Also note that these
> > > aren't the actual alarms, merely a means of enabling the relevant event on the related
> > > event character device. 
> > 
> > Hm, I thought we had an accelerator interface somewhere...
> > 
> 
> Nope. And I am also interested in this since I am sittign on a bunch of
> accelerometers, magnetometers, etc drivers that are trying to plug into
> input sysbsystem and quite unsure what to do with them.
> 
> It was OK whch HDAPS and friends when they were using input for
> secondary, toyish purposes, but these new drivers trying to use input
> devnts as primary API and I am unsure if it is the best solution.
> Accelerometer might be used as an input device but not always an input
> device.

Yeah, I see it using a joystick interface, which might be acceptable for
"toy" devices like you say.

But for "real" ones, we should do something else.

Maybe, for devices that are going to be used by x.org, like the "toy"
ones, we stick with the current input interface, but for others, we use
a "real" interface, probably through hwmon, so that users can get the
real data out in a consistant manner.

thanks,

greg k-h
