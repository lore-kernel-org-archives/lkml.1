Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbYGXPlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbYGXPlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 11:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbYGXPlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 11:41:09 -0400
Received: from www.tglx.de ([62.245.132.106]:45112 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbYGXPlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 11:41:08 -0400
Date: Thu, 24 Jul 2008 17:38:17 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Ben Dooks <ben-linux@fluff.org>
Cc: "Hans J. Koch" <hjk@linutronix.de>,
       Jonathan Cameron <Jonathan.Cameron@gmail.com>, mgross@linux.intel.com,
       Dmitry Torokhov <dtor@mail.ru>, LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>,
       David Brownell <david-b@pacbell.net>, hmh@hmh.eng.br,
       Jean Delvare <khali@linux-fr.org>,
       spi-devel-general@lists.sourceforge.net,
       Ben Nizette <bn@niasdigital.com>
Subject: Re: [spi-devel-general] [Patch 0/4] IndustrialIO subsystem (ADCs,
	accelerometers etc)
Message-ID: <20080724153816.GE2254@local>
References: <488763AD.4050400@gmail.com> <20080723191918.GC26938@trinity.fluff.org> <20080724074124.GB2254@local> <20080724100144.GA8301@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080724100144.GA8301@fluff.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 11:01:44AM +0100, Ben Dooks wrote:
> On Thu, Jul 24, 2008 at 09:41:25AM +0200, Hans J. Koch wrote:
> > On Wed, Jul 23, 2008 at 08:19:18PM +0100, Ben Dooks wrote:
> > > On Wed, Jul 23, 2008 at 06:00:29PM +0100, Jonathan Cameron wrote:
> > > > Dear All,
> > > > 
> > > > The need for an industrialio subsystem was discussed in
> > > > http://lkml.org/lkml/2008/5/20/135
> > > 
> > > The name is really bad, this sounds like something for doing large
> > > scale industrial process control.
> > 
> > Well, it says "Industrial I/O". To me, this means it handles I/O devices
> > typically found in industrial applications.
> 
> Yes, industrial is generally process control of manufacturing
> processes which in my view is making this sound like it is limiting
> the field of operations.

OK, I agree.

> 
> All the applications we would currently need are things like
> handheld PDA type devices which are hardly 'industrial' or small
> consumer measurement systems.

Well, though the _use_ of such devices might not be "industrial",
_technically_ they are very similar to embedded systems found in
automation or other industrial equipment.

Many of these devices (all that have mmappable memory) can be handled
with a UIO driver, but for the rest (mostly stuff connected to serial
busses), it's important to have a subsystem in the kernel. I really
don't care too much about its name. BTW, before UIO was first published,
its internal name was "Industrial I/O" ;-)

Thanks,
Hans

