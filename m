Return-Path: <linux-kernel-owner+w=401wt.eu-S1753384AbYGXHpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbYGXHpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 03:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbYGXHoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 03:44:55 -0400
Received: from www.tglx.de ([62.245.132.106]:39798 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279AbYGXHoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 03:44:54 -0400
Date: Thu, 24 Jul 2008 09:41:25 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Jonathan Cameron <Jonathan.Cameron@gmail.com>, mgross@linux.intel.com,
       Dmitry Torokhov <dtor@mail.ru>, LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>,
       David Brownell <david-b@pacbell.net>, hmh@hmh.eng.br,
       Jean Delvare <khali@linux-fr.org>,
       spi-devel-general@lists.sourceforge.net,
       Ben Nizette <bn@niasdigital.com>
Subject: Re: [spi-devel-general] [Patch 0/4] IndustrialIO subsystem (ADCs,
	accelerometers etc)
Message-ID: <20080724074124.GB2254@local>
References: <488763AD.4050400@gmail.com> <20080723191918.GC26938@trinity.fluff.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723191918.GC26938@trinity.fluff.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 08:19:18PM +0100, Ben Dooks wrote:
> On Wed, Jul 23, 2008 at 06:00:29PM +0100, Jonathan Cameron wrote:
> > Dear All,
> > 
> > The need for an industrialio subsystem was discussed in
> > http://lkml.org/lkml/2008/5/20/135
> 
> The name is really bad, this sounds like something for doing large
> scale industrial process control.

Well, it says "Industrial I/O". To me, this means it handles I/O devices
typically found in industrial applications.

>  
> > Firstly thanks to all the people who have contributed to the discussion
> > of this in the past.
> > 
> > In brief the intention is provide a kernel subsystem directed towards the
> > handling on sensors (and later related output devices) such as ADC's,
> > accelerometers and many others.
> 
> We've already got an perfectly good hwmon framework, do we really need
> to do this again?

hwmon is designed for slow I/O. It won't handle an ADC that does a few
megasamples/sec.

Thanks,
Hans

