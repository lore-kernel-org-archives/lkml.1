Return-Path: <linux-kernel-owner+w=401wt.eu-S1751624AbYGXKC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbYGXKC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 06:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbYGXKCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 06:02:50 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:63939 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750744AbYGXKCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 06:02:49 -0400
Date: Thu, 24 Jul 2008 11:01:44 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Ben Dooks <ben-linux@fluff.org>,
       Jonathan Cameron <Jonathan.Cameron@gmail.com>, mgross@linux.intel.com,
       Dmitry Torokhov <dtor@mail.ru>, LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>,
       David Brownell <david-b@pacbell.net>, hmh@hmh.eng.br,
       Jean Delvare <khali@linux-fr.org>,
       spi-devel-general@lists.sourceforge.net,
       Ben Nizette <bn@niasdigital.com>
Subject: Re: [spi-devel-general] [Patch 0/4] IndustrialIO subsystem (ADCs,
	accelerometers etc)
Message-ID: <20080724100144.GA8301@fluff.org.uk>
References: <488763AD.4050400@gmail.com> <20080723191918.GC26938@trinity.fluff.org> <20080724074124.GB2254@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080724074124.GB2254@local>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 09:41:25AM +0200, Hans J. Koch wrote:
> On Wed, Jul 23, 2008 at 08:19:18PM +0100, Ben Dooks wrote:
> > On Wed, Jul 23, 2008 at 06:00:29PM +0100, Jonathan Cameron wrote:
> > > Dear All,
> > > 
> > > The need for an industrialio subsystem was discussed in
> > > http://lkml.org/lkml/2008/5/20/135
> > 
> > The name is really bad, this sounds like something for doing large
> > scale industrial process control.
> 
> Well, it says "Industrial I/O". To me, this means it handles I/O devices
> typically found in industrial applications.

Yes, industrial is generally process control of manufacturing
processes which in my view is making this sound like it is limiting
the field of operations.

All the applications we would currently need are things like
handheld PDA type devices which are hardly 'industrial' or small
consumer measurement systems.

> >  
> > > Firstly thanks to all the people who have contributed to the discussion
> > > of this in the past.
> > > 
> > > In brief the intention is provide a kernel subsystem directed towards the
> > > handling on sensors (and later related output devices) such as ADC's,
> > > accelerometers and many others.
> > 
> > We've already got an perfectly good hwmon framework, do we really need
> > to do this again?
> 
> hwmon is designed for slow I/O. It won't handle an ADC that does a few
> megasamples/sec.
> 
> Thanks,
> Hans

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
