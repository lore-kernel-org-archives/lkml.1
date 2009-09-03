Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbZICCri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbZICCri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 22:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbZICCrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 22:47:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:65198 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753499AbZICCrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 22:47:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,322,1249282800"; 
   d="scan'208";a="547329986"
Subject: Re: [PATCH V6 1/2] introduce ALS sysfs class
From: Zhang Rui <rui.zhang@intel.com>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Pavel Machek <pavel@ucw.cz>
In-Reply-To: <9b2b86520909021222k6cc49456vc3232e488eef9e37@mail.gmail.com>
References: <1251789947.3483.215.camel@rzhang-dt>
	 <9b2b86520909021222k6cc49456vc3232e488eef9e37@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Thu, 03 Sep 2009 10:45:18 +0800
Message-Id: <1251945918.3483.267.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-03 at 03:22 +0800, Alan Jenkins wrote:
> On 9/1/09, Zhang Rui <rui.zhang@intel.com> wrote:
> >
> > Introduce ALS sysfs class.
> >
> > ALS sysfs class provides a standard sysfs interface for
> > Ambient Light Sensor devices.
> >
> > please read Documentation/ABI/testing/sysfs-class-als for
> > detailed sysfs designs.
> >
> > ﻿CC: Pavel Machek <pavel@ucw.cz>
> > Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> > ---
> 
> > +++ linux-2.6/drivers/als/Kconfig
> > @@ -0,0 +1,10 @@
> > +#
> > +# Ambient Light Sensor sysfs device configuration
> > +#
> > +
> > +menuconfig ALS
> > +	tristate "Ambient Light Sensor sysfs device"
> > +	help
> > +	  This framework provides a generic sysfs interface for
> > +	  Ambient Light Sensor devices.
> > +	  If you want this support, you should say Y or M here.
> 
> Gratuitous nitpick:
> Can this option be made non-visible (or hidden behind CONFIG_EMBEDDED)?
> 
> Maybe you copied the pattern of the thermal sysfs interface - but the
> ACPI thermal driver is useful to keep your computer cool even without
> the sysfs interface.  ALS drivers are useless without the sysfs
> interface, no?
> 
ACPI ALS device driver is the first user of this sysfs class.
I think there will be more native ALS device drivers in the future,
which locate at drivers/als/ and depends on CONFIG_ALS.

thanks,
rui


