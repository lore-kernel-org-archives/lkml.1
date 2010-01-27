Return-Path: <linux-kernel-owner+w=401wt.eu-S1754288Ab0A0HIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab0A0HIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 02:08:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754269Ab0A0HIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 02:08:07 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57886 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab0A0HIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 02:08:07 -0500
Date: Wed, 27 Jan 2010 08:07:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg KH <greg@kroah.com>, Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
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
Message-ID: <20100127070752.GB16672@ucw.cz>
References: <4B571DA4.6070603@cam.ac.uk> <20100120153748.GA29401@kroah.com> <4B573501.9090001@jic23.retrosnub.co.uk> <20100122204718.GA15759@kroah.com> <20100123001414.GB14538@core.coreip.homeip.net> <20100123003112.GA7836@kroah.com> <20100126093422.GA3480@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100126093422.GA3480@core.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > Nope. And I am also interested in this since I am sittign on a bunch of
> > > accelerometers, magnetometers, etc drivers that are trying to plug into
> > > input sysbsystem and quite unsure what to do with them.
> > > 
> > > It was OK whch HDAPS and friends when they were using input for
> > > secondary, toyish purposes, but these new drivers trying to use input
> > > devnts as primary API and I am unsure if it is the best solution.
> > > Accelerometer might be used as an input device but not always an input
> > > device.
> > 
> > Yeah, I see it using a joystick interface, which might be acceptable for
> > "toy" devices like you say.
> > 
> > But for "real" ones, we should do something else.
> > 
> > Maybe, for devices that are going to be used by x.org, like the "toy"
> > ones, we stick with the current input interface, but for others, we use
> > a "real" interface, probably through hwmon, so that users can get the
> > real data out in a consistant manner.
> 
> I'd rather have all of them use real interface and then have a bridge
> to input module to enable toyish mode (unless the device in question
> is really truly an input device).

Well, if you look at the PDA class devices, they really use
magnetometers and accelerometers for input. I guess we should look at
better support in input...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
